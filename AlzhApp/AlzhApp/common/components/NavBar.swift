//  NavBar.swift
//  AlzhApp
//
//  Created by lorena.cruz on 2/6/24.
//

import SwiftUI
import Foundation

// MARK: -  ---------------  NAVBAR BASE -------------
struct NavigationBarBase: ViewModifier {
    var title: String
    var trailingButton: AnyView?

    func body(content: Content) -> some View {
        content
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(trailing: trailingButton)
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
    func navigationBar(title: String, trailingButton: AnyView? = nil) -> some View {
        self.modifier(NavigationBarBase(title: title, trailingButton: trailingButton))
    }
}

// MARK: -  --------------- NAVBAR ADD FAMILY -------------
struct NavigationBarAddFamily: ViewModifier {
    var title: String
    @State private var showSheet = false
    @State private var familyCode = ""

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(false)
            .navigationBar(title: title, trailingButton: AnyView(addFamilyButton))
            .sheet(isPresented: $showSheet) {
                AddFamilySheet(showSheet: $showSheet, familyCode: $familyCode)
            }
    }

    private var addFamilyButton: some View {
        Button(action: {
            showSheet = true
        }) {
            Image(systemName: "person.3.fill")
                .foregroundColor(.black)
        }
    }
}

extension View {
    func navBarAddFamily(title: String) -> some View {
        self.modifier(NavigationBarAddFamily(title: title))
    }
}

// MARK: -  --------------- SHEET ADD FAMILY CODE -------------
struct AddFamilySheet: View {
    @Binding var showSheet: Bool
    @Binding var familyCode: String
    
    var body: some View {
        ZStack {
            LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text(LocalizedString.agregarUF)
                    .font(.headline)
                Text(LocalizedString.introducirCodigoUF)
                    .font(.subheadline)
                TextField(LocalizedString.codigoUF, text: $familyCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                HStack {
                    Button(LocalizedString.cancelButton) {
                        showSheet = false
                    }
                    .padding()
                    Spacer()
                    Button(LocalizedString.okbutton) {
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
// MARK: -  --------------- NAVBAR OUT FAMILY -------------
struct NavigationBarExitFamily: ViewModifier {
    var title: String
    var trailingButton: AnyView

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(false)
            .navigationBar(title: title, trailingButton: trailingButton)
    }
}

extension View {
    func navigationBarExitFamily(title: String, trailingButton: AnyView) -> some View {
        self.modifier(NavigationBarExitFamily(title: title, trailingButton: trailingButton))
    }
}
