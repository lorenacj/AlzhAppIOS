//
//  URLImage.swift
//  EjerciciosSwiftUI
//
//  Created by lorena.cruz on 3/6/24.
//

import Foundation
import SwiftUI

struct URLImage: View {
    let url: URL
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .onAppear(perform: loadImage)
            }
        }
    }
    
    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = image
                }
            }
        }.resume()
    }
}
