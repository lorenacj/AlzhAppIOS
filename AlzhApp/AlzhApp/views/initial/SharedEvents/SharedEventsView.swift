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
                    //Eventos
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
        }
    }
}

#Preview {
    SharedEventsView()
}
