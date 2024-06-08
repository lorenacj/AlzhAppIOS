//
//  MedicineBO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct MedicineBO: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let usage: String?
    let howOften: Int?
    let howManyDays: Int?
    let deleted: Bool?
}
