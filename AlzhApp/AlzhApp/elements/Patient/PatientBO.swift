//
//  PatientBO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct PatientsCareBO: Codable,Identifiable, Hashable {
    let id: Int?
    let name: String?
    let lastname: String?
    let birthdate: String?
    let height: Int?
    let weight: Double?
    let disorder: String?
    let passportid: String?
    let enabled: Bool?
    let deleted: Bool?
    let familyUnit: FamilyUnitBO?
    let medicines: [MedicineBO]?
    let events: [EventBO]?
    let symptoms: [SymptomBO]?
    
    
    // Implementar el método hash(into:) para conformar a Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Implementar el operador de igualdad para conformar a Hashable
    static func == (lhs: PatientsCareBO, rhs: PatientsCareBO) -> Bool {
        return lhs.id == rhs.id
    }
}

