//
//  CommonFunctions.swift
//  AlzhApp
//
//  Created by lorena.cruz on 29/5/24.
//

import Foundation
import SwiftUI

//Función que se utiliza para que al pulsar fuera del textfield con el teclado abierto, el teclado se oculte
func endEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

 func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy" // Ajustar al formato de fecha correcto
    return formatter
}
