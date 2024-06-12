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
    func addPatient(patient: AddPatientDTO, token: String) async throws
    func updatePatient(patient: UpdatePatientDTO, token: String) async throws
    func addEvent(event: AddEventDTO, patientID: Int, token: String) async throws
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
        
        print("DEBUG: Login Request URL: \(url.absoluteString)")
        print("DEBUG: Login Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("DEBUG: Login Request Body: \(String(data: formData, encoding: .utf8) ?? "")")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepositoryError.invalidResponse
            }
            
            print("DEBUG: Login Response Status Code: \(httpResponse.statusCode)")
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                if let errorMessage = String(data: data, encoding: .utf8) {
                    print("DEBUG: Login Error Message: \(errorMessage)")
                    throw RepositoryError.custom(errorMessage)
                } else {
                    throw RepositoryError.statusCode(httpResponse.statusCode)
                }
            }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = jsonResponse["token"] as? String {
                print("DEBUG: Login Token: \(token)")
                return token
            } else {
                throw RepositoryError.custom("Failed to decode login response")
            }
        } catch {
            print("DEBUG: Login Fetch Error: \(error.localizedDescription)")
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
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
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
    
    func getPatientsByCarer(token: String) async throws -> [PatientsCareBO] {
        guard let url = URL(string: "\(baseURL)/patientapi/getpatients/carer") else {
            throw RepositoryError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("DEBUG: Request URL: \(url.absoluteString)")
        print("DEBUG: Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RepositoryError.invalidResponse
            }
            
            print("DEBUG: Response Status Code: \(httpResponse.statusCode)")
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                if let errorMessage = String(data: data, encoding: .utf8) {
                    print("DEBUG: Error Message: \(errorMessage)")
                    throw RepositoryError.custom(errorMessage)
                } else {
                    throw RepositoryError.statusCode(httpResponse.statusCode)
                }
            }
            
            do {
                let patients = try JSONDecoder().decode([PatientsCareBO].self, from: data)
                print("DEBUG: Decoded Patients: \(patients)")
                return patients
            } catch {
                print("DEBUG: Decoding Error: \(error.localizedDescription)")
                throw RepositoryError.custom("Failed to decode patients data: \(error.localizedDescription)")
            }
        } catch {
            print("DEBUG: Fetch Error: \(error.localizedDescription)")
            throw RepositoryError.custom("Failed to fetch patients: \(error.localizedDescription)")
        }
    }
    
    func addPatient(patient: AddPatientDTO, token: String) async throws {
        guard let url = URL(string: "\(baseURL)/patientapi/add") else {
            print("DEBUG: Invalid URL for adding patient")
            throw RepositoryError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(patient)
            request.httpBody = jsonData
            print("DEBUG: Adding patient with data: \(patient)")
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("DEBUG: JSON Body: \(jsonString)")
            }
        } catch {
            print("DEBUG: Error encoding patient data: \(error.localizedDescription)")
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("DEBUG: Invalid response for adding patient")
                throw RepositoryError.invalidResponse
            }
            
            print("DEBUG: Response Status Code: \(httpResponse.statusCode)")
            if let responseData = String(data: data, encoding: .utf8) {
                print("DEBUG: Response Data: \(responseData)")
            }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("DEBUG: Adding patient failed with status code: \(httpResponse.statusCode), message: \(errorMessage)")
                throw RepositoryError.custom(errorMessage)
            }
            print("DEBUG: Patient added successfully")
        } catch {
            print("DEBUG: Adding patient request failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updatePatient(patient: UpdatePatientDTO, token: String) async throws {
        print("DEBUG: Starting updatePatient in CarerWS")
        guard let url = URL(string: "\(baseURL)/patientapi/update") else {
            print("DEBUG: Invalid URL")
            throw RepositoryError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(patient)
            request.httpBody = jsonData
            print("DEBUG: JSON Body for updatePatient: \(String(data: jsonData, encoding: .utf8) ?? "")")
        } catch {
            print("DEBUG: Error encoding patient data: \(error)")
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("DEBUG: Invalid response")
                throw RepositoryError.invalidResponse
            }
            
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("DEBUG: Error response status code: \(httpResponse.statusCode), message: \(errorMessage)")
                throw RepositoryError.custom(errorMessage)
            }
            print("DEBUG: Successfully updated patient in CarerWS")
        } catch {
            print("DEBUG: Error in updatePatient request: \(error)")
            throw error
        }
    }
    
    func addEvent(event: AddEventDTO, patientID: Int, token: String) async throws {
        print("entra a addeventrepositorio")
        guard let url = URL(string: "https://alzhappapilorenacruz.azurewebsites.net/eventapi/add/\(patientID)") else {
            print("DEBUG: Invalid URL for adding event")
            throw RepositoryError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(event)
            request.httpBody = jsonData
            print("DEBUG: JSON Body for addEvent: \(String(data: jsonData, encoding: .utf8) ?? "")")
        } catch {
            print("DEBUG: Error encoding event data: \(error.localizedDescription)")
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("DEBUG: Invalid response for adding event")
                throw RepositoryError.invalidResponse
            }
            
            print("DEBUG: Response Status Code for addEvent: \(httpResponse.statusCode)")
            if let responseData = String(data: data, encoding: .utf8) {
                print("DEBUG: Response Data for addEvent: \(responseData)")
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("DEBUG: Adding event failed with status code: \(httpResponse.statusCode), message: \(errorMessage)")
                throw RepositoryError.custom(errorMessage)
            }
            print("DEBUG: Event added successfully")
        } catch {
            print("DEBUG: Adding event request failed: \(error.localizedDescription)")
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
