//
//  NavBar.swift
//  AlzhApp
//
//  Created by lorena.cruz on 2/6/24.
//

import SwiftUI
import Foundation

struct NavigationBarAddFamily: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    @State private var showSheet = false
    @State private var familyCode = ""

    func body(content: Content) -> some View {
        content
            .modifier(NavigationBarDefault()) // Reutilizar NavigationBarDefault
            .navigationBarItems(trailing:
                Button(action: {
                    showSheet = true
                }) {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.black)
                }
            )
            .sheet(isPresented: $showSheet) {
                AddFamilySheet(showSheet: $showSheet, familyCode: $familyCode)
            }
    }
}

struct AddFamilySheet: View {
    @Binding var showSheet: Bool
    @Binding var familyCode: String
    
    var body: some View {
        ZStack {
            LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Agregar a Familia")
                    .font(.headline)
                Text("Introduce el código de la familia")
                    .font(.subheadline)
                TextField("Código de la familia", text: $familyCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    Button("Cancelar") {
                        showSheet = false
                    }
                    .padding()
                    Spacer()
                    Button("OK") {
                        // Aquí se haría la comprobación del código por API
                        // Realizar la llamada a la API con familyCode
                        // validateFamilyCode(familyCode)
                        print("Código introducido: \(familyCode)")
                        showSheet = false
                    }
                    .padding()
                }
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .padding()
        }
    }
}

extension View {
    func navBarAddFamily() -> some View {
        self.modifier(NavigationBarAddFamily())
    }
}

struct NavigationBarDefault: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(Text("Familias"), displayMode: .inline)
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
                let navigationBar = UINavigationBar.appearance()
                navigationBar.standardAppearance = appearance
                navigationBar.scrollEdgeAppearance = appearance
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()
            }
    }
}

extension View {
    func navBarDefault() -> some View {
        self.modifier(NavigationBarDefault())
    }
}
