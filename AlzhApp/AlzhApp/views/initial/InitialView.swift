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

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 0) { // Reduce spacing here
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
                            
                            VStack(spacing: 0) { // Reduce spacing here
                                ForEach(carerViewModel.patients, id: \.id) { patient in
                                    PatientRow(patient: patient)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 15) // Reduce padding here
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 2) // Adjust shadow radius here
                                        .padding(.horizontal)
                                    Spacer()
                                        .frame(height: 10)
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
        HStack {
            VStack(alignment: .leading) {
                Image(systemName: "figure.wave")
                    .resizable()
                    .frame(width: 20, height: 35)
                    .foregroundColor(AppColors.maroon)
                    .padding(.trailing, 20)
            }
            VStack(alignment: .leading) {
                Spacer()
                Text(patient.name ?? "Unknown")
                    .font(.headline)
                Text(patient.lastname ?? "Unknown")
                    .font(.subheadline)
                Text("Fecha de nacimiento: \(patient.birthdate ?? "Unknown")")
                    .font(.subheadline)
                Spacer()
            }
        }
        .padding(10) // Adjust padding within the row here
    }
}

#Preview {
    NavigationView {
        InitialView()
    }
}
