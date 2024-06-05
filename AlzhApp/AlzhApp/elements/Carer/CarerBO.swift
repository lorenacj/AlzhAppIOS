//
//  CarerBO.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

struct CarerBO: Identifiable, Hashable {
    var id: Int?
    var name: String
    var lastname: String
    var telephone: String
    var username: String
    var password: String

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
        self.username = username
        self.password = password
    }

    // Inicializador a partir de parámetros individuales
    init(name: String, lastname: String, telephone: String, username: String, password: String) {
        self.name = name
        self.lastname = lastname
        self.telephone = telephone
        self.username = username
        self.password = password
    }
}

