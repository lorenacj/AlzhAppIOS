//
//  MedicineDTO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

// MARK: - Medicine
struct Medicine: Codable {
    let id: Int?
    let name, description, usage: String?
    let howoften, howmanydays: Int?
    let deleted: Bool?
}
