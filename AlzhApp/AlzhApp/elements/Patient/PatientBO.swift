//
//  PatientBO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct PatientsCareBO: Codable {
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
}

