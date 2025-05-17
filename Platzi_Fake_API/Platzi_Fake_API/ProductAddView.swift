//
//  ProductAddView.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//


import SwiftUI

struct ProductAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProductViewModel
    @State private var title: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var categoryId: String = ""
    @State private var imageUrl: String = ""
    
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
                    await viewModel.createProduct(
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
        .navigationTitle("Ürün Ekle")
    }
}
