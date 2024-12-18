
import SwiftUI
import AVFoundation

struct PermissionView: View {
    
    @State private var cameraPermissionGranted: Bool? = nil
    @State private var microphonePermissionGranted: Bool? = nil
    @State private var accessibilityPermissionGranted: Bool? = nil
    @State private var showVoiceOverAlert: Bool = false
    
    // Function to request camera and microphone permissions
    func requestPermissions() {
        // Request Camera Access
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                cameraPermissionGranted = granted
            }
        }
        
        // Request Microphone Access
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                microphonePermissionGranted = granted
            }
        }
        
        // Check if VoiceOver is enabled
        if !UIAccessibility.isVoiceOverRunning {
            showVoiceOverAlert = true
            accessibilityPermissionGranted = false
        } else {
            accessibilityPermissionGranted = true
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("الأذونات المطلوبة")
                .font(.system(size: 43))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(y: 77)
            
            // Subtitle
            Text("السماح بالوصول إلى الكاميرا والميكروفون لاستخدام كبسولة والاستفادة من التطبيق بأكبر قدر ممكن.")
                .multilineTextAlignment(.center)
                .font(.system(size: 20))
                .padding(.horizontal, 20)
                .offset(y: 77)
            
            Spacer(minLength: 20)
            
            // Permissions List
            HStack(alignment: .top, spacing: 10) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("الوصول إلى الكاميرا")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.black)
                    
                    Text("استخدم الكاميرا الخاصة بك لمسح عينة الدواء المطلوبة والتعرف عليها.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                ZStack {
                    Image(systemName: "video.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(red: 0.173, green: 0.663, blue: 0.737)) // #2CA9BC
                    
                    if let granted = cameraPermissionGranted {
                        Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24) // Adjust size as needed
                            .foregroundColor(granted ?
                                Color(red: 0.157, green: 0.655, blue: 0.271) : // #28A745
                                Color(red: 0.827, green: 0.184, blue: 0.184)   // #D32F2F
                            )
                            .offset(x: 20, y: 20)

                    }
                }
                .frame(width: 70, height: 70) // Fixed frame size to prevent shifting
            }
            
            // Microphone Access
            HStack(alignment: .top, spacing: 10) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("الوصول إلى الميكروفون")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.black)
                    
                    Text("استخدم الميكروفون الخاص بك لطلب المساعدة.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                ZStack {
                    Image(systemName: "microphone.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(red: 0.173, green: 0.663, blue: 0.737)) // #2CA9BC
                    
                    if let granted = microphonePermissionGranted {
                        Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24) // Adjust size as needed
                            .foregroundColor(granted ?
                                Color(red: 0.157, green: 0.655, blue: 0.271) : // #28A745
                                Color(red: 0.827, green: 0.184, blue: 0.184)   // #D32F2F
                            )
                            .offset(x: 20, y: 20)

                    }
                }
                .frame(width: 70, height: 70) // Fixed frame size to prevent shifting
            }
            
            // Accessibility Section
            HStack(alignment: .top, spacing: 10) {
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("الوصول إلى التعليق الصوتي")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.black)
                    
                    Text("استخدم ميزة الـ VoiceOver لتمكين التطبيق من قراءة النصوص بصوت عالٍ.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                ZStack {
                    Image(systemName: "accessibility.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(red: 0.173, green: 0.663, blue: 0.737)) // #2CA9BC
                    
                    if let granted = accessibilityPermissionGranted {
                        Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24) // Adjust size as needed
                            .foregroundColor(granted ?
                                Color(red: 0.157, green: 0.655, blue: 0.271) : // #28A745
                                Color(red: 0.827, green: 0.184, blue: 0.184)   // #D32F2F
                            )
                            .offset(x: 20, y: 20)

                    }
                }
                .frame(width: 70, height: 70) // Fixed frame size to prevent shifting
            }
            
            
            Spacer()
            
            Button(action: {
                requestPermissions() // Call the request permissions function to trigger pop-ups
            }) {
                Text("استمرار")
                    .font(.system(size: 20, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.173, green: 0.663, blue: 0.737)) // #2CA9BC
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .offset(y: -45) // Apply a slight upward offset
            }
            .padding(.horizontal, 20)
            
        
            // Show VoiceOver Permission Alert
            if showVoiceOverAlert {
                Text("يرجى تمكين VoiceOver في إعدادات الجهاز.")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .accessibilityLabel("VoiceOver Permission Required")
            }
        }
        .padding()
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
