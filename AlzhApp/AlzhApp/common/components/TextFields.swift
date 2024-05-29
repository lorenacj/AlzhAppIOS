//
//  TextFields.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import Foundation
import SwiftUI

struct CustomTextFieldAuth: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
                .padding(.leading, 8)
            ZStack(alignment: .leading) {
                if isSecureField {
                    SecureField(placeholder, text: $text)
                        .foregroundColor(.black)
                        .frame(width: 311, height: 56)
                        .padding(.leading, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.white.opacity(0.6))
                        )
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.black)
                        .frame(width: 311, height: 56)
                        .padding(.leading, 17)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.white.opacity(0.6))
                        )
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.7), lineWidth: 1)
            )
        }
    }
}
