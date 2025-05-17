//
//  ProductModel.swift
//  Platzi_Fake_API
//
//  Created by Ali Osman Öztürk on 17.05.2025.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let images: [String]
    let category: Category
}

struct Category: Codable {
    let id: Int
    let name: String
    let image: String
}
