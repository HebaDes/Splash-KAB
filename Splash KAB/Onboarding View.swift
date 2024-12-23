import SwiftUI

struct OnboardingView: View {
   // @State private var isNextPageActive = false
    //@State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @State private var isNextPageActive = false
       @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding") // Check UserDefaults
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 80) // Increased height of this spacer to move texts down
                
                // Header Text (Arabic welcome message)
                VStack(spacing: -5) {
                    Text(NSLocalizedString("مرحباً بك في", comment: "Welcome message for Capsule"))
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityLabel("Welcome to Capsule")
                        .accessibilityHint("This is the welcome message for the Capsule app.")

                    Text(NSLocalizedString("كبسولة", comment: "Capsule App Name"))
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#00BCD4"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .accessibilityLabel("Capsule App Name")
                        .accessibilityHint("This is the name of the app.")
                }
                
                // First Icon and Text Section (checkmark icon)
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#2CA9BC"))
                        .font(.system(size: 40))
                        .padding(.top, 10)
                        .padding(.leading, 20)
                        .accessibilityLabel("Checkmark Icon")
                        .accessibilityHint("Represents the medicine identification feature.")
                    
                    Text(NSLocalizedString("نحن هنا لمساعدتك في التعرف على أدويتك بسهولة وأمان.", comment: "Purpose of Capsule"))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading) // Left-aligned text for RTL
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                        .padding(.leading, 5) // Reduced padding for RTL layout
                }
                .padding(.trailing, 17) // Ensures proper space on the right for RTL layout

                // Second Icon and Text Section (pill icon)
                HStack {
                    Image(systemName: "pill.circle.fill")
                        .foregroundColor(Color(hex: "#2CA9BC"))
                        .font(.system(size: 40))
                        .padding(.top, 10)
                        .padding(.leading, 20)
                        .accessibilityLabel("Pill Icon")
                        .accessibilityHint("Represents the pill identification feature.")
                    
                    Text(NSLocalizedString("كل دواء له اسم، تركيبة، وفائدة مختلفة. دعنا نساعدك في التعرف على أدويتك من خلال تقنية مسح سريعة وسهلة.", comment: "Scan and identify medicines"))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading) // Left-aligned text for RTL
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.leading, 5) // Reduced padding for RTL layout
                }
                .padding(.trailing, 17) // Ensures proper space on the right for RTL layout

                // Third Icon and Text Section (mic icon)
                HStack {
                    Image(systemName: "mic.circle.fill")
                        .foregroundColor(Color(hex: "#2CA9BC"))
                        .font(.system(size: 40))
                        .padding(.top, 10)
                        .padding(.leading, 20)
                        .accessibilityLabel("Microphone Icon")
                        .accessibilityHint("Represents the microphone feature.")
                    
                    Text(NSLocalizedString("تطبيقنا يعتمد على الصوت لمساعدتك في كل خطوة. إذا كنت بحاجة إلى مساعدة صوتية، فقط قل “ساعدني”.", comment: "Voice assistance feature"))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading) // Left-aligned text for RTL
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.leading, 5) // Reduced padding for RTL layout
                }
                .padding(.trailing, 17) // Ensures proper space on the right for RTL layout

                // Fourth Icon and Text Section (thumbs up icon)
                HStack {
                    Image(systemName: "hand.thumbsup.circle.fill")
                        .foregroundColor(Color(hex: "#2CA9BC"))
                        .font(.system(size: 40))
                        .padding(.top, 10)
                        .padding(.leading, 20)
                        .accessibilityLabel("Thumbs Up Icon")
                        .accessibilityHint("Represents the permissions required.")
                    
                    Text(NSLocalizedString("لضمان أفضل تجربة، يرجى تفعيل بعض الأذونات مثل الكاميرا والصوت. هذا سيمكنك من استخدام تطبيقنا بشكل كامل.", comment: "Permissions needed"))
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading) // Left-aligned text for RTL
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)
                        .padding(.leading, 5) // Reduced padding for RTL layout
                }
                .padding(.trailing, 17) // Ensures proper space on the right for RTL layout
                
                // Next Button (التالي)
//                NavigationLink(destination: StartPageView()) { // Connect the button to the StartPageView
//                    
//                    Text(NSLocalizedString("التالي", comment: "Next button text"))
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color(hex: "#2CA9BC"))
//                        .cornerRadius(10)
//                        .padding(.top, 30)
//                }
//                .padding(.horizontal, 25)
//                
//                Spacer()
                
                
                // Next Button (التالي)
                Button(action: {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding") // Save flag
                    isNextPageActive = true
                }) {
                    Text(NSLocalizedString("التالي", comment: "Next button text"))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.top, 30)
                }
                .padding(.horizontal, 25)

                Spacer()
            }
            
            // Clickable "تخطي" text positioned on the top-left
            NavigationLink(destination: ScanView()) { // Navigate to PermissionView when "تخطي" is tapped
                Text(NSLocalizedString("تخطي", comment: "Skip onboarding"))
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
        .navigationBarBackButtonHidden(true) // Hide back button from the navigation bar
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
