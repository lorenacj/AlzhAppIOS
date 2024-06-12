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
    @Published var isAddEventSuccessful = false // Nuevo estado para agregar eventos
    @Published var isAddPatientSuccessful = false
    @Published var patients: [PatientsCareBO] = []
    @Published var token: String?
    @Published var isLoading = false
    @Published var shouldReloadPatients = false
    
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
                print("DEBUG: Login successful, token: \(token)")
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
                print("DEBUG: Carer registered successfully")
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
                print("DEBUG: No token available for adding carer to patient")
                return
            }
            
            do {
                try await carerRepository.addCarerToPatientByCode(code: code, token: token)
                isAddCarerSuccessful = true
                errorText = nil
                print("DEBUG: Carer added to patient successfully")
            } catch {
                handleError(error)
                isAddCarerSuccessful = false
            }
            isLoading = false
        }
    }
    
    @MainActor
    func addPatient(patient: AddPatientDTO) {
        Task {
            isLoading = true
            guard let token = token else {
                errorText = "No token available"
                isLoading = false
                print("DEBUG: No token available for adding patient")
                return
            }
            
            do {
                print("DEBUG: Adding patient: \(patient)")
                try await carerRepository.addPatient(patient: patient, token: token)
                isAddPatientSuccessful = true
                errorText = nil
                shouldReloadPatients = true // Indicar que se deben recargar los pacientes
                print("DEBUG: Patient added successfully")
            } catch {
                handleError(error)
                isAddPatientSuccessful = false
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
                print("DEBUG: No token available for getting patients")
                return
            }
            
            do {
                let patients = try await carerRepository.getPatientsByCarer(token: token)
                self.patients = patients
                errorText = nil
                shouldReloadPatients = false // Resetear el indicador después de recargar
                print("DEBUG: Patients retrieved successfully")
            } catch {
                handleError(error)
            }
            isLoading = false
        }
    }
    
    @MainActor
    func updatePatient(patient: UpdatePatientDTO) async throws {
        print("DEBUG: Starting updatePatient in ViewModel")
        isLoading = true
        guard let token = token else {
            errorText = "No token available"
            isLoading = false
            print("DEBUG: No token available")
            throw RepositoryError.custom("No token available")
        }
        
        do {
            try await carerRepository.updatePatient(patient: patient, token: token)
            shouldReloadPatients = true
            isLoading = false
            print("DEBUG: Successfully updated patient in ViewModel")
        } catch {
            isLoading = false
            print("DEBUG: Error updating patient in ViewModel: \(error)")
            throw error
        }
    }
    
    @MainActor
    func addEvent(event: AddEventDTO, patientID: Int) {
        Task {
            isLoading = true
            guard let token = token else {
                errorText = "No token available"
                isLoading = false
                print("DEBUG: No token available for adding event")
                return
            }

            do {
                print("DEBUG: Adding event: \(event) for patientID: \(patientID)")
                try await carerRepository.addEvent(event: event, patientID: patientID, token: token)
                isAddEventSuccessful = true
                errorText = nil
                print("DEBUG: Event added successfully")
            } catch {
                handleError(error)
                isAddEventSuccessful = false
            }
            isLoading = false
        }
    }

    
    @MainActor
    func addEventWithStaticData(patientID: Int, token: String) async throws {
        try await carerRepository.addEventWithStaticData(patientID: patientID, token: token)
    }
    
    private func handleError(_ error: Error) {
        if let repoError = error as? RepositoryError {
            switch repoError {
            case .statusCode(let code):
                errorText = "Error: Código de estado \(code)"
                print("DEBUG: Repository error with status code: \(code)")
            case .custom(let message):
                errorText = message
                print("DEBUG: Repository error with message: \(message)")
            default:
                errorText = "Error desconocido: \(error.localizedDescription)"
                print("DEBUG: Unknown repository error: \(error.localizedDescription)")
            }
        } else {
            errorText = error.localizedDescription
            print("DEBUG: General error: \(error.localizedDescription)")
        }
    }
}
