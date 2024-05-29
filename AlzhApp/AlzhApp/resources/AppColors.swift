//
//  AppColors.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import Foundation
import SwiftUI

// MARK: - AppColors
struct AppColors {
    static let authGradientColor = [
        Color(red: 0.0/255.0, green: 23.0/255.0, blue: 41.0/255.0), // #001729
        Color(red: 24.0/255.0, green: 98.0/255.0, blue: 155.0/255.0)  // #18629B
    ]
    
    static let registerGradientColor = [
        Color(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0), // #001729
        Color(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0)  // #18629B
    ]
    // Azul oscuro botones
    static let BtnColor = Color(red: 6.0/255.0, green: 61.0/255.0, blue: 103.0/255.0)
    // Blanco fondo transparente
    static let BackgroundFieldLogin = Color(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0).opacity(0.4)

    static let yellowStar = Color(red: 255/255, green: 167/255, blue: 0/255)
}
