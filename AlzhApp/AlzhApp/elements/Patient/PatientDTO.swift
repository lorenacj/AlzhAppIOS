//
//  PatientDTO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

// MARK: - PatientsCare
struct PatientsCare: Codable {
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
    let familyUnit: FamilyUnitDTO?
    let medicines: [Medicine]?
    let events: [Event]?
    let symptoms: [Symptom]?
}
