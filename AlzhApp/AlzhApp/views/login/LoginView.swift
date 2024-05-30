//
//  LoginView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import SwiftUI

struct LoginView: View {
    @State private var dniText: String = ""
    @State private var passwordText: String = ""
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
                        Text(LocalizedString.alzhapp)
                            .font(.custom(AppFonts.OpenSans.regular.rawValue, size: 40))
                            .foregroundStyle(.white)
                            .bold()
                            .shadow(color: .black, radius: 3, x: 0, y: 0)
                            .padding(.bottom, 20)
                        CustomTextFieldAuth(title: LocalizedString.dni, placeholder: LocalizedString.dniplaceholder, text: $dniText, isSecureField: false)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: .infinity)
                        CustomTextFieldAuth(title: LocalizedString.password, placeholder: LocalizedString.placeholderGeneral, text: $passwordText, isSecureField: true)
                            .padding(.horizontal, 40)
                            .frame(maxWidth: .infinity)
                        NavigationLink(destination: RegisterView()) {
                            Text(LocalizedString.noTieneCuenta)
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.darkBlue)
                                .opacity(1)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 40)
                        }
                        Spacer()
                        NavigationLink(destination: InitialView(), isActive: $navigateToInitialView) {
                            EmptyView()
                        }
                        CustomButtonStyle(text: LocalizedString.login, isTapped: $isTapped) {
                            if dniText.isEmpty || passwordText.isEmpty {
                                alertMessage = LocalizedString.camposVacios
                                showAlert = true
                                isLoginSuccessful = false // Asegurarse de que no navegue
                            } else {
                                alertMessage = LocalizedString.loginCorrecto
                                dniText = ""
                                passwordText = ""
                                showAlert = true
                                isLoginSuccessful = true
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text(LocalizedString.validacion),
                                message: Text(alertMessage),
                                dismissButton: .default(Text(LocalizedString.okbutton)) {
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
        }
    }
}

#Preview {
    LoginView()
}
