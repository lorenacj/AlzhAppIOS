//
//  ProductDTO.swift
//  EjerciciosUIKIT
//
//  Created by lorena.cruz on 17/5/24.
//

import Foundation

struct ProductDTO: Decodable {
    var title: String?
    var type: String?
    var description: String?
    var filename: String?
    var height: Int?
    var width: Int?
    var price: Double?
    var rating: Int?
}
