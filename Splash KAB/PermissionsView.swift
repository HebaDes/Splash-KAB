//import SwiftUI
//import AVFoundation
//import SwiftUI
//import AVFoundation
//import CoreML
//import Vision
//
//struct PermissionView: View {
//    
//    @State private var cameraPermissionGranted: Bool? = nil
//    @State private var microphonePermissionGranted: Bool? = nil
//    @State private var accessibilityPermissionGranted: Bool? = nil
//    @State private var showVoiceOverAlert: Bool = false
//    @Binding var ShowUp : Bool
//
//    
//    // Function to request camera and microphone permissions
//    func requestPermissions() {
//        // Request Camera Access
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            DispatchQueue.main.async {
//                cameraPermissionGranted = granted
//            }
//        }
//        
//        // Request Microphone Access
//        AVAudioApplication.requestRecordPermission { granted in
//            DispatchQueue.main.async {
//                microphonePermissionGranted = granted
//            }
//        }
//        
//        // Check if VoiceOver is enabled
//        if !UIAccessibility.isVoiceOverRunning {
//            DispatchQueue.main.async {
//                showVoiceOverAlert = true
//                accessibilityPermissionGranted = false
//            }
//        } else {
//            DispatchQueue.main.async {
//                accessibilityPermissionGranted = true
//            }
//        }
//    }
//
//    var body: some View {
//            VStack(spacing: 20) {
//                // Title
//                Text("الأذونات المطلوبة")
//                    .font(.system(size: 42))
//                    .fontWeight(.bold)
//                    .multilineTextAlignment(.center)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .offset(y: 90)
//                    .padding(.horizontal, 20)
//                
//                // Subtitle
//                Text("السماح بالوصول إلى الكاميرا والميكروفون لاستخدام كبسولة والاستفادة من التطبيق بأكبر قدر ممكن.")
//                    .multilineTextAlignment(.center)
//                    .font(.system(size: 20))
//                    .padding(.horizontal,4 )
//                    .offset(y: 90)
//                    .fixedSize(horizontal: false, vertical: true)
//                    .padding(.horizontal, 10)
//                
//                Spacer(minLength: 20)
//                
//                // Permissions List
//                VStack(spacing: 20) {
//                    // Camera Access
//                    HStack {
//                        // Camera icon on the right
//                        ZStack {
//                            Image(systemName: "video.circle.fill")
//                                .resizable()
//                                .frame(width: 60, height: 60)
//                                .foregroundColor(Color(red: 0.173, green: 0.663, blue: 0.737))
//                            
//                            if let granted = cameraPermissionGranted {
//                                Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
//                                    .resizable()
//                                    .frame(width: 24, height: 24)
//                                    .foregroundColor(granted ? Color(red: 0.157, green: 0.655, blue: 0.271) : Color(red: 0.827, green: 0.184, blue: 0.184))
//                                    .offset(x: 20, y: 20)
//                            }
//                        }
//                        .frame(width: 70, height: 70)
//                        
//                        // Text on the left
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("الوصول إلى الكاميرا")
//                                .font(.system(size: 20, weight: .bold))
//                                .multilineTextAlignment(.leading)
//                                .foregroundColor(.black)
//                            
//                            Text("استخدم الكاميرا الخاصة بك لمسح عينة الدواء المطلوبة والتعرف عليها.")
//                                .font(.system(size: 16))
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.leading)
//                                .fixedSize(horizontal: false, vertical: true)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding(.horizontal, 20)
//                    .offset(y: -20)
//                    
//                    // Microphone Access
//                    HStack {
//                        // Microphone icon on the right
//                        ZStack {
//                            Image(systemName: "microphone.circle.fill")
//                                .resizable()
//                                .frame(width: 60, height: 60)
//                                .foregroundColor(Color(red: 0.173, green: 0.663, blue: 0.737))
//                            
//                            if let granted = microphonePermissionGranted {
//                                Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
//                                    .resizable()
//                                    .frame(width: 24, height: 24)
//                                    .foregroundColor(granted ? Color(red: 0.157, green: 0.655, blue: 0.271) : Color(red: 0.827, green: 0.184, blue: 0.184))
//                                    .offset(x: 20, y: 20)
//                            }
//                        }
//                        .frame(width: 70, height: 70)
//                        
//                        // Text on the left
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("الوصول إلى الميكروفون")
//                                .font(.system(size: 20, weight: .bold))
//                                .multilineTextAlignment(.leading)
//                                .foregroundColor(.black)
//                            
//                            Text("استخدم الميكروفون الخاص بك لطلب المساعدة.")
//                                .font(.system(size: 16))
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.leading)
//                                .fixedSize(horizontal: false, vertical: true)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding(.horizontal, 20)
//                    .offset(y: -20)
//                    
//                    // Accessibility Section
//                    HStack {
//                        // Accessibility icon on the right
//                        ZStack {
//                            Image(systemName: "accessibility.fill")
//                                .resizable()
//                                .frame(width: 60, height: 60)
//                                .foregroundColor(Color(red: 0.173, green: 0.663, blue: 0.737))
//                            
//                            if let granted = accessibilityPermissionGranted {
//                                Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle.fill")
//                                    .resizable()
//                                    .frame(width: 24, height: 24)
//                                    .foregroundColor(granted ? Color(red: 0.157, green: 0.655, blue: 0.271) : Color(red: 0.827, green: 0.184, blue: 0.184))
//                                    .offset(x: 20, y: 20)
//                            }
//                        }
//                        .frame(width: 70, height: 70)
//                        
//                        // Text on the left
//                        VStack(alignment: .leading, spacing: 5) {
//                            Text("الوصول إلى التعليق الصوتي")
//                                .font(.system(size: 20, weight: .bold))
//                                .multilineTextAlignment(.leading)
//                                .foregroundColor(.black)
//                            
//                            Text("استخدم ميزة الـ VoiceOver لتمكين التطبيق من قراءة النصوص بصوت عالٍ.")
//                                .font(.system(size: 16))
//                                .foregroundColor(.gray)
//                                .multilineTextAlignment(.leading)
//                                .fixedSize(horizontal: false, vertical: true)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .padding(.horizontal, 20)
//                    .offset(y: -20)
//                }
//                
//                Spacer()
//                
//                NavigationLink(destination: ScanView()){
//                    Text("استمرار")
//                        .font(.system(size: 20, weight: .bold))
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color(red: 0.173, green: 0.663, blue: 0.737)) // #2CA9BC
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .offset(y: -80) // Apply a slight upward offset
//                }
//                .padding(.horizontal, 20)
//                
//                // Show VoiceOver Permission Alert
//                if showVoiceOverAlert {
//                    Text("يرجى تمكين VoiceOver في إعدادات الجهاز.")
//                        .font(.system(size: 18))
//                        .foregroundColor(.red)
//                        .multilineTextAlignment(.center)
//                        .padding()
//                        .accessibilityLabel("VoiceOver Permission Required")
//                }
//            }
//            .padding(.horizontal, 20) // Add global margin on both sides of the screen
//            .navigationBarBackButtonHidden(true) // Hide back button in PermissionView
//
//    }
//}
//
//
//
//struct PermissionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PermissionView(ShowUp: <#Binding<Bool>#>)
//    }
//}
