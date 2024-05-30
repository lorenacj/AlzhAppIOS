//
//  RegisterView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 30/5/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var dniText: String = ""
    @State private var passwordText: String = ""
    @State private var nameText: String = ""
    @State private var lastnameText: String = ""
    @State private var telephoneText: String = ""
    @State private var isTapped = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack (spacing:20) {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 150, height: 150)
                    //DNI
                    CustomTextFieldAuth(title: LocalizedString.dni, placeholder: LocalizedString.dniplaceholder, text: $dniText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    //nombre
                    CustomTextFieldAuth(title: LocalizedString.name, placeholder: LocalizedString.placeholderGeneral, text: $nameText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    //apellidos
                    CustomTextFieldAuth(title: LocalizedString.lastname, placeholder: LocalizedString.placeholderGeneral, text: $lastnameText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    //telefono
                    CustomTextFieldAuth(title: LocalizedString.telephone, placeholder: LocalizedString.placeholderGeneral, text: $telephoneText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    //password
                    CustomTextFieldAuth(title: LocalizedString.password, placeholder: LocalizedString.placeholderGeneral, text: $passwordText, isSecureField: true)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    CustomButtonStyle(text: LocalizedString.register, isTapped: $isTapped) {
                        if dniText.isEmpty || passwordText.isEmpty || nameText.isEmpty || lastnameText.isEmpty || telephoneText.isEmpty {
                            alertMessage = LocalizedString.camposVacios
                        } else {
                            if(isValidDNI(dni: dniText)) {
                                if(isValidTelephone(telephone: telephoneText)){
                                    // Si es correcto:
                                    //comprueba que no existe el usuario
                                    //                                    if(user no existe) {
//                                    alertMessage= LocalizedString.registrocorrecto
//                                    } else {
//                                    alertMessage = LocalizedString.registroDuplicado }
                                } else {
                                    //telefono no valido
                                    alertMessage = LocalizedString.registroErrorTelefono
                                }
                            } else {
                                //dni no valido
                                alertMessage = LocalizedString.registroErrorDni
                            }
                            alertMessage = LocalizedString.registrocorrecto
                        }
                        showAlert = true
                    }
                    .padding(.bottom,10)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(LocalizedString.register), message: Text(alertMessage), dismissButton: .default(Text(LocalizedString.okbutton)))
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
    }
    func isValidTelephone(telephone: String) -> Bool {
        let phoneRegex = "^[0-9]{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: telephone)
    }
    
    func isValidDNI(dni: String) -> Bool {
        let dniRegex = "^[0-9]{8}[A-Z]$"
        let dniTest = NSPredicate(format: "SELF MATCHES %@", dniRegex)
        return dniTest.evaluate(with: dni)
    }
}

#Preview {
    RegisterView()
}
