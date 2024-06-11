//
//  CarerViewModel.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

final class CarerViewModel: ObservableObject {
    @Published var errorText: String?
    @Published var isLoginSuccessful = false
    @Published var isRegisterSuccessful = false
    @Published var isAddCarerSuccessful = false
    @Published var patients: [PatientsCareBO] = []
    @Published var token: String?
    @Published var isLoading = false 

    private lazy var carerRepository: CarerRepository = CarerWS()

    @MainActor
    func loginCarer(username: String, password: String) {
        Task {
            isLoading = true
            do {
                let token = try await carerRepository.loginCarer(username: username, password: password)
                self.token = token
                isLoginSuccessful = true
                errorText = nil
            } catch {
                handleError(error)
                isLoginSuccessful = false
            }
            isLoading = false
        }
    }

    @MainActor
    func registerCarer(carer: CarerBO) {
        Task {
            isLoading = true
            do {
                try await carerRepository.registerCarer(carer: carer)
                isRegisterSuccessful = true
                errorText = nil
            } catch {
                handleError(error)
                isRegisterSuccessful = false
            }
            isLoading = false
        }
    }

    @MainActor
    func addCarerToPatientByCode(code: String) {
        Task {
            isLoading = true
            guard let token = token else {
                errorText = "No token available"
                isLoading = false
                return
            }

            do {
                try await carerRepository.addCarerToPatientByCode(code: code, token: token)
                isAddCarerSuccessful = true
                errorText = nil
            } catch {
                handleError(error)
                isAddCarerSuccessful = false
            }
            isLoading = false
        }
    }

    @MainActor
    func getPatientsByCarer() {
        Task {
            isLoading = true
            guard let token = token else {
                errorText = "No token available"
                isLoading = false
                return
            }

            do {
                let patients = try await carerRepository.getPatientsByCarer(token: token)
                self.patients = patients
                errorText = nil
            } catch {
                handleError(error)
            }
            isLoading = false
        }
    }

    private func handleError(_ error: Error) {
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
    }
}
