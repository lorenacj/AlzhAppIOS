//
//  CreatePatientView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 2/6/24.
//
import SwiftUI

struct CreatePatientView: View {
    @State private var dniText: String? = ""
    @State private var passwordText: String? = ""
    @State private var nameText: String? = ""
    @State private var lastnameText: String? = ""
    @State private var weightValue: Float? = nil
    @State private var heightValue: Int? = nil
    @State private var disorderText: String? = ""
    @State private var birthdate: Date? = nil
    @State private var isTapped = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
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
                    //weight
                    CustomTextFieldAuth(title: LocalizedString.pesoPaciente, placeholder: LocalizedString.placeholder_peso, text: $weightValue, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                        .keyboardType(.decimalPad)
                    //height
                    CustomTextFieldAuth(title: LocalizedString.alturaPaciente, placeholder: LocalizedString.placeholder_altura, text: $heightValue, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                        .keyboardType(.numberPad)
                        //Disorder
                        CustomPickerField(title: LocalizedString.disorderPaciente, placeholder: LocalizedString.elegirOpcion, selectedOption: $disorderText)
                            .frame(maxWidth: .infinity)
                        //birthday
                        CustomDateField(title: LocalizedString.birthdate, placeholder: "", date: $birthdate)
                            .frame(maxWidth: .infinity)
                    Spacer()
                    CustomButtonStyle(text: LocalizedString.register, isTapped: $isTapped) {
                        if dniText?.isEmpty ?? true || passwordText?.isEmpty ?? true || nameText?.isEmpty ?? true || lastnameText?.isEmpty ?? true {
                            alertMessage = LocalizedString.camposVacios
                        } else {
                            // Lógica de registro
                        }
                        showAlert = true
                    }
                    .padding(.bottom, 10)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(LocalizedString.register), message: Text(alertMessage), dismissButton: .default(Text(LocalizedString.okbutton)))
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .navBarDefault(title: LocalizedString.agregarPaciente)
        .onTapGesture {
            endEditing()
        }
    }
}

#Preview {
    NavigationView {
        CreatePatientView()
    }
}
