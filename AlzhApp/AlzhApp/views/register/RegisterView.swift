import SwiftUI

struct RegisterView: View {
    @State private var dniText: String? = ""
    @State private var passwordText: String? = ""
    @State private var nameText: String? = ""
    @State private var lastnameText: String? = ""
    @State private var telephoneText: String? = ""
    @State private var isTapped = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var viewModel = CarerViewModel()

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 150, height: 150)
                    // DNI
                    CustomTextFieldAuth(title: LocalizedString.dni, placeholder: LocalizedString.dniplaceholder, text: $dniText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    // Nombre
                    CustomTextFieldAuth(title: LocalizedString.name, placeholder: LocalizedString.placeholderGeneral, text: $nameText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    // Apellidos
                    CustomTextFieldAuth(title: LocalizedString.lastname, placeholder: LocalizedString.placeholderGeneral, text: $lastnameText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    // Teléfono
                    CustomTextFieldAuth(title: LocalizedString.telephone, placeholder: LocalizedString.placeholderGeneral, text: $telephoneText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                        .keyboardType(.phonePad)
                    // Contraseña
                    CustomTextFieldAuth(title: LocalizedString.password, placeholder: LocalizedString.placeholderGeneral, text: $passwordText, isSecureField: true)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    CustomButtonStyle(text: LocalizedString.register, isTapped: $isTapped) {
                        if dniText?.isEmpty ?? true || passwordText?.isEmpty ?? true || nameText?.isEmpty ?? true || lastnameText?.isEmpty ?? true || telephoneText?.isEmpty ?? true {
                            alertMessage = LocalizedString.camposVacios
                            showAlert = true
                        } else {
                            guard let dni = dniText, let password = passwordText, let name = nameText, let lastname = lastnameText, let telephone = telephoneText else {
                                alertMessage = "Todos los campos son obligatorios"
                                showAlert = true
                                return
                            }
                            
                            if isValidDNI(dni: dni) {
                                if isValidTelephone(telephone: telephone) {
                                    let carer = CarerBO(
                                        name: name,
                                        lastname: lastname,
                                        telephone: telephone,
                                        username: dni,
                                        password: password
                                    )
                                    viewModel.registerCarer(carer: carer)
                                } else {
                                    // Teléfono no válido
                                    alertMessage = LocalizedString.registroErrorTelefono
                                    showAlert = true
                                }
                            } else {
                                // DNI no válido
                                alertMessage = LocalizedString.registroErrorDni
                                showAlert = true
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .alert(isPresented: $showAlert) {
                        if alertMessage == LocalizedString.registrocorrecto {
                            return Alert(title: Text(LocalizedString.register), message: Text(alertMessage), dismissButton: .default(Text(LocalizedString.okbutton)) {
                                self.presentationMode.wrappedValue.dismiss()
                            })
                        } else {
                            return Alert(title: Text(LocalizedString.register), message: Text(alertMessage), dismissButton: .default(Text(LocalizedString.okbutton)))
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .navigationBar(title: LocalizedString.register)
        .onTapGesture {
            endEditing()
        }
        .onReceive(viewModel.$isRegisterSuccessful) { success in
            if success {
                alertMessage = LocalizedString.registrocorrecto
                dniText = ""
                passwordText = ""
                nameText = ""
                lastnameText = ""
                telephoneText = ""
                showAlert = true
            } else if let errorText = viewModel.errorText {
                alertMessage = errorText
                showAlert = true
            }
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
