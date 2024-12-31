import SwiftUI

struct OnboardingView: View {
    @State private var isNextPageActive = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Header
                VStack(spacing: 10) {
                    // Welcome Text
                    Text(NSLocalizedString("Welcome to ", comment: "Welcome message for Capsule"))
                        .font(.system(size: 40)) // Larger Font Size
                        .fontWeight(.bold) // Bold
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        .accessibilityAddTraits(.isHeader)

                    // App Name
                    Text(NSLocalizedString("Capsule App Name", comment: "Capsule App Name"))
                        .font(.system(size: 40)) // Larger Font Size
                        .fontWeight(.bold) // Bold
                        .foregroundColor(Color(hex: "#00BCD4"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .accessibilityAddTraits(.isHeader)
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
                .padding(.horizontal, 15) // Reduced padding for margins
                .accessibilityHint("Swipe down with three fingers to hear more instructions.")

                Spacer(minLength: 20)

                // MARK: - Next Button
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    isNextPageActive = true
                }) {
                    Text(NSLocalizedString("Next Button", comment: "Next Button Text"))
                        .font(.body) // Dynamic Type
                        .fontWeight(.bold) // Bold
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.horizontal, 15) // Reduced padding
                }
                .padding(.bottom, 20) // Moved button slightly up
                .accessibilityLabel("Next Button")
                .accessibilityHint("Navigates to the next page.")

                // MARK: - Navigation Link
                NavigationLink(destination: StartPageView().navigationBarBackButtonHidden(true), isActive: $isNextPageActive) {
                    EmptyView()
                }
            }
            .padding(.horizontal, 15) // Reduced padding for margins
            .padding(.top, 40)
            .padding(.bottom, 20) // Reduced bottom padding
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .accessibilityHint("This page contains multiple instructions. Swipe down with three fingers to scroll through the instructions.")
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
                .font(.system(size: 36)) // Enlarged icon size
                .accessibilityLabel("Icon") // VoiceOver announces this as an icon

            Text(text)
                .font(.body) // Dynamic Type
                .fontWeight(.bold) // Bold
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineSpacing(5)
                .accessibilityLabel(text)
        }
        .padding(.horizontal, 10) // Added horizontal padding for alignment
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environment(\.dynamicTypeSize, .accessibility3) // Test scaling
            .previewDevice("iPhone 15 Pro")
    }
}
