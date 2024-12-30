//
//  SplashView.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI

struct SplashView: View {
    @State private var animateScale: CGFloat = 1.0
    @State private var isNavigationActive = false
    @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .padding(EdgeInsets(top: -33, leading: -200, bottom: -380, trailing: 0))

                Image("Patterns")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .padding(EdgeInsets(top: -33, leading: -20, bottom: -380, trailing: 0))

                ZStack {
                    Circle()
                        .fill(Color(hex: "#00BCD4"))
                        .frame(width: 160, height: 160)
                        .scaleEffect(animateScale)
                        .opacity(2 - animateScale)
                        .offset(x: -30, y: -5)

                    Circle()
                        .fill(Color(hex: "#00BCD4"))
                        .frame(width: 120, height: 120)
                        .scaleEffect(animateScale)
                        .opacity(2 - animateScale)
                        .offset(x: -30, y: -5)

                    VStack(spacing: 20) {
                        Image("AppIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .offset(x: -30, y: -5)

                        Text("كبسولة")
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(y: 50)
                            .offset(x: -20)
                    }
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            animateScale = 1.5
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isNavigationActive = true
                        }
                    }
                }

                NavigationLink(
                    destination: destinationView(),
                    isActive: $isNavigationActive
                ) {
                    EmptyView()
                }
            }
        }
    }

    @ViewBuilder
    private func destinationView() -> some View {
        if hasSeenOnboarding {
            StartPageView()
        } else {
            OnboardingView()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
