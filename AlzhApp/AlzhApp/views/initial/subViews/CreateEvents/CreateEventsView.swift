//
//  CreateEventsView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 10/6/24.
//

import SwiftUI

struct CreateEventsView: View {
    let patientID: Int?
    @State private var name: String = ""
    @State private var type: String = "Elige"
    @State private var description: String = ""
    @State private var status: String = "Elige"
    @State private var initialDate: Date = Date()
    @State private var finalDate: Date = Date()
    @State private var initialHour: Date = Date()
    @State private var finalHour: Date = Date()
    @State private var isTapped = false
    @State private var showAlert = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var carerViewModel: CarerViewModel
    
    let eventTypes = ["Elige", "Calendario", "Medicina", "Seguimiento"]
    let eventStatuses = ["Elige", "Por hacer", "Hecho"]
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    // Nombre
                    CustomTextFieldEvent(
                        title: "Nombre del Evento",
                        placeholder: "Ingrese el nombre del evento",
                        text: Binding(
                            get: { Optional(self.name) },
                            set: { self.name = $0 ?? "" }
                        ),
                        isSecureField: false
                    )
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    // Tipo
                    pickerFieldEvents(title: "Tipo de Evento", placeholder: "Elige", selection: $type, options: eventTypes)
                    
                    // Descripción
                    CustomTextFieldEvent(
                        title: "Descripción",
                        placeholder: "Ingrese una descripción del evento",
                        text: Binding(
                            get: { Optional(self.description) },
                            set: { self.description = $0 ?? "" }
                        ),
                        isSecureField: false
                    )
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    
                    // Estado
                    pickerFieldEvents(title: "Estado", placeholder: "Elige", selection: $status, options: eventStatuses)
                    // Fecha Inicial
                    CustomEventDateField(
                        title: "Fecha Inicial",
                        placeholder: "",
                        date: Binding(
                            get: { Optional(self.initialDate) },
                            set: { self.initialDate = $0 ?? Date() }
                        )
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Fecha Final
                    CustomEventDateField(
                        title: "Fecha Final",
                        placeholder: "",
                        date: Binding(
                            get: { Optional(self.finalDate) },
                            set: { self.finalDate = $0 ?? Date() }
                        )
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Hora Inicial
                    CustomTimeFieldEvents(
                        title: "Hora Inicial",
                        placeholder: "",
                        time: $initialHour
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Hora Final
                    CustomTimeFieldEvents(
                        title: "Hora Final",
                        placeholder: "",
                        time: $finalHour
                    )
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    CustomButtonStyle(text: "Registrar Evento", isTapped: $isTapped) {
                        if validateFields() {
                            // Formateo de las fechas y horas
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let timeFormatter = DateFormatter()
                            timeFormatter.dateFormat = "HH:mm:ss"
                            
                            let formattedInitialDate = dateFormatter.string(from: initialDate)
                            let formattedFinalDate = dateFormatter.string(from: finalDate)
                            let formattedInitialHour = timeFormatter.string(from: initialHour)
                            let formattedFinalHour = timeFormatter.string(from: finalHour)
                            
                            // Creación del evento
                            let event = AddEventDTO(
                                name: name,
                                type: type,
                                description: description,
                                status: status,
                                initialDate: formattedInitialDate,
                                finalDate: formattedFinalDate,
                                initialHour: formattedInitialHour,
                                finalHour: formattedFinalHour
                            )
                            print("DEBUG: Adding event: \(event)")
                            Task {
                                do {
                                    guard let patientID = patientID else {
                                        alertMessage = "ID del paciente no disponible."
                                        showAlert = true
                                        return
                                    }
                                    print("DEBUG: Calling addEvent on carerViewModel with patientID: \(patientID)")
                                    try await carerViewModel.addEvent(event: event, patientID: patientID)
                                    alertMessage = "Evento registrado correctamente."
                                    print("DEBUG: Event added successfully")
                                    showSuccessAlert = true
                                } catch {
                                    alertMessage = "Error al registrar el evento: \(error.localizedDescription)"
                                    print("DEBUG: Error adding event: \(error.localizedDescription)")
                                    showAlert = true
                                }
                            }
                        } else {
                            print("DEBUG: Validation failed with message: \(alertMessage)")
                            showAlert = true
                        }
                    }
                    .padding(.bottom, 10)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Registrar Evento"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $showSuccessAlert) {
                        Alert(title: Text("Registrar Evento"), message: Text("Evento registrado correctamente."), dismissButton: .default(Text("OK")) {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(1)
        }
        .navigationBarTitle("Crear Evento", displayMode: .inline)
        .onTapGesture {
            endEditing()
        }
    }
    
    private func pickerField(title: String, placeholder: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
            Picker(selection: selection, label: Text(placeholder)) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
        .padding(.horizontal, 40)
    }
    
    private func validateFields() -> Bool {
        if name.isEmpty {
            alertMessage = "El nombre del evento no puede estar vacío."
            print("DEBUG: name is empty")
            return false
        } else if type == "Elige" {
            alertMessage = "Debe seleccionar un tipo de evento."
            print("DEBUG: type is not selected")
            return false
        } else if description.isEmpty {
            alertMessage = "La descripción del evento no puede estar vacía."
            print("DEBUG: description is empty")
            return false
        } else if status == "Elige" {
            alertMessage = "Debe seleccionar un estado para el evento."
            print("DEBUG: status is not selected")
            return false
        } else if initialDate > finalDate {
            alertMessage = "La fecha inicial no puede ser después de la fecha final."
            print("DEBUG: initialDate is after finalDate")
            return false
        }
        return true
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func pickerFieldEvents(title: String, placeholder: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
            Picker(selection: selection, label: Text(placeholder)) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            //.background(Color.white.opacity(0.6))
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 320, height: 40)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.7), lineWidth: 1)
                    .frame(width: 320, height: 40)
            )
        }
        .padding(.horizontal, 40)
    }
}

struct CustomTimeField: View {
    var title: String
    var placeholder: String
    @Binding var time: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
                .padding(.leading, 8)
            DatePicker(
                placeholder,
                selection: $time,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
        .padding(.horizontal, 40)
    }
}

struct CustomTimeFieldEvents: View {
    var title: String
    var placeholder: String
    @Binding var time: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
            DatePicker(
                placeholder,
                selection: $time,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 320, height: 40)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.7), lineWidth: 1)
                    .frame(width: 320, height: 40)
            )
        }
        .padding(.horizontal, 40)
    }
}
