import SwiftUI

struct OnboardingView: View {
    @State private var isNextPageActive = false

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 80)

                // MARK: - Header
                VStack(spacing: -5) {
                    Text("مرحباً بك في")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)

                    Text("كبسولة")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#00BCD4"))
                        .multilineTextAlignment(.center)
                }

                // MARK: - Features List
                VStack(alignment: .leading, spacing: 20) {
                    OnboardingFeatureRow(
                        icon: "checkmark.circle.fill",
                        text: "نحن هنا لمساعدتك في التعرف على أدويتك بسهولة وأمان."
                    )
                    OnboardingFeatureRow(
                        icon: "pill.circle.fill",
                        text: "كل دواء له اسم، تركيبة، وفائدة مختلفة. دعنا نساعدك في التعرف على أدويتك من خلال تقنية مسح سريعة وسهلة."
                    )
                    OnboardingFeatureRow(
                        icon: "mic.circle.fill",
                        text: "تطبيقنا يعتمد على الصوت لمساعدتك في كل خطوة. إذا كنت بحاجة إلى مساعدة صوتية، فقط استدعي سيري \"Siri\"."
                    )
                    OnboardingFeatureRow(
                        icon: "hand.thumbsup.circle.fill",
                        text: "لضمان أفضل تجربة، يرجى تفعيل بعض الأذونات مثل الكاميرا والصوت. هذا سيمكنك من استخدام تطبيقنا بشكل كامل."
                    )
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)

                Spacer()

                // MARK: - Next Button
                Button(action: {
                    // Save to UserDefaults before navigating
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    isNextPageActive = true
                }) {
                    Text("التالي")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.horizontal, 25)
                }
                .padding(.bottom, 30)

                // Hidden Navigation Link
                NavigationLink(destination: StartPageView(), isActive: $isNextPageActive) {
                    EmptyView()
                }
            }

//            // MARK: - Skip Button
//            NavigationLink(destination: ScanView()) {
//                Text("تخطي")
//                    .font(.body)
//                    .foregroundColor(Color(hex: "#2CA9BC"))
//                    .padding()
//            }
//            .position(x: 70, y: 25)
//            .onTapGesture {
//                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding") // Save onboarding status
//            }
 }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden(true) // Hide back button
    }
}

// MARK: - Feature Row
struct OnboardingFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#2CA9BC"))
                .font(.largeTitle)
            Text(text)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
        }
    }
}

// MARK: - Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
