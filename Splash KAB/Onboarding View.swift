import SwiftUI

struct OnboardingView: View {
    @State private var isNextPageActive = false

    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 80)

                VStack(spacing: -5) {
                    Text("مرحباً بك في")
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)

                    Text("كبسولة")
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#00BCD4"))
                        .multilineTextAlignment(.center)
                }

                VStack(alignment: .leading, spacing: 20) {
                    OnboardingFeatureRow(icon: "checkmark.circle.fill",
                                         text: "نحن هنا لمساعدتك في التعرف على أدويتك بسهولة وأمان.")
                    OnboardingFeatureRow(icon: "pill.circle.fill",
                                         text: "كل دواء له اسم، تركيبة، وفائدة مختلفة. دعنا نساعدك في التعرف على أدويتك من خلال تقنية مسح سريعة وسهلة.")
                    OnboardingFeatureRow(icon: "mic.circle.fill",
                                         text: "تطبيقنا يعتمد على الصوت لمساعدتك في كل خطوة. إذا كنت بحاجة إلى مساعدة صوتية، فقط قل “ساعدني”.")
                    OnboardingFeatureRow(icon: "hand.thumbsup.circle.fill",
                                         text: "لضمان أفضل تجربة، يرجى تفعيل بعض الأذونات مثل الكاميرا والصوت. هذا سيمكنك من استخدام تطبيقنا بشكل كامل.")
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)

                Spacer()

                // Next Button
                Button(action: {
                    // Save to UserDefaults before navigating
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    isNextPageActive = true
                }) {
                    Text("التالي")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.horizontal, 25)
                }
                .padding(.bottom, 30)

                NavigationLink(destination: StartPageView(), isActive: $isNextPageActive) {
                    EmptyView()
                }
            }

            NavigationLink(destination: ScanView()) {
                Text("تخطي")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#2CA9BC"))
                    .padding()
            }
            .position(x: 70, y: 25)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .frame(maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}

struct OnboardingFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#2CA9BC"))
                .font(.system(size: 40))
            Text(text)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
