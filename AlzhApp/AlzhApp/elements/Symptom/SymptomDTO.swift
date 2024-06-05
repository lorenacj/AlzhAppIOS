//
//  SymptomDTO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct SymptomDTO: Decodable {
    var id: Int?
    var type: String?
    var description: String?
    var date: String?
    var hour: String?
}
