//
//  CarerDTO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct CarerDTO: Decodable {
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
    var patientsCare: Any? // Cambia el tipo según sea necesario
    var familyUnit: Any? // Cambia el tipo según sea necesario
    var medicines: Any? // Cambia el tipo según sea necesario
}
