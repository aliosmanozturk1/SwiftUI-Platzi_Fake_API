//
//  ProductViewModel.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//


import Foundation

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Ürünleri çek
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let products = try await ProductService.shared.fetchProducts()
            self.products = products
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func createProduct(title: String, price: Int, description: String, categoryId: Int, images: [String]) async {
        isLoading = true
        errorMessage = nil
        do {
            let product = try await ProductService.shared.createProduct(title: title, price: price, description: description, categoryId: categoryId, images: images)
            products.insert(product, at: 0) // Yeni ürünü en başa ekle
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func updateProduct(id: Int, title: String, price: Int, description: String, categoryId: Int, images: [String]) async {
        isLoading = true
        errorMessage = nil
        do {
            let updated = try await ProductService.shared.updateProduct(
                id: id,
                title: title,
                price: price,
                description: description,
                categoryId: categoryId,
                images: images
            )
            // Dizide güncellenen ürünü bulup değiştir
            if let idx = products.firstIndex(where: { $0.id == id }) {
                products[idx] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func deleteProduct(id: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            try await ProductService.shared.deleteProduct(id: id)
            // Silinen ürünü diziden kaldır
            products.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
