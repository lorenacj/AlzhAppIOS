//
//  IndividualEventsView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 7/6/24.
//
//
//import SwiftUI
//
//struct IndividualEventsView: View {
//    let patientID: Int?
//    @EnvironmentObject var carerViewModel: CarerViewModel
//
//    var body: some View {
//        GeometryReader { proxy in
//            ScrollView {
//                VStack {
//                    Text("Listado de eventos del paciente")
//                        .font(.largeTitle)
//                        .padding(.top, 20)
//
//                    if carerViewModel.isLoading {
//                        ProgressView("Cargando eventos...")
//                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                            .foregroundColor(.white)
//                    } else if let errorText = carerViewModel.errorText {
//                        Image(systemName: "exclamationmark.triangle")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                            .foregroundColor(.red)
//                        Text(errorText)
//                            .foregroundColor(.red)
//                        Button(action: {
//                            Task {
//                                carerViewModel.errorText = nil
//                                await carerViewModel.fetchEvents(for: patientID ?? 0)
//                            }
//                        }, label: {
//                            Text("Reintentar")
//                                .foregroundColor(.white)
//                                .padding()
//                        })
//                        .background(
//                            Capsule()
//                                .fill(Color.red)
//                        )
//                    } else if carerViewModel.events.isEmpty {
//                        Text("No se encontraron eventos.")
//                            .foregroundColor(.white)
//                    } else {
//                        VStack(spacing: 0) {
//                            ForEach(carerViewModel.events, id: \.id) { event in
//                                EventRowView(event: event)
//                                    .frame(maxWidth: .infinity)
//                                    .padding(.vertical, 15)
//                                    .background(Color.white)
//                                    .cornerRadius(8)
//                                    .shadow(radius: 2)
//                                    .padding(.horizontal)
//                            }
//                        }
//                    }
//                }
//                .navigationBarTitle("Eventos de paciente")
//                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
//            }
//            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
//            .onAppear {
//                Task {
//                    await carerViewModel.fetchEvents(for: patientID ?? 0)
//                }
//            }
//        }
//    }
//}
//
//struct EventRowView: View {
//    let event: Event
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(event.name ?? "Unknown")
//                .font(.headline)
//                .foregroundColor(.black)
//            Text(event.description ?? "No description")
//                .font(.subheadline)
//                .foregroundColor(.black)
//        }
//        .padding(10)
//    }
//}
