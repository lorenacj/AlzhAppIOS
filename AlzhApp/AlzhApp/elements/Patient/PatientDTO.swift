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
    let carer: [CarerDTO]?
    let familyUnit: FamilyUnitDTO?
    let medicines: [Medicine]?
    let events: [Event]?
    let symptoms: [Symptom]?

    init(name: String, lastname: String, birthdate: Date, height: Int, weight: Int, disorder: String, passportid: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.birthdate = formatter.string(from: birthdate)
        self.name = name
        self.lastname = lastname
        self.height = height
        self.weight = weight
        self.disorder = disorder
        self.passportid = passportid
        self.id = nil
        self.enabled = true
        self.deleted = false
        self.carer = nil
        self.familyUnit = nil
        self.medicines = nil
        self.events = nil
        self.symptoms = nil
    }
}

struct UpdatePatientDTO: Codable {
    let id: Int
    let name: String
    let lastname: String
    let birthdate: String
    let height: Int
    let weight: Double
    let disorder: String
    let passportId: String
}

// MARK: - AddPatientDTO
struct AddPatientDTO: Codable {
    let name: String
    let lastname: String
    let height: Int
    let weight: Float
    let disorder: String
    let birthdate: String
    let passportId: String

    init(name: String, lastname: String, birthdate: Date, height: Int, weight: Float, disorder: String, passportId: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.birthdate = formatter.string(from: birthdate)
        self.name = name
        self.lastname = lastname
        self.height = height
        self.weight = weight
        self.disorder = disorder
        self.passportId = passportId
    }
}
