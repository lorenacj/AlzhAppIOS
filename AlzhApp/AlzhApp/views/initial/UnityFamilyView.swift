import SwiftUI

struct UnityFamilyView: View {
    let product: ProductBO
    
    var body: some View {
        VStack {
            VStack {
                Text(product.title)
                    .font(.largeTitle)
                Text(product.description)
                    .padding()
                Text("Price: \(product.price, specifier: "%.2f")")
                Text("Rating: \(product.rating)")
            }
            .padding()
        }
//        .navigationBarHidden(true)
    }
}

#Preview {
    UnityFamilyView(product: ProductBO(title: "Sample Product", type: .vegan, description: "This is a sample product description", imageURL: URL(string: "https://example.com/image.png")!, height: 100, width: 100, price: 9.99, rating: 5))
}
