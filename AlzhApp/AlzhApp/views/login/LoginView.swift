//
//  LoginView.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import SwiftUI

struct LoginView: View {
    @State private var dniText: String = ""
    @State private var passwordText: String = ""
    @State private var isTapped = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack (spacing: 20) {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text("AlzhApp")
                        .font(.custom(AppFonts.OpenSans.regular.rawValue, size: 40))
                        .foregroundStyle(.white)
                        .bold()
                        .shadow(color: .black, radius: 3, x: 0, y: 0)
                        .padding(.bottom, 20)
                    CustomTextFieldAuth(title: "DNI", placeholder: "123456789X", text: $dniText, isSecureField: false)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    CustomTextFieldAuth(title: "PASSWORD", placeholder: "Write here", text: $passwordText, isSecureField: true)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                    Text("¿Has olvidado tu contraseña?")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.darkBlue)
                        .opacity(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 30)
                    Spacer()
                    CustomButtonStyle(text: "Login", isTapped: $isTapped) {
                        
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
    }
}

#Preview {
    LoginView()
}
