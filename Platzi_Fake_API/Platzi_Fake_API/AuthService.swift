//
//  AuthService.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//


import Foundation

class AuthService {
    static let shared = AuthService()
    private let baseURL = "https://api.escuelajs.co/api/v1/"
    private init() {}
    
    // Login işlemi
    func login(email: String, password: String) async throws -> String {
        let urlString = baseURL + "auth/login"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode(AuthResponse.self, from: data)
        // Tokenı Keychain veya UserDefaults ile saklayabilirsin (şimdilik UserDefaults)
        UserDefaults.standard.set(result.accessToken, forKey: "access_token")
        return result.accessToken
    }
}

// Token JSON modeli
struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    // JSON'daki anahtarlar snake_case olduğu için CodingKeys:
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
