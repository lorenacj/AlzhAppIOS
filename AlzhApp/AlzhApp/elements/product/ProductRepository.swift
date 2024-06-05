//
//  ProductRepository.swift
//  EjerciciosUIKIT
//
//  Created by lorena.cruz on 17/5/24.
//

import Foundation

protocol ProductRepository {
    func loadListProduct(completion: @escaping (Result<[ProductBO], Error>) -> Void)
    func loadListProduct() async throws -> [ProductBO]
}


class ProductWS: ProductRepository {
    var contador = 0
    @available(*, renamed: "loadListProduct()")
    func loadListProduct(completion: @escaping (Result<[ProductBO], Error>) -> Void) {
        guard let url = URL(string: contador > 0 ? "https://raw.githubusercontent.com/SDOSLabs/JSON-Sample/master/Products/products.json" : "https://raw.githubusercontent.com/SDOSLabs/JSON-Sample/master/Products/products.js")
        else {
            completion(.failure(RepositoryError.invalidURL))
            return
        }
        contador += 1
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse {
                if 200 ..< 300 ~= response.statusCode {
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode([ProductDTO].self, from: data)
                            let resultBO = result.compactMap { ProductBO(dto: $0) }
                            completion(.success(resultBO))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(RepositoryError.noData))
                    }
                } else {
                    completion(.failure(RepositoryError.statusCode(response.statusCode)))
                }
            } else {
                completion(.failure(RepositoryError.invalidResponse))
            }
        }.resume()
    }
    
    func loadListProduct() async throws -> [ProductBO] {
        return try await withCheckedThrowingContinuation { continuation in
            loadListProduct() { result in
                continuation.resume(with: result)
            }
        }
    }
}
