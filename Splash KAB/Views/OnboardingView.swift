//
//  OnboardingView.swift
//  Splash KAB
//
//  Created by Shamam Alkafri on 30/12/2024.
//


import SwiftUI

struct OnboardingView: View {
    @State private var isNextPageActive = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header
                VStack(spacing: -5) {
                    Text(NSLocalizedString("Welcome to Capsule", comment: "Welcome message for Capsule"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityLabel(NSLocalizedString("Welcome to Capsule", comment: "Accessibility label for welcome message"))
                        .accessibilityHint(NSLocalizedString("Describes the purpose of the Capsule app.", comment: "Accessibility hint for welcome message"))
                        .padding(.top, 40) // Fixed space at the top

                    Text(NSLocalizedString("Capsule App Name", comment: "Capsule App Name"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#00BCD4"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityLabel(NSLocalizedString("Capsule App Name", comment: "Accessibility label for app name"))
                        .accessibilityHint(NSLocalizedString("Describes how the app helps identify medicines.", comment: "Accessibility hint for app name"))
                }

                // MARK: - Features List
                VStack(alignment: .leading, spacing: 25) {
                    OnboardingFeatureRow(
                        icon: "checkmark.circle.fill",
                        text: NSLocalizedString("We are here to help you identify your medicine easily and safely", comment: "Feature text 1")
                    )
                    OnboardingFeatureRow(
                        icon: "pill.circle.fill",
                        text: NSLocalizedString("Each medicine has a name, composition, and different benefit. Let us help you identify your medicines with fast scanning.", comment: "Feature text 2")
                    )
                    OnboardingFeatureRow(
                        icon: "mic.circle.fill",
                        text: NSLocalizedString("Our app relies on voice assistance to guide you at each step. If you need voice assistance, just say ‘help me’.", comment: "Feature text 3")
                    )
                    OnboardingFeatureRow(
                        icon: "hand.thumbsup.circle.fill",
                        text: NSLocalizedString("For the best experience, please enable some permissions like camera and sound. This will enable you to use the full features of our app.", comment: "Feature text 4")
                    )
                }
                .padding(.horizontal, 25)

                Spacer(minLength: 90)

                // MARK: - Next Button
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    isNextPageActive = true
                }) {
                    Text(NSLocalizedString("Next Button", comment: "Next Button Text"))
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.horizontal, 25)
                }
                .padding(.bottom, 10)

                // MARK: - Navigation Link
                NavigationLink(destination: StartPageView().navigationBarBackButtonHidden(true), isActive: $isNextPageActive) {
                    EmptyView()
                }
            }
            .padding(.top, 45)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true) // Hide back button
        .onAppear {
            // Check if the onboarding was already completed
            if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                isNextPageActive = true
            }
        }
    }
}

// MARK: - Feature Row
struct OnboardingFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#2CA9BC"))
                .font(.largeTitle)
            Text(text)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(5)
        }
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

