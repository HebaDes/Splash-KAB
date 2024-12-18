import SwiftUI

struct RequiredPermissionsView: View {
    var body: some View {
        ZStack {
            // Background image
            //Image("Patterns2")
               // .resizable()
                //.scaledToFill()
               // .ignoresSafeArea()
               // .padding(EdgeInsets(top: -44, leading: -100, bottom: 20, trailing: 0))
            
            VStack(spacing: 30) {
                // Title
                Text("الأذونات المطلوبة")
                    .font(.system(size: 43))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#000000"))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(y: -40) // Moves the first title text up slightly

                // Subtitle
                Text("السماح بالوصول إلى الكاميرا والميكروفون لاستخدام “كبسولة” والاستفادة من التطبيق بأكبر قدر ممكن.")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .offset(y: -35)
                
                // Camera Section
                HStack {
                    Image(systemName: "video.circle.fill")
                        .foregroundColor(Color(hex: "#2CA9BC"))
                        .font(.system(size: 55))
                        .padding(.leading, 10) // Move icon to the left
                    
                    VStack(alignment: .leading) { // Align text to the left
                        Text("الوصول إلى الكاميرا")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading) // Left-aligned text
                        
                        Text("استخدم الكاميرا الخاصة بك لمسح عينة الدواء المطلوبة والتعرف عليها.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading) // Left-aligned text
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure the text aligns left
                }
                .padding(.horizontal, 25) // Ensures the text and icon have proper space from the edge
                
                // Microphone Section
                HStack {
                    Image(systemName: "mic.circle.fill")
                        .foregroundColor(Color(hex: "#2CA9BC"))
                        .font(.system(size: 55))
                        .padding(.leading, 10) // Move icon to the left
                    
                    VStack(alignment: .leading) { // Align text to the left
                        Text("الوصول إلى الميكروفون")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading) // Left-aligned text
                        
                        Text("استخدم الميكروفون الخاص بك لطلب المساعدة.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading) // Left-aligned text
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure the text aligns left
                }
                .padding(.horizontal, 25) // Ensures the text and icon have proper space from the edge
                
                // Accessibility Section
                HStack {
                    Image(systemName: "accessibility.fill")
                        .foregroundColor(Color(hex: "#2CA9BC"))
                        .font(.system(size: 55))
                        .padding(.leading, 10) // Move icon to the left
                    
                    VStack(alignment: .leading) { // Align text to the left
                        Text("الوصول إلى التعليق الصوتي")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading) // Left-aligned text
                        
                        Text("استخدم ميزة VoiceOver لتمكين التطبيق من قراءة النصوص بصوت عالي.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading) // Left-aligned text
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure the text aligns left
                }
                .padding(.horizontal, 25) // Ensures the text and icon have proper space from the edge
                
                // Continue Button
                Button(action: {
                    // Handle the button action
                    print("Continue Button Tapped!")
                }) {
                    Text("استمرار")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 50) // Adjusting spacing between button and text
            }
            .padding(.top, 90) // Give some space from top
            
        }
    }
}

struct RequiredPermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        RequiredPermissionsView()
    }
}
