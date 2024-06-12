//
//  EventDTO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 6/6/24.
//

import Foundation

// MARK: - Event
struct Event: Codable {
    let id: Int?
    let name, type, description, status: String?
    let deleted: Bool?
    let initialDate, finalDate, initialHour, finalHour: Date?
}


struct AddEventDTO: Codable {
    let name: String
    let type: String
    let description: String
    let status: String
    let initialDate: String
    let finalDate: String
    let initialHour: String
    let finalHour: String
}
