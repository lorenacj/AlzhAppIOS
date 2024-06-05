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
    
    @StateObject private var viewModel = CarerViewModel()
    
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
                            .font(.custom("OpenSans-Regular", size: 40))
                            .foregroundColor(.white)
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
                                .foregroundColor(Color.blue)
                                .opacity(1)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 40)
                        }
                        Spacer()
                        NavigationLink(destination: TabNavigationBar(), isActive: $navigateToInitialView) {
                            EmptyView()
                        }
                        CustomButtonStyle(text: LocalizedString.login, isTapped: $isTapped) {
                            if dniText?.isEmpty ?? true || passwordText?.isEmpty ?? true {
                                alertMessage = LocalizedString.camposVacios
                                showAlert = true
                                isLoginSuccessful = false
                            } else {
                                viewModel.loginCarer(username: dniText ?? "", password: passwordText ?? "")
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
            .onTapGesture {
                endEditing()
            }
            .onReceive(viewModel.$isLoginSuccessful) { success in
                if success {
                    alertMessage = LocalizedString.loginCorrecto
                    dniText = ""
                    passwordText = ""
                    showAlert = true
                    isLoginSuccessful = true
                } else if let errorText = viewModel.errorText {
                    alertMessage = LocalizedString.loginIncorrecto
                    showAlert = true
                    print("Error: \(errorText)")
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
