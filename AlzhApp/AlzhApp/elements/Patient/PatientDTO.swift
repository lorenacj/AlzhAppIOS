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
    let name, lastname, birthdate: String?
    let height, weight: Int?
    let disorder, passportid: String?
    let enabled, deleted: Bool?
    let familyUnit: FamilyUnitDTO?
    let medicines: [Medicine]?
    let events: [Event]?
    let symptoms: [Symptom]?
}
