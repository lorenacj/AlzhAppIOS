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


    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    HStack {
                        CustomButtonStyle(text: "Crear eventos", isTapped: $isTapped) {
                            
                        }
                        CustomButtonStyle(text: "Visualizar eventos", isTapped: $isTapped) {
                            
                        }
                    }
                    .padding()
                    VStack (alignment: .leading){
                        HStack {
                            Text("Ficha del paciente")
                            Button {
                                //editar
                            } label: {
                                Image(systemName: AppIcons.edit.rawValue)
                                    .resizable()
                                    .frame(width: 20,height: 20)
                                    .foregroundStyle(AppColors.lightBlue)
                            }

                        }
                            .font(.custom(AppFonts.OpenSans.semibold.rawValue, size: 20))
                        Text("\(patient.name ?? "Unknown") \(patient.lastname ?? "Unknown")")
                        Text("Fecha de nacimiento: \(patient.birthdate ?? "Unknown")")
                        Text("Disorder: \(patient.disorder ?? "Unknown")")
                        Text("DNI: \(patient.passportid ?? "Unknown")")
                        Text("Peso: \(patient.weight ?? 0)")
                        Text("Altura: \(patient.height ?? 0)")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.white).opacity(0.8)
                    )
                    .padding(.bottom,5)
                    Text("Participantes:")
                    //api que te dice los ROLE_CARER que pertenecen a la unidad familiar == patient.id
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .navigationBarExitFamily(
            title: "Detalle del Paciente",
            trailingButton: AnyView(exitFamilyButton)
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Confirmar"),
                message: Text("¿Estás seguro de salir de la unidad familiar? AVISO: Si eres el último cuidador de la unidad familiar, esta y el perfil del paciente serán eliminados."),
                primaryButton: .destructive(Text("Salir")) {
                    // llamada a la api para salir de la unidad familiar
                },
                secondaryButton: .cancel()
            )
        }
    }

    private var exitFamilyButton: some View {
        Button(action: {
            showAlert = true
        }) {
            Image(systemName: AppIcons.exitfamily.rawValue)
                .foregroundColor(.black)
        }
    }
}
