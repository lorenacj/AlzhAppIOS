import SwiftUI

struct InitialView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    // Tu contenido aquí
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
                .opacity(0.8)
        }
        .onTapGesture {
            endEditing()
        }
        .navBarAddFamily()
    }
}

#Preview {
    InitialView()
}

