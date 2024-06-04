import SwiftUI

struct InitialView: View {
    @State private var isTapped = false
    @State private var navigateToCreatePatient = false
    @StateObject private var viewModel = ProductViewModel()
    
    let singleColumn = [
        GridItem(.flexible(minimum: 150, maximum: .infinity), spacing: 1)
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        NavigationLink(destination: CreatePatientView(), isActive: $navigateToCreatePatient) {
                            EmptyView()
                        }
                        CustomButtonStyle(text: LocalizedString.agregarPaciente, isTapped: $isTapped) {
                            navigateToCreatePatient = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                        if viewModel.items == nil {
                            if let errorText = viewModel.errorText {
                                Text("Error de conexión")
                                    .foregroundColor(.red)
                                Button(action: {
                                    viewModel.loadProducts()
                                }, label: {
                                    Text("Reintentar")
                                })
                            } else {
                                ProgressView("Loading products...")
                            }
                        } else {
                            LazyVGrid(columns: singleColumn, spacing: 20) {
                                ForEach(viewModel.items!, id: \.id) { product in
                                    ProductRow(product: product)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 5)
                                }
                            }
                        }
                    }
                }
                .onTapGesture {
                    endEditing()
                }
            }
            .background(LinearGradient(colors: AppColors.gradientBackground, startPoint: .top, endPoint: .bottom))
            .opacity(0.8)
            .onAppear {
                viewModel.loadProducts()
            }
        }
    }
}

struct ProductRow: View {
    let product: ProductBO
    
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
    }
}

#Preview {
    NavigationView {
        InitialView()
    }
}
