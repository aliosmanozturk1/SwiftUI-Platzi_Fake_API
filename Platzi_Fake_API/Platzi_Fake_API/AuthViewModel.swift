//
//  AuthViewModel.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//


import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    func login() async {
        errorMessage = nil
        do {
            let token = try await AuthService.shared.login(email: email, password: password)
            isLoggedIn = true
            print("JWT Token: \(token)") // Sadece test için, prod’da gösterme!
        } catch {
            errorMessage = error.localizedDescription
            isLoggedIn = false
        }
    }
}
