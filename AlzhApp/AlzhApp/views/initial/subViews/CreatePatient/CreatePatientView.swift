//
//  CreatePatientView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 2/6/24.
//
import SwiftUI

struct CreatePatientView: View {
    @State private var dniText: String = ""
    @State private var nameText: String = ""
    @State private var lastnameText: String = ""
    @State private var weightValue: String = ""
    @State private var heightValue: String = ""
    @State private var disorderText: String = ""
    @State private var birthdate: Date = Date()
    @State private var isTapped = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    // DNI
                    CustomTextFieldAuth(
                        title: LocalizedString.dni,
                        placeholder: LocalizedString.dniplaceholder,
                        text: Binding(
                            get: { self.dniText },
                            set: { self.dniText = $0 ?? "" }
                        ),
                        isSecureField: false
                    )
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    
                    // Nombre
                    CustomTextFieldAuth(
                        title: LocalizedString.name,
                        placeholder: LocalizedString.placeholderGeneral,
                        text: Binding(
                            get: { self.nameText },
                            set: { self.nameText = $0 ?? "" }
                        ),
                        isSecureField: false
                    )
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    
                    // Apellidos
                    CustomTextFieldAuth(
                        title: LocalizedString.lastname,
                        placeholder: LocalizedString.placeholderGeneral,
                        text: Binding(
                            get: { self.lastnameText },
                            set: { self.lastnameText = $0 ?? "" }
                        ),
                        isSecureField: false
                    )
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    
                    // Peso
                    CustomTextFieldAuth(
                        title: LocalizedString.pesoPaciente,
                        placeholder: LocalizedString.placeholder_peso,
                        text: Binding(
                            get: { self.weightValue },
                            set: { self.weightValue = $0 ?? "" }
                        ),
                        isSecureField: false
                    )
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    .keyboardType(.decimalPad)
                    
                    // Altura
                    CustomTextFieldAuth(
                        title: LocalizedString.alturaPaciente,
                        placeholder: LocalizedString.placeholder_altura,
                        text: Binding(
                            get: { self.heightValue },
                            set: { self.heightValue = $0 ?? "" }
                        ),
                        isSecureField: false
                    )
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    .keyboardType(.numberPad)
                    
                    // Disorder
                    CustomPickerField(
                        title: LocalizedString.disorderPaciente,
                        placeholder: LocalizedString.elegirOpcion,
                        selectedOption: $disorderText
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Birthday
                    CustomDateField(
                        title: LocalizedString.birthdate,
                        placeholder: "",
                        date: Binding(
                            get: { self.birthdate },
                            set: { self.birthdate = $0 ?? Date() }
                        )
                    )
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    CustomButtonStyle(text: LocalizedString.register, isTapped: $isTapped) {
                        if dniText.isEmpty || nameText.isEmpty || lastnameText.isEmpty || weightValue.isEmpty || heightValue.isEmpty || disorderText.isEmpty || birthdate > Date() {
                            alertMessage = LocalizedString.camposVacios
                        } else if birthdate > Date() {
                            alertMessage = "Fecha no valida"
                            #warning("Cambiar a localized")
                        } else {
                            // Lógica de registro
                            alertMessage = LocalizedString.registrocorrecto
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
