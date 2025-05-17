//
//  ProductView.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//


import SwiftUI

struct ProductView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = ProductViewModel()
    @State private var showAddProduct = false

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Yükleniyor...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text("Hata: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.products) { product in
                            NavigationLink(
                                destination: ProductEditView(viewModel: viewModel, product: product)
                            ) {
                                HStack {
                                    if let firstImageUrl = product.images.first, let url = URL(string: firstImageUrl) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                            .foregroundColor(.gray)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(product.title)
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text("₺\(product.price)")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        Text(product.category.name)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let product = viewModel.products[index]
                                Task {
                                    await viewModel.deleteProduct(id: product.id)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Ürünler")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddProduct = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Çıkış") {
                        authViewModel.isLoggedIn = false
                        UserDefaults.standard.removeObject(forKey: "access_token")
                    }
                }
            }
            .sheet(isPresented: $showAddProduct) {
                NavigationView {
                    ProductAddView(viewModel: viewModel)
                }
            }
        }
        .onAppear {
            Task { await viewModel.fetchProducts() }
        }
    }
}

#Preview {
    ProductView()
}
