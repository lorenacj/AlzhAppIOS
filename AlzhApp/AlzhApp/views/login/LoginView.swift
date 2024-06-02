//
//  LoginView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import SwiftUI

struct LoginView: View {
    @State private var dniText: String? = ""
    @State private var passwordText: String? = ""
    @State private var isTapped = false
    @State private var isLoginSuccessful = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToInitialView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer()
                        Image("logo")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Text("AlzhApp") // Asegúrate de tener una cadena aquí en lugar de LocalizedString
                            .font(.custom("OpenSans-Regular", size: 40))
                            .foregroundColor(.white)
                            .bold()
                            .shadow(color: .black, radius: 3, x: 0, y: 0)
                            .padding(.bottom, 20)
                        CustomTextFieldAuth(title: "DNI", placeholder: "Ingrese su DNI", text: $dniText, isSecureField: false)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: .infinity)
                        CustomTextFieldAuth(title: "Contraseña", placeholder: "Ingrese su contraseña", text: $passwordText, isSecureField: true)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: .infinity)
                        NavigationLink(destination: RegisterView()) {
                            Text("¿No tiene cuenta?")
                                .font(.system(size: 12))
                                .foregroundColor(Color.blue)
                                .opacity(1)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 40)
                        }
                        Spacer()
                        NavigationLink(destination: TabNavigationBar(), isActive: $navigateToInitialView) {
                            EmptyView()
                        }
                        CustomButtonStyle(text: "Iniciar Sesión", isTapped: $isTapped) {
                            if dniText?.isEmpty ?? true || passwordText?.isEmpty ?? true {
                                alertMessage = "Todos los campos son obligatorios"
                                showAlert = true
                                isLoginSuccessful = false // Asegurarse de que no navegue
                            } else {
                                alertMessage = "Inicio de sesión correcto"
                                dniText = ""
                                passwordText = ""
                                showAlert = true
                                isLoginSuccessful = true
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Validación"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK")) {
                                    if isLoginSuccessful {
                                        navigateToInitialView = true
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                }
                .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
                .opacity(0.8)
            }
            .onTapGesture {
                endEditing()
            }
        }
    }
}

#Preview {
    LoginView()
}
