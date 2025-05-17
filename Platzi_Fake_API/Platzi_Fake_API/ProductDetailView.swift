//
//  ProductDetailView.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(height: 200)
            } placeholder: {
                ProgressView()
            }
            Text(product.title).font(.title)
            Text("₺\(product.price)").font(.headline)
            Text(product.description)
            Text("Kategori: \(product.category.name)")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("Detay")
    }
}
