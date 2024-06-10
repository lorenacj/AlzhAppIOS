//
//  SharedEventsView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 7/6/24.
//

import SwiftUI

struct SharedEventsView: View {
    @StateObject private var viewModel = CarerViewModel()

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Text("Listado de Eventos")
                        .font(.largeTitle)
                        .padding(.top, 20)

                    if let errorText = viewModel.errorText {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                        Text(errorText)
                            .foregroundColor(.red)
                        Button(action: {
                            Task {
                                await viewModel.fetchEvents()
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
                    } else if viewModel.events.isEmpty {
                        ProgressView("Cargando eventos...")
                    } else {
                        ForEach(viewModel.events, id: \.id) { event in
                            EventRowView(event: event)
                        }
                    }
                }
                .navigationBarTitle("Eventos compartidos")
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .onAppear {
                Task {
                    await viewModel.fetchEvents()
                }
            }
        }
    }
}

struct EventRowView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name ?? "")
                .font(.headline)
            Text(event.description ?? "")
                .font(.subheadline)
            Text("Fecha de inicio: \(event.initialDate)")
                .font(.caption)
            Text("Hora de inicio: \(event.initialHour)")
                .font(.caption)
            Text("Fecha de finalización: \(event.finalDate)")
                .font(.caption)
            Text("Hora de finalización: \(event.finalHour)")
                .font(.caption)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        SharedEventsView()
    }
}
