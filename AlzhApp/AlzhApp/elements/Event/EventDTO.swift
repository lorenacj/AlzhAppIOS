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
    
    private enum CodingKeys: String, CodingKey {
        case id, name, type, description, status, deleted, initialDate, finalDate, initialHour, finalHour
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        deleted = try container.decodeIfPresent(Bool.self, forKey: .deleted)
        
        if let initialDateString = try container.decodeIfPresent(String.self, forKey: .initialDate) {
            initialDate = Event.dateFormatter.date(from: initialDateString)
        } else {
            initialDate = nil
        }
        
        if let finalDateString = try container.decodeIfPresent(String.self, forKey: .finalDate) {
            finalDate = Event.dateFormatter.date(from: finalDateString)
        } else {
            finalDate = nil
        }
        
        if let initialHourString = try container.decodeIfPresent(String.self, forKey: .initialHour) {
            initialHour = Event.timeFormatter.date(from: initialHourString)
        } else {
            initialHour = nil
        }
        
        if let finalHourString = try container.decodeIfPresent(String.self, forKey: .finalHour) {
            finalHour = Event.timeFormatter.date(from: finalHourString)
        } else {
            finalHour = nil
        }
    }
}

extension Event {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
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
