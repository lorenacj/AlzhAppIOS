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
            ScrollView{
                VStack {
                    Text("Listado")
                }
                .navigationBar(title: "Eventos compartidos")
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
        }
    }
}

#Preview {
    NavigationView {
        SharedEventsView()
    }
}
