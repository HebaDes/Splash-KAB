import SwiftUI

struct StartPageView: View {
    @State private var isCameraPageActive = false

    var body: some View {
        ScrollView { // Makes content scrollable if text size increases
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // MARK: - Phone Image
                    Image("Phone")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 350, maxHeight: 400) // Maintains size limits
                        .padding(.top, 60)
                        .offset(x: 20)
                        .accessibilityLabel("Phone illustration") // Accessibility description

                    // MARK: - Main Title
                    Text("يمكنك الآن البدء بمسح الأدوية!")
                        .font(.title) // Dynamic Type scaling
                        .fontWeight(.bold) // Bold
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .minimumScaleFactor(0.5) // Allows text to shrink if necessary
                        .lineLimit(1) // Forces text to fit in ONE line
                        .accessibilityLabel("ابدأ بمسح الأدوية!") // VoiceOver hint

                    // MARK: - Subtitle (Increased Size)
                    Text("ابدأ الآن واستمتع بتجربة سهلة للتعرف على أدويتك بدقة وراحة")
                        .font(.title3) // **Increased size to Title3**
                        .fontWeight(.bold) // **Bold for emphasis**
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .minimumScaleFactor(0.7) // Prevents truncation
                        .accessibilityHint("شرح قصير حول كيفية بدء المسح") // VoiceOver hint

                    Spacer(minLength: 20)

                    // MARK: - Start Button
                    Button(action: {
                        UserDefaults.standard.set(true, forKey: "hasSeenStartPage")
                        isCameraPageActive = true
                    }) {
                        Text("ابدأ")
                            .font(.body) // Dynamic Type scaling
                            .bold() // Bold text
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#2CA9BC"))
                            .cornerRadius(10)
                            .padding(.horizontal, 30)
                            .accessibilityLabel("ابدأ")
                            .accessibilityHint("ابدأ مسح الأدوية الآن")
                    }
                    .padding(.bottom, 30)

                    // MARK: - Navigation Link
                    NavigationLink(
                        destination: ScanView().navigationBarBackButtonHidden(true),
                        isActive: $isCameraPageActive
                    ) {
                        EmptyView()
                    }
                }
                .padding(.bottom, 20)
                .accessibilityHint("اسحب لأسفل باستخدام ثلاثة أصابع لمشاهدة المزيد من التفاصيل.") // Hint for scrolling
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true) // Hides back button
    }
}

// MARK: - Preview
struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
            .environment(\.dynamicTypeSize, .accessibility3) // Test larger text sizes
            .previewDevice("iPhone 15 Pro")
    }
}
