//
//  Buttons.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: View {
    var text: String
    @Binding var isTapped: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.action()
            }
        }) {
            Text(text)
                .font(.custom(AppFonts.SourceSans.semibold.rawValue, size: 16))
                //isTapped ? .white :
                .foregroundColor(.white)
                .bold()
                .padding()
                .frame(width: 140, height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isTapped ? AppColors.pink : AppColors.lightBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.black.opacity(0.7), lineWidth: 2)
                        )
                )
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation {
                        self.isTapped = true
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        self.isTapped = false
                    }
                }
        )
    }
}
