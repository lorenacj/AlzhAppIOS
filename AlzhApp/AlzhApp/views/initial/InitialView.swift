// InitialView.swift
// AlzhApp
//
// Created by lorena.cruz on 2/6/24.
//

import SwiftUI

struct InitialView: View {
    @State private var isTapped = false
    @State private var navigateToCreatePatient = false
    @EnvironmentObject private var carerViewModel: CarerViewModel

    let singleColumn = [
        GridItem(.flexible(minimum: 150, maximum: .infinity), spacing: 1)
    ]

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 5) {
                        if carerViewModel.patients.isEmpty {
                            if let errorText = carerViewModel.errorText {
                                Image(systemName: AppIcons.connection.rawValue)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                                Text(errorText)
                                    .foregroundColor(.white)
                                Button(action: {
                                    carerViewModel.getPatientsByCarer()
                                }, label: {
                                    Text("Reintentar")
                                        .foregroundStyle(.white)
                                        .padding()
                                })
                                .background(
                                    Capsule()
                                        .fill(AppColors.maroon)
                                )
                            } else {
                                ProgressView("Loading patients...")
                            }
                        } else {
                            NavigationLink(destination: CreatePatientView(), isActive: $navigateToCreatePatient) {
                                EmptyView()
                            }
                            CustomButtonStyle(text: LocalizedString.agregarPaciente, isTapped: $isTapped) {
                                navigateToCreatePatient = true
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            LazyVGrid(columns: singleColumn, spacing: 5) {
                                ForEach(carerViewModel.patients, id: \.id) { patient in
                                    PatientRow(patient: patient)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                    }
                    .navBarAddFamily(title: LocalizedString.unidadesFamiliares, viewModel: carerViewModel)
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                    .onTapGesture {
                        endEditing()
                    }
                }
                .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            }
            .onAppear {
                carerViewModel.getPatientsByCarer()
            }
        }
    }
}

struct PatientRow: View {
    let patient: PatientsCareBO
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(patient.name ?? "Unknown")
                .font(.headline)
            Text(patient.lastname ?? "Unknown")
                .font(.subheadline)
            Text("Birthdate: \(patient.birthdate ?? "Unknown")")
                .font(.subheadline)
            Text("Height: \(patient.height ?? 0)")
                .font(.subheadline)
            Text("Weight: \(patient.weight ?? 0.0, specifier: "%.2f")")
                .font(.subheadline)
        }
    }
}

#Preview {
    NavigationView {
        InitialView()
    }
}
