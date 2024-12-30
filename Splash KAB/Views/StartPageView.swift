//
//  StartPageView.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//

import SwiftUI

struct StartPageView: View {
    @State private var isCameraPageActive = false

    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Phone Image
                Image("Phone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 400)
                    .padding(.top, 60)
                    .offset(x: 20)

                // Main Title
                Text("يمكنك الآن البدء بمسح الأدوية!")
                    .font(.title)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Subtitle
                Text("ابدأ الآن واستمتع بتجربة سهلة للتعرف على أدويتك بدقة وراحة")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                // Start Button
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "hasSeenStartPage")
                    isCameraPageActive = true
                }) {
                    Text("ابدأ")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 77)

                // Navigation Link to the Camera Page
                NavigationLink(destination: ScanView().navigationBarBackButtonHidden(true), isActive: $isCameraPageActive) {
                    EmptyView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
