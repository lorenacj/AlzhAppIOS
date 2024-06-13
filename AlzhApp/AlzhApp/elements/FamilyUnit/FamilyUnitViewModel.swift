//
//  FamilyUnitViewModel.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

final class FamilyUnitViewModel: ObservableObject {
    @Published var errorText: String?
    @Published var isAddSuccessful = false

    private lazy var familyUnitRepository: FamilyUnitRepository = FamilyUnitWS()

    @MainActor
    func addFamilyUnitByCode(code: String, authorizationToken: String) {
        Task {
            do {
                let familyUnit = FamilyUnitBO(id: nil, code: code)
                try await familyUnitRepository.addCarerToPatientByCode(familyUnit: familyUnit, authorizationToken: authorizationToken)
                isAddSuccessful = true
                errorText = nil
            } catch {
                if let repoError = error as? RepositoryError {
                    switch repoError {
                    case .statusCode(let code):
                        errorText = "Error: Código de estado \(code)"
                    case .custom(let message):
                        errorText = message
                    default:
                        errorText = "Error desconocido: \(error.localizedDescription)"
                    }
                } else {
                    errorText = error.localizedDescription
                }
                isAddSuccessful = false
                print("Add FamilyUnit error: \(error.localizedDescription)")
            }
        }
    }
}
