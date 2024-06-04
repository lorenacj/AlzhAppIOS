//
//  TabNavigationBar.swift
//  AlzhApp
//
//  Created by lorena.cruz on 31/5/24.
//
import SwiftUI

struct InitialView: View {
    @State private var isTapped = false
    @State private var navigateToCreatePatient = false

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 20) {
#warning("Falta funcionalidad con la API")
                    // Contenido de la lista de unidades familiares
                    
                    CustomButtonStyle(text: LocalizedString.agregarPaciente, isTapped: $isTapped) {
                        navigateToCreatePatient = true
                    }
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: CreatePatientView(), isActive: $navigateToCreatePatient) {
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height)
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
        }
        .onTapGesture {
            endEditing()
        }
        .navBarAddFamily(title: LocalizedString.unidadesFamiliares)
    }
}

#Preview {
    NavigationView {
        InitialView()
    }
}
