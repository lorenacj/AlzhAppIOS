// InitialView.swift
// AlzhApp
//
// Created by lorena.cruz on 2/6/24.
//

import SwiftUI

struct InitialView: View {
    @State private var isTapped = false
    @State private var navigateToCreatePatient = false
    @State private var selectedPatient: PatientsCareBO?
    @EnvironmentObject private var carerViewModel: CarerViewModel

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
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
                                        .foregroundColor(.white)
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

                            VStack(spacing: 0) {
                                ForEach(carerViewModel.patients, id: \.id) { patient in
                                    NavigationLink(
                                        destination: PatientDetailView(patient: patient),
                                        isActive: Binding(
                                            get: { selectedPatient?.id == patient.id },
                                            set: { isActive in
                                                if isActive {
                                                    selectedPatient = patient
                                                } else {
                                                    selectedPatient = nil
                                                }
                                            }
                                        )
                                    ) {
                                        PatientRow(patient: patient)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 15)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .shadow(radius: 2)
                                            .padding(.horizontal)
                                            .onTapGesture {
                                                selectedPatient = patient
                                            }
                                    }
                                    Spacer().frame(height: 10)
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
            Image(systemName: AppIcons.patient.rawValue)
                .resizable()
                .frame(width: 20, height: 35)
                .foregroundColor(AppColors.pink)
                .padding(.trailing, 20)
            VStack(alignment: .leading) {
                Text(patient.name ?? "Unknown")
                    .font(.headline)
                    .foregroundColor(.black)
                Text(patient.lastname ?? "Unknown")
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text("Fecha de nacimiento: \(patient.birthdate ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
        }
        .padding(10)
    }
}

#Preview {
    NavigationView {
        InitialView()
            .environmentObject(CarerViewModel())
    }
}
