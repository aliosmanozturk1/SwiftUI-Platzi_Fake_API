//
//  ProductEditView.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//


import SwiftUI

struct ProductEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProductViewModel
    let product: Product
    @State private var title: String
    @State private var price: String
    @State private var description: String
    @State private var categoryId: String
    @State private var imageUrl: String

    init(viewModel: ProductViewModel, product: Product) {
        self.viewModel = viewModel
        self.product = product
        _title = State(initialValue: product.title)
        _price = State(initialValue: "\(product.price)")
        _description = State(initialValue: product.description)
        _categoryId = State(initialValue: "\(product.category.id)")
        _imageUrl = State(initialValue: product.images.first ?? "")
    }

    var body: some View {
        Form {
            TextField("Başlık", text: $title)
            TextField("Fiyat", text: $price)
                .keyboardType(.numberPad)
            TextField("Açıklama", text: $description)
            TextField("Kategori ID", text: $categoryId)
                .keyboardType(.numberPad)
            TextField("Görsel URL", text: $imageUrl)
            
            Button("Kaydet") {
                Task {
                    await viewModel.updateProduct(
                        id: product.id,
                        title: title,
                        price: Int(price) ?? 0,
                        description: description,
                        categoryId: Int(categoryId) ?? 1,
                        images: [imageUrl]
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Ürünü Düzenle")
    }
}
