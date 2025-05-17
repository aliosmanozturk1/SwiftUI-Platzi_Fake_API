//
//  LoginView.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("E-posta", text: $viewModel.email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            
            SecureField("Şifre", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            
            if let error = viewModel.errorMessage {
                Text("Hata: \(error)")
                    .foregroundColor(.red)
            }
            
            Button(action: {
                Task { await viewModel.login() }
            }) {
                Text("Giriş Yap")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
