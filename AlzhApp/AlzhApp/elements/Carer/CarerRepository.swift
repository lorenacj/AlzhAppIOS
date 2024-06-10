//
//  CarerRepository.swift
//  AlzhApp
//
//  Created by lorena.cruz on 5/6/24.
//

import Foundation

enum RepositoryError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case noData
    case custom(String)
}

protocol CarerRepository {
    func registerCarer(carer: CarerBO) async throws
    func loginCarer(username: String, password: String) async throws -> String
    func addCarerToPatientByCode(code: String, token: String) async throws
    func getPatientsByCarer(token: String) async throws -> [PatientsCareBO]
    func addPatient(patient: PatientsCareBO, token: String) async throws
    func getEventsByCarer(token: String) async throws -> [Event]
    func createEventForPatient(patientId: Int, event: Event, token: String) async throws -> Event
}

class CarerWS: CarerRepository {
    private let baseURL = "https://alzhappapilorenacruz.azurewebsites.net"

    func registerCarer(carer: CarerBO) async throws {
        guard let url = URL(string: "\(baseURL)/api/register") else {
            throw RepositoryError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let dto = CarerDTO(
            name: carer.name,
            lastname: carer.lastname,
            telephone: carer.telephone,
            username: carer.username,
            password: carer.password
        )

        do {
            let jsonData = try JSONEncoder().encode(dto)
            request.httpBody = jsonData
        } catch {
            throw error
        }

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepositoryError.invalidResponse
            }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                throw RepositoryError.statusCode(httpResponse.statusCode)
            }
        } catch {
            throw error
        }
    }

    func loginCarer(username: String, password: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)/api/login") else {
            throw RepositoryError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let formData = createFormData(parameters: ["username": username, "password": password], boundary: boundary)
        request.httpBody = formData

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

            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = jsonResponse["token"] as? String {
                return token
            } else {
                throw RepositoryError.custom("Failed to decode login response")
            }
        } catch {
            throw RepositoryError.custom("Login request failed: \(error.localizedDescription)")
        }
    }

    func addCarerToPatientByCode(code: String, token: String) async throws {
        guard let url = URL(string: "\(baseURL)/patientapi/addCarer/\(code)") else {
            throw RepositoryError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepositoryError.invalidResponse
            }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                throw RepositoryError.statusCode(httpResponse.statusCode)
            }
        } catch {
            throw error
        }
    }

    func getPatientsByCarer(token: String) async throws -> [PatientsCareBO] {
        guard let url = URL(string: "\(baseURL)/patientapi/getpatients/carer") else {
            throw RepositoryError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

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

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Por si acaso hay diferencias de estilo de clave
                let patients = try decoder.decode([PatientsCareBO].self, from: data)
                return patients
            } catch {
                print("DEBUG: Failed to decode patients data: \(error.localizedDescription)")
                print("DEBUG: JSON Data: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                throw RepositoryError.custom("Failed to decode patients data: \(error.localizedDescription)")
            }
        } catch {
            print("DEBUG: Failed to fetch patients: \(error.localizedDescription)")
            throw RepositoryError.custom("Failed to fetch patients: \(error.localizedDescription)")
        }
    }

    func addPatient(patient: PatientsCareBO, token: String) async throws {
        guard let url = URL(string: "\(baseURL)/patientapi/add") else {
            throw RepositoryError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let dto = PatientsCare(
            id: nil,
            name: patient.name,
            lastname: patient.lastname,
            birthdate: patient.birthdate,
            height: patient.height,
            weight: patient.weight,  // Asegurarse de que weight sea Double
            disorder: patient.disorder,
            passportid: patient.passportid,
            enabled: nil,
            deleted: nil,
            familyUnit: nil,
            medicines: nil,
            events: nil,
            symptoms: nil
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

    func getEventsByCarer(token: String) async throws -> [Event] {
        guard let url = URL(string: "\(baseURL)/eventapi/byCarer") else {
            throw RepositoryError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

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

            let events = try JSONDecoder().decode([Event].self, from: data)
            return events
        } catch {
            throw error
        }
    }

    func createEventForPatient(patientId: Int, event: Event, token: String) async throws -> Event {
        guard let url = URL(string: "\(baseURL)/eventapi/add/\(patientId)") else {
            throw RepositoryError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(event)
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

            let createdEvent = try JSONDecoder().decode(Event.self, from: data)
            return createdEvent
        } catch {
            throw error
        }
    }

    private func createFormData(parameters: [String: String], boundary: String) -> Data {
        var body = Data()
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
