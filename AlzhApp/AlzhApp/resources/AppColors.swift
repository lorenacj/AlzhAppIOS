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
    // Gris -> #D2CCCC -> rgba(210, 204, 204, 1)
    static let gray = Color(red: 210.0/255.0, green: 204.0/255.0, blue: 204.0/255.0)
    // Azul oscuro -> #134F6A -> rgba(19, 79, 106, 1)
    static let darkBlue = Color(red: 19.0/255.0, green: 79.0/255.0, blue: 106.0/255.0)
    // Azul claro -> #5A98AD -> rgba(90, 152, 173, 1)
    static let lightBlue = Color(red: 90.0/255.0, green: 152.0/255.0, blue: 173.0/255.0)
    // Amarillo -> #F7BD8A -> rgba(247, 189, 138, 1)
    static let yellow = Color(red: 247.0/255.0, green: 189.0/255.0, blue: 138.0/255.0)
    // Rosa -> #DE83A1 -> rgba(222, 131, 161, 1)
    static let pink = Color(red: 222.0/255.0, green: 131.0/255.0, blue: 161.0/255.0)
    // Granate -> #984A3B -> rgba(152, 74, 59, 1)
    static let maroon = Color(red: 152.0/255.0, green: 74.0/255.0, blue: 59.0/255.0)
    // Lila -> #955D80 -> rgba(149, 93, 128, 1)
    static let lilac = Color(red: 149.0/255.0, green: 93.0/255.0, blue: 128.0/255.0)
    
    static let gradientBackground = [lightBlue,yellow, pink]
}
