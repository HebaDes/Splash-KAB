import SwiftUI

struct StartPageView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Main Image
                Image("Phone")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 400)
                    .padding(.top, 60)
                    .offset(x: 20) // Move image slightly to the left

                // Title Text
                Text("يمكنك الآن البدء بمسح الأدوية!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Subtitle Text
                Text("ابدأ الآن واستمتع بتجربة سهلة للتعرف على أدويتك بدقة وراحة")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                Spacer()

                // Start Button
                NavigationLink(destination: ScanView()) {
                    Text("ابدأ")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2CA9BC"))
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .padding(.bottom, 77)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}