// InitialView.swift
// AlzhApp
//
// Created by lorena.cruz on 2/6/24.
//
import SwiftUI

struct InitialView: View {
    @State private var isTapped = false
    @State private var navigateToCreatePatient = false
    @State private var navigateToProduct = false
    @State private var selectedProduct: ProductBO? = nil
    @StateObject private var viewModel = ProductViewModel()
    
    let singleColumn = [
        GridItem(.flexible(minimum: 150, maximum: .infinity), spacing: 1)
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.items == nil {
                            if let errorText = viewModel.errorText {
                                Image(systemName: AppIcons.connection.rawValue)
                                    .resizable()
                                    .frame(width: 30,height: 30)
                                    .foregroundStyle(.white)
                                Text("Error de conexión")
                                    .foregroundColor(.white)
                                Button(action: {
                                    viewModel.loadProducts()
                                }, label: {
                                    Text("Reintentar")
                                        .foregroundStyle(.white)
                                        .padding()
                                })
                                .background(
                                Capsule()
                                    .fill(AppColors.maroon)
                                )
                            } else {
                                ProgressView("Loading products...")
                            }
                        } else {
                            NavigationLink(destination: CreatePatientView(), isActive: $navigateToCreatePatient) {
                                EmptyView()
                            }
                            if let selectedProduct = selectedProduct {
                                NavigationLink(destination: UnityFamilyView(product: selectedProduct), isActive: $navigateToProduct) {
                                    EmptyView()
                                }
                            }
                            CustomButtonStyle(text: LocalizedString.agregarPaciente, isTapped: $isTapped) {
                                navigateToCreatePatient = true
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            LazyVGrid(columns: singleColumn, spacing: 20) {
                                ForEach(viewModel.items!, id: \.id) { product in
                                    ProductRow(product: product) {
                                        selectedProduct = product
                                        navigateToProduct = true
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                }
                            }
                        }
                    }
                    .navBarAddFamily(title: LocalizedString.unidadesFamiliares)
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                    .onTapGesture {
                        endEditing()
                    }
                }
                .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            }
            .onAppear {
                viewModel.loadProducts()
            }
        }
    }
}

struct ProductRow: View {
    let product: ProductBO
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.title)
                .font(.headline)
            Text(product.description)
                .font(.subheadline)
            Text("Price: \(product.price, specifier: "%.2f")")
                .font(.subheadline)
            Text("Rating: \(product.rating)")
                .font(.subheadline)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    NavigationView {
        InitialView()
    }
}
