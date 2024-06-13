//
//  SymptomBO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct SymptomBO: Codable {
    let id: Int?
    let type: String?
    let description: String?
    let date: String? // Se cambia a String para evitar problemas de formato
    let hour: String? // Se cambia a String para evitar problemas de formato
}
