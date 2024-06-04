//
//  ProductBO.swift
//  EjerciciosUIKIT
//
//  Created by lorena.cruz on 17/5/24.
//

import Foundation

struct ProductBO {
    var title: String
    var type: TypeP
    var description: String
    var imageURL: URL
    var height: Int
    var width: Int
    var price: Double
    var rating: Int
}

extension ProductBO {
    enum TypeP: String {
        case vegan
        case dairy
        case fruit
        case vegetable
        case bakery
        case meat
    }
}

extension ProductBO: Identifiable {
    var id: String { "\(title) - \(description)" }
}

extension ProductBO: Hashable {
    
}

extension ProductBO {
    init?(dto: ProductDTO) {
        guard let title = dto.title,
              let type = TypeP(rawValue: dto.type ?? ""),
              let description = dto.description,
              let filename = dto.filename,
              let imageURL = URL(string: "https://raw.githubusercontent.com/SDOSLabs/JSON-Sample/master/Products/images/\(filename)"),
              let height = dto.height,
              let width = dto.width,
              let price = dto.price,
              let rating = dto.rating else {
            return nil
        }
        self.title = title
        self.type = type
        self.description = description
        self.imageURL = imageURL
        self.height = height
        self.width = width
        self.price = price
        self.rating = rating
    }
}
