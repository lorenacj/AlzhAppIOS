//
//  SymptomDTO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

// MARK: - Symptom
struct Symptom: Codable {
    let id: Int?
    let type, description: String?
    let  date, hour: Date?
}
