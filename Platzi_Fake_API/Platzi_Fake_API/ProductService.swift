//
//  ProductService.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//

/**
 class ProductService: Tüm ürün API işlemlerini yönetecek katman.

 static let shared: Singleton, tek bir örnek (her yerden ulaşmak için).

 private let baseURL: API’nin ana URL’i.

 private init() {}: Dışarıdan yeni bir ProductService oluşturulamasın diye.

 func fetchProducts() async throws -> [Product]: Asenkron olarak ürünleri döndüren fonksiyon. Hata fırlatabilir (throws).

 let urlString = ...: Tam istek URL’sini oluştur.

 URL(string:): String’i URL’ye çevir.

 guard let url = ... else: URL geçersizse hata fırlat.

 let (data, response) = try await URLSession.shared.data(from: url): Asenkron olarak veri çekiyoruz.

 guard let httpResponse = ...: HTTP durumu 200 değilse hata fırlat.

 JSONDecoder().decode([Product].self, from: data): JSON’u Product array’ine çevir.
 */

import Foundation

class ProductService {
    static let shared = ProductService()
    private let baseURL = "https://api.escuelajs.co/api/v1/"
    
    private init() {} // Singleton
    
    // Ürünleri getir
    func fetchProducts() async throws -> [Product] {
        let urlString = baseURL + "products"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // HTTP durumu 200 mü diye kontrol
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // JSON Decode işlemi
        let products = try JSONDecoder().decode([Product].self, from: data)
        return products
    }
}

extension ProductService {
    func createProduct(title: String, price: Int, description: String, categoryId: Int, images: [String]) async throws -> Product {
        let urlString = baseURL + "products/"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JWT token'ı header olarak ekle!
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "title": title,
            "price": price,
            "description": description,
            "categoryId": categoryId,
            "images": images
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        let product = try JSONDecoder().decode(Product.self, from: data)
        return product
    }
}

extension ProductService {
    func updateProduct(id: Int, title: String, price: Int, description: String, categoryId: Int, images: [String]) async throws -> Product {
        let urlString = baseURL + "products/\(id)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JWT token'ı header'a ekle
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "title": title,
            "price": price,
            "description": description,
            "categoryId": categoryId,
            "images": images
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let product = try JSONDecoder().decode(Product.self, from: data)
        return product
    }
}

extension ProductService {
    func deleteProduct(id: Int) async throws {
        let urlString = baseURL + "products/\(id)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}

