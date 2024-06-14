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
                        Text("Código del paciente: \(carerViewModel.patientCode ?? "")")
                            .onTapGesture {
                                if let code = carerViewModel.patientCode {
                                    UIPasteboard.general.string = code
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .contextMenu {
                                Button(action: {
                                    if let code = carerViewModel.patientCode {
                                        UIPasteboard.general.string = code
                                    }
                                }) {
                                    Text("Copiar")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
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
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .opacity(0.8)
                    )
                    .padding(.bottom, 5)
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(1)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Detalle del paciente")
        .onAppear {
            carerViewModel.fetchPatientCode(patientID: patient.id ?? 0)
        }
        .navigationBarExitFamily(
            title: "Detalle del paciente", trailingButton: AnyView(Button(action: {
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
