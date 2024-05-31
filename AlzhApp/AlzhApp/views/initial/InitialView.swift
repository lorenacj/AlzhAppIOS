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
        .navigationBarTitle(Text("Familias"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {

        }) {
            Image(systemName: AppIcons.family.rawValue)
                    .foregroundColor(.black)
            }
        )
        .onAppear {
                    // Configurar la barra de navegación con fondo blanco y opacidad
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithTransparentBackground()
                    appearance.backgroundColor = UIColor.white.withAlphaComponent(0.5) // Fondo blanco con 50% de opacidad
                    appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Color del título

                    let navigationBar = UINavigationBar.appearance()
                    navigationBar.standardAppearance = appearance
                    navigationBar.scrollEdgeAppearance = appearance
                    
                    // Asegurarse de que la transparencia se aplica correctamente
                    navigationBar.setBackgroundImage(UIImage(), for: .default)
                    navigationBar.shadowImage = UIImage()
                }
    }
}

#Preview {
    InitialView()
}

