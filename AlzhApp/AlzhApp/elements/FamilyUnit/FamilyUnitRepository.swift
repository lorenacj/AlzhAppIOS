//
//  FamilyUnitRepository.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

// MARK: - FamilyUnitRepository Protocol
protocol FamilyUnitRepository {
    func addCarerToPatientByCode(familyUnit: FamilyUnitBO, authorizationToken: String) async throws
}

// MARK: - FamilyUnitWS
class FamilyUnitWS: FamilyUnitRepository {
    private let baseURL = "https://alzhappapilorenacruz.azurewebsites.net"

    func addCarerToPatientByCode(familyUnit: FamilyUnitBO, authorizationToken: String) async throws {
        guard let url = URL(string: "\(baseURL)/patientapi/addCarer/\(familyUnit.code ?? "")") else {
            throw RepositoryError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")

        let dto = FamilyUnitDTO(
            id: familyUnit.id,
            code: familyUnit.code
        )

        do {
            let jsonData = try JSONEncoder().encode(dto)
            request.httpBody = jsonData
        } catch {
            throw error
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepositoryError.invalidResponse
            }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                if let errorMessage = String(data: data, encoding: .utf8) {
                    throw RepositoryError.custom(errorMessage)
                } else {
                    throw RepositoryError.statusCode(httpResponse.statusCode)
                }
            }
        } catch {
            throw error
        }
    }
}
