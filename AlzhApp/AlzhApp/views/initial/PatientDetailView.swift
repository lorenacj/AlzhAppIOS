//
//  PatientDetailView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 8/6/24.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: PatientsCareBO
    @State private var showAlert = false
    @State private var isTapped = false
    @State private var isTapped2 = false
    @EnvironmentObject var carerViewModel: CarerViewModel

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    HStack {
                        
//                        NavigationLink(destination: CreateEventsView(patientID: nil)
//                                        .environmentObject(carerViewModel)) {
//                                            CustomButtonStyle(text: "Crear eventos", isTapped: $isTapped, action: {})
//                        }
//                        NavigationLink(destination: IndividualEventsView(patientID: patient.id, carerViewModel: _carerViewModel)) {
//                            Text("Visualizar eventos")
//                                .padding()
//                                .background(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .fill(.white).opacity(0.6)
//                                )
//                        }
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Ficha del paciente")
                            NavigationLink(destination: ModifyPatientView(patient: patient)) {
                                Image(systemName: AppIcons.edit.rawValue)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(AppColors.lightBlue)
                            }
                        }
                        .font(.custom(AppFonts.OpenSans.semibold.rawValue, size: 20))
                        
                        Text("\(patient.name ?? "Unknown") \(patient.lastname ?? "Unknown")")
                        Text("Fecha de nacimiento: \(patient.birthdate ?? "Unknown")")
                        Text("Disorder: \(patient.disorder ?? "Unknown")")
                        Text("DNI: \(patient.passportid ?? "Unknown")")
                        Text("Peso: \(patient.weight?.formatted(.number.precision(.fractionLength(2))) ?? "0.00")Kg")
                        Text("Altura: \(patient.height?.formatted(.number.precision(.integerLength(0))) ?? "0")cm")
                        HStack {
                            Text("Medicinas: ")
                            NavigationLink(destination: MedicinesView(medicines: patient.medicines ?? [])) {
                                Image(systemName: "pills")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(AppColors.lightBlue)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .opacity(0.8)
                    )
                    .padding(.bottom, 5)
                    
                    Text("Participantes:")
                    // API para obtener los ROLE_CARER que pertenecen a la unidad familiar == patient.id
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .navigationBarTitle("Detalle del Paciente", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirmar"),
                message: Text("¿Estás seguro de salir de la unidad familiar? AVISO: Si eres el último cuidador de la unidad familiar, esta y el perfil del paciente serán eliminados."),
                primaryButton: .destructive(Text("Salir")) {
                    // Llamada a la API para salir de la unidad familiar
                },
                secondaryButton: .cancel()
            )
        }
    }
}
