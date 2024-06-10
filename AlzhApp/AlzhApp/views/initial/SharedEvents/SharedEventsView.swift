//
//  SharedEventsView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 7/6/24.
//

import SwiftUI

struct SharedEventsView: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Text("Listado de Eventos")
                        .font(.largeTitle)
                        .padding(.top, 20)
                    
//                    if let errorText = viewModel.errorText {
//                        Image(systemName: "exclamationmark.triangle")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                            .foregroundColor(.red)
//                        Text(errorText)
//                            .foregroundColor(.red)
//                        Button(action: {
//                            Task {
//                                await viewModel.fetchEvents()
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
//                    } else if viewModel.events.isEmpty {
//                        ProgressView("Cargando eventos...")
//                    } else {
//                        ForEach(viewModel.events, id: \.id) { event in
//                            EventRowView(event: event)
//                        }
//                    }
                    
                }
                .navigationBar(title: "Eventos compartidos")

                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .onAppear {
                Task {
                    //                               await viewModel.fetchEvents()
                }
            }
        }
    }
}
