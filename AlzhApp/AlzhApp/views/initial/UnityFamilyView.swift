//
//  UnityFamilyView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 2/6/24.
//
import SwiftUI

struct UnityFamilyView: View {
    let product: ProductBO
    @State private var showAlert = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Text(product.title)
                        .font(.largeTitle)
                    Text(product.description)
                        .padding()
                    Text("Price: \(product.price, specifier: "%.2f")")
                    Text("Rating: \(product.rating)")
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .navigationBarExitFamily(
            title: "Unidad Familiar",
            trailingButton: AnyView(exitFamilyButton)
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirmar"),
                message: Text("¿Estás seguro de salir de la unidad familiar? AVISO: Si eres el último cuidador de la unidad familiar, esta y el perfil del paciente serán eliminados."),
                primaryButton: .destructive(Text("Salir")) {
#warning("Cambiar a nsLocalized")
#warning("falta api")
                    // llamada a la api para salir de la unidad familiar
                },
                secondaryButton: .cancel()
            )
        }
    }

    
    private var exitFamilyButton: some View {
        Button(action: {
            showAlert = true
        }) {
            Image(systemName: AppIcons.exitfamily.rawValue)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    UnityFamilyView(product: ProductBO(title: "Sample Product", type: .vegan, description: "This is a sample product description", imageURL: URL(string: "https://example.com/image.png")!, height: 100, width: 100, price: 9.99, rating: 5))
}
