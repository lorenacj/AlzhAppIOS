//
//  ProductViewModel.swift
//  EjerciciosSwiftUI
//
//  Created by lorena.cruz on 3/6/24.
//
import Foundation
import Combine

final class ProductViewModel: ObservableObject {
    @Published var items: [ProductBO]?
    @Published var errorText: String?
    
    private lazy var productRepository: ProductRepository = ProductWS()
    
    @MainActor
    func loadProducts() {
        Task {
            do {
                items = try await productRepository.loadListProduct()
                errorText = nil
            } catch {
                errorText = error.localizedDescription
            }
        }
    }
}
