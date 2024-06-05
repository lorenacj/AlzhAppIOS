//
//  CarerDTO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

// Define CarerDTO conforme a Codable
struct CarerDTO: Codable {
    var id: Int?
    var name: String?
    var lastname: String?
    var telephone: String?
    var role: String?
    var username: String?
    var password: String?
    var token: String?
    var enabled: Bool?
    var deleted: Bool?
    #warning("cambiar")
    var patientsCare: [Int]? // Lista de identificadores de pacientes
    var familyUnit: Int? // Identificador de la unidad familiar
    var medicines: [Int]? // Lista de identificadores de medicamentos
}
