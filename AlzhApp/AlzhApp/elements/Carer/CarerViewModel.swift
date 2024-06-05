//
//  CarerViewModel.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation
import Combine

final class CarerViewModel: ObservableObject {
    @Published var errorText: String?
    @Published var isLoginSuccessful = false
    @Published var isRegisterSuccessful = false

    private lazy var carerRepository: CarerRepository = CarerWS()

    @MainActor
    func loginCarer(username: String, password: String) {
        Task {
            do {
                let token = try await carerRepository.loginCarer(username: username, password: password)
                isLoginSuccessful = true
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
                isLoginSuccessful = false
                print("Login error: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    func registerCarer(carer: CarerBO) {
        Task {
            do {
                try await carerRepository.registerCarer(carer: carer)
                isRegisterSuccessful = true
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
                isRegisterSuccessful = false
                print("Register error: \(error.localizedDescription)")
            }
        }
    }
}
