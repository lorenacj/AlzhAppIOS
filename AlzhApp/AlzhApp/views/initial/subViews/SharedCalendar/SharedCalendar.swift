//  SharedCalendar.swift
//  AlzhApp
//
//  Created by lorena.cruz on 4/6/24.
//

import SwiftUI

struct SharedCalendar: View {
    @EnvironmentObject var carerViewModel: CarerViewModel

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    if carerViewModel.isLoading {
                        ProgressView("Cargando eventos...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                    } else if let errorText = carerViewModel.errorText {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                        Text(errorText)
                            .foregroundColor(.red)
                        Button(action: {
                            Task {
                                carerViewModel.errorText = nil
                                await carerViewModel.getEventsByCarer()
                            }
                        }, label: {
                            Text("Reintentar")
                                .foregroundColor(.white)
                                .padding()
                        })
                        .background(
                            Capsule()
                                .fill(Color.red)
                        )
                    } else if carerViewModel.eventsCarer.isEmpty {
                        Text("No se encontraron eventos.")
                            .foregroundColor(.white)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(carerViewModel.eventsCarer, id: \.id) { event in
                                EventRowView(event: event)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                                    .padding(.horizontal)
                            }
                            .padding()
                        }
                    }
                }
                .navBarAddFamily(title: "Eventos por cuidador", viewModel: carerViewModel)
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .onAppear {
                Task {
                    await carerViewModel.getEventsByCarer()
                }
            }
        }
    }
}

