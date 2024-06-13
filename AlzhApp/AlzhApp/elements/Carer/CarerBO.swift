//
//  CarerBO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct CarerBO: Identifiable, Hashable, Codable {
    static func == (lhs: CarerBO, rhs: CarerBO) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int?
    let name: String?
    let lastname: String?
    let telephone: String?
    let role: String?
    let username: String?
    let password: String?
    let token: String?
    let enabled: Bool?
    let deleted: Bool?
    let familyUnit: [FamilyUnitBO]?
    let medicines: [MedicineBO]?

    // Implementar el método hash(into:) para conformar a Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Inicializador a partir de CarerDTO
    init?(dto: CarerDTO) {
        guard let id = dto.id,
              let name = dto.name,
              let lastname = dto.lastname,
              let telephone = dto.telephone,
              let username = dto.username,
              let password = dto.password else {
            return nil
        }
        self.id = id
        self.name = name
        self.lastname = lastname
        self.telephone = telephone
        self.role = dto.role
        self.username = username
        self.password = password
        self.token = dto.token
        self.enabled = dto.enabled
        self.deleted = dto.deleted

        // Convert FamilyUnitDTO to FamilyUnitBO
        if let familyUnitDTO = dto.familyUnit {
            self.familyUnit = familyUnitDTO.map { FamilyUnitBO(id: $0.id, code: $0.code) }
        } else {
            self.familyUnit = nil
        }

        // Convert Medicine to MedicineBO
        if let medicinesDTO = dto.medicines {
            self.medicines = medicinesDTO.map { MedicineBO(id: $0.id, name: $0.name, description: $0.description, usage: $0.usage, howOften: $0.howoften, howManyDays: $0.howmanydays, deleted: $0.deleted) }
        } else {
            self.medicines = nil
        }
    }

    // Inicializador a partir de parámetros individuales
    init(id: Int? = nil, name: String? = nil, lastname: String? = nil, telephone: String? = nil, role: String? = nil, username: String? = nil, password: String? = nil, token: String? = nil, enabled: Bool? = nil, deleted: Bool? = nil, familyUnit: [FamilyUnitBO]? = nil, medicines: [MedicineBO]? = nil) {
        self.id = id
        self.name = name
        self.lastname = lastname
        self.telephone = telephone
        self.role = role
        self.username = username
        self.password = password
        self.token = token
        self.enabled = enabled
        self.deleted = deleted
        self.familyUnit = familyUnit
        self.medicines = medicines
    }
}
