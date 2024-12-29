import SwiftUI

// SplashView: The initial splash screen with animation
struct splashView: View {
    @State private var animateScale: CGFloat = 1.0 // Animation state for scaling effect
    @State private var isNavigationActive = false // State to trigger navigation
    
    var body: some View {
        ZStack {
            // Background image covering the entire screen
            Image("Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .padding(EdgeInsets(top: -33, leading: -200, bottom: -380, trailing: 0))
            
            // Separate stack for Patterns image
            Image("Patterns")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .padding(EdgeInsets(top: -33, leading: -20, bottom: -380, trailing: 0))
            
            // AppIcon with heartbeat effect and Arabic text below it
            ZStack {
                // Heartbeat effect with two circles below the AppIcon
                Circle()
                    .fill(Color(hex: "#00BCD4")) // First circle
                    .frame(width: 160, height: 160)
                    .scaleEffect(animateScale)
                    .opacity(2 - animateScale) // Fades out as it scales up
                    .offset(x: -30, y: -5)
                
                Circle()
                    .fill(Color(hex: "#00BCD4")) // Second circle
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateScale)
                    .opacity(2 - animateScale)
                    .offset(x: -30, y: -5)
                
                VStack(spacing: 20) {
                    // AppIcon in the center of the screen
                    Image("AppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .offset(x: -30, y: -5) // Slightly moves AppIcon left and up
                    
                    // Arabic Text "كبسولة"
                    Text("كبسولة")
                        .font(.title) // Custom font "SF Pro"
                        .fontWeight(.bold)
                        .foregroundColor(.white) // White text color
                        .multilineTextAlignment(.center) // Center-align the text
                        .offset(y: 50) // Adjusted to move text slightly up
                        .offset(x: -20) // Keeps the text aligned with the AppIcon
                }
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        animateScale = 1.5 // Pulse effect
                    }
                    
                    // Set a timer to navigate after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isNavigationActive = true
                    }
                }
            }
            
            // Navigation Link to the Onboarding view when the flag is true
            NavigationLink(destination: OnboardingView(), isActive: $isNavigationActive) {
                EmptyView()
            }
        }
    }
}
