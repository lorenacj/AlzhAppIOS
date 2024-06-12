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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var carerViewModel: CarerViewModel

    var onPatientAdded: () -> Void = {}

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
                        if validateFields() {
                            // Lógica de registro
                            let patient = AddPatientDTO(
                                name: nameText,
                                lastname: lastnameText,
                                birthdate: birthdate,
                                height: Int(heightValue) ?? 0,
                                weight: Float(weightValue) ?? 0,
                                disorder: disorderText,
                                passportId: dniText
                            )
                            print("DEBUG: Adding patient: \(patient)")
                            Task {
                                do {
                                    try await carerViewModel.addPatient(patient: patient)
                                    alertMessage = LocalizedString.registrocorrecto
                                    showAlert = true
                                } catch {
                                    alertMessage = "Error al registrar: \(error.localizedDescription)"
                                    showAlert = true
                                }
                            }
                        } else {
                            showAlert = true
                        }
                    }
                    .padding(.bottom, 10)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(LocalizedString.register), message: Text(alertMessage), dismissButton: .default(Text(LocalizedString.okbutton)) {
                            if alertMessage == LocalizedString.registrocorrecto {
                                presentationMode.wrappedValue.dismiss()
                                onPatientAdded()
                            }
                        })
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .navigationBarTitle("Agregar Paciente", displayMode: .inline)
        .onTapGesture {
            endEditing()
        }
    }
    
    func validateFields() -> Bool {
        if dniText.isEmpty {
            alertMessage = LocalizedString.camposVacios
            print("DEBUG: dniText is empty")
            return false
        } else if nameText.isEmpty {
            alertMessage = LocalizedString.camposVacios
            print("DEBUG: nameText is empty")
            return false
        } else if lastnameText.isEmpty {
            alertMessage = LocalizedString.camposVacios
            print("DEBUG: lastnameText is empty")
            return false
        } else if weightValue.isEmpty {
            alertMessage = LocalizedString.camposVacios
            print("DEBUG: weightValue is empty")
            return false
        } else if heightValue.isEmpty {
            alertMessage = LocalizedString.camposVacios
            print("DEBUG: heightValue is empty")
            return false
        } else if disorderText.isEmpty {
            alertMessage = LocalizedString.camposVacios
            print("DEBUG: disorderText is empty")
            return false
        } else if !isValidDNI(dniText) {
            alertMessage = LocalizedString.dniNoValido
            print("DEBUG: dniText is not valid")
            return false
        } else if Float(weightValue) == nil {
            alertMessage = LocalizedString.pesoNoValido
            print("DEBUG: weightValue is not a valid float")
            return false
        } else if Int(heightValue) == nil {
            alertMessage = LocalizedString.alturaNoValida
            print("DEBUG: heightValue is not a valid int")
            return false
        } else if birthdate > Date() {
            alertMessage = LocalizedString.fechaNoValida
            print("DEBUG: birthdate is in the future")
            return false
        }
        return true
    }
    
    func isValidDNI(_ dni: String) -> Bool {
        let dniRegex = "^[0-9]{8}[A-Za-z]$"
        let dniTest = NSPredicate(format:"SELF MATCHES %@", dniRegex)
        return dniTest.evaluate(with: dni)
    }
}

#Preview {
    TabNavigationBar()
}
