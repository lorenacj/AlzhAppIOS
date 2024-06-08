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
    let patientsCare: [PatientsCare]?
    let familyUnit: [FamilyUnitDTO]?
    let medicines: [Medicine]?
    
    init(
           id: Int? = nil,
           name: String? = nil,
           lastname: String? = nil,
           telephone: String? = nil,
           role: String? = nil,
           username: String? = nil,
           password: String? = nil,
           token: String? = nil,
           enabled: Bool? = nil,
           deleted: Bool? = nil,
           patientsCare: [PatientsCare]? = [],
           familyUnit: [FamilyUnitDTO]? = [],
           medicines: [Medicine]? = []
       ) {
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
           self.patientsCare = patientsCare
           self.familyUnit = familyUnit
           self.medicines = medicines
       }
   }

struct AddCarerRequestDTO: Codable {
    let patientId: Int
    let carerId: Int
    let code: String
}
// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
