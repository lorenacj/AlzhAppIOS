//
//  ModifyPatientView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 7/6/24.
//

import SwiftUI

struct ModifyPatientView: View {
    @State private var dniText: String
    @State private var nameText: String
    @State private var lastnameText: String
    @State private var weightValue: String
    @State private var heightValue: String
    @State private var disorderText: String
    @State private var birthdate: Date
    @State private var isTapped = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var idPatient: Int
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: CarerViewModel

    init(patient: PatientsCareBO) {
        _idPatient = State(initialValue: patient.id ?? 0)
        _dniText = State(initialValue: patient.passportid ?? "")
        _nameText = State(initialValue: patient.name ?? "")
        _lastnameText = State(initialValue: patient.lastname ?? "")
        _weightValue = State(initialValue: "\(patient.weight ?? 0)")
        _heightValue = State(initialValue: "\(Int(patient.height ?? 0))") // Formatear como entero
        _disorderText = State(initialValue: patient.disorder ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let birthdateString = patient.birthdate, let birthdate = dateFormatter.date(from: birthdateString) {
            _birthdate = State(initialValue: birthdate)
        } else {
            _birthdate = State(initialValue: Date())
        }
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
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
                    .keyboardType(.decimalPad)
                    
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
                    
                    CustomButtonStyle(text: "actualizar", isTapped: $isTapped) {
                        print("DEBUG: Update button tapped")
                        
                        // Validación de campos
                        if validateFields() {
                            // Lógica de actualización
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let birthdateString = dateFormatter.string(from: birthdate)

                            let patientDTO = UpdatePatientDTO(
                                id: idPatient,
                                name: nameText,
                                lastname: lastnameText,
                                birthdate: birthdateString,
                                height: Int(heightValue) ?? 0,
                                weight: Double(weightValue) ?? 0.0,
                                disorder: disorderText,
                                passportId: dniText
                            )
                            Task {
                                print("DEBUG: Starting Task to update patient")
                                do {
                                    try await viewModel.updatePatient(patient: patientDTO)
                                    alertMessage = "Actualización correcta"
                                    print("DEBUG: Update successful")
                                } catch {
                                    alertMessage = "Error al actualizar: \(error.localizedDescription)"
                                    print("DEBUG: Update failed with error: \(error)")
                                }
                                showAlert = true
                            }
                        } else {
                            showAlert = true
                        }
                    }
                    .padding(.bottom, 10)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Actualización"), message: Text(alertMessage), dismissButton: .default(Text(LocalizedString.okbutton)) {
                            if alertMessage == "Actualización correcta" {
                                presentationMode.wrappedValue.dismiss()
                            }
                        })
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .navigationBarTitle("Editar Paciente", displayMode: .inline)
        .onTapGesture {
            endEditing()
        }
    }
    
    func validateFields() -> Bool {
        if nameText.isEmpty {
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
        } else if Float(weightValue) == nil {
            alertMessage = LocalizedString.pesoNoValido
            print("DEBUG: weightValue is not a valid float")
            return false
        } else if Int(heightValue) == nil {
            alertMessage = LocalizedString.alturaNoValida
            print("DEBUG: heightValue is not a valid double")
            return false
        } else if birthdate > Date() {
            alertMessage = LocalizedString.fechaNoValida
            print("DEBUG: birthdate is in the future")
            return false
        }
        return true
    }
}

#Preview {
    TabNavigationBar()
}
