//
//  EventBO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 6/6/24.
//

import Foundation

struct EventBO: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let description: String?
    let status: String?
    let deleted: Bool?
    let initialDate: String?
    let finalDate: String?
    let initialHour: String?
    let finalHour: String?
}
