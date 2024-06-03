//
//  TextFields.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import Foundation
import SwiftUI

struct CustomTextFieldAuth<T: LosslessStringConvertible>: View {
    var title: String
    var placeholder: String
    @Binding var text: T?
    var isSecureField: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
                .padding(.leading, 8)
            ZStack(alignment: .leading) {
                if isSecureField {
                    SecureField("", text: Binding<String>(
                        get: { text?.description ?? "" },
                        set: {
                            if let value = T($0) {
                                text = value
                            } else {
                                text = nil
                            }
                        }
                    ))
                    .placeholder(when: text == nil || text!.description.isEmpty) {
                        Text(placeholder).foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                    .frame(width: 311, height: 56)
                    .padding(.leading, 17)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(0.6))
                    )
                } else {
                    TextField("", text: Binding<String>(
                        get: { text?.description ?? "" },
                        set: {
                            if let value = T($0) {
                                text = value
                            } else {
                                text = nil
                            }
                        }
                    ))
                    .placeholder(when: text == nil || text!.description.isEmpty) {
                        Text(placeholder).foregroundColor(.gray)
                    }
                    .foregroundColor(.black)
                    .keyboardType(T.self == String.self ? .default : .numberPad)
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

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
// datepicker ---------

struct CustomDateField: View {
    var title: String
    var placeholder: String
    @Binding var date: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .frame(alignment: .leading)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
                .padding(.leading, 8)
            
            ZStack(alignment: .leading) {
                if date == nil {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.leading, 17)
                }
                
                DatePicker(
                    "",
                    selection: Binding<Date>(
                        get: { date ?? Date() },
                        set: { newValue in date = newValue }
                    ),
                    displayedComponents: .date
                )
                .labelsHidden()
                .accentColor(.black)
                .padding(.leading, 17)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 320)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.7), lineWidth: 1)
                        .frame(width: 320)
                )
            }
        }
        .padding(.horizontal, 40)
    }
}

// picker ------
struct CustomPickerField: View {
    var title: String
    var placeholder: String
    @Binding var selectedOption: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Picker(selection: $selectedOption, label: Text(placeholder)) {
                // Replace the following with your actual options
                #warning("Cambiar opciones y localized")
                Text("Elige").tag("Option 1")
                Text("Alzheimer").tag("Option 2")
                Text("Demencia").tag("Option 3")
                Text("Alzheimer y demencia").tag("Option 3")
                Text("Otros").tag("Option 3")
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal, 40)
    }
}
