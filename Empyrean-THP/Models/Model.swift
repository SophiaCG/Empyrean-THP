//
//  Model.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let avatar: String
}

struct Item: Codable, Identifiable {
    let id: Int
    let title: String
    let summary: String
    let userId: Int
    let image: String
}

struct Comment: Codable, Identifiable {
    let id: Int
    let author: String
    let message: String
    let timestamp: String
}
