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
                        NavigationLink(
                            destination: CreateEventsView(patientID: patient.id)
                                .environmentObject(carerViewModel)
                        ) {
                            Text("Crear eventos")
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white).opacity(0.6)
                                )
                        }
                        
                        NavigationLink(
                            destination: IndividualEventsView(patientID: patient.id)
                                .environmentObject(carerViewModel)
                        ) {
                            Text("Visualizar eventos")
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white).opacity(0.6)
                                )
                        }
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
        .navigationBarExitFamily(
            title: "Detalle del paciente",
            trailingButton: AnyView(Button(action: {
                showAlert = true
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(AppColors.lightBlue)
            })
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirmar"),
                message: Text("¿Estás seguro de salir de la unidad familiar? AVISO: Si eres el último cuidador de la unidad familiar, esta y el perfil del paciente serán eliminados."),
                primaryButton: .destructive(Text("Salir")) {
                    carerViewModel.exitCarerFromPatient(patientID: patient.id ?? 0)
                },
                secondaryButton: .cancel()
            )
        }
    }
}
