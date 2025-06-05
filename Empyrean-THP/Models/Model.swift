//
//  Model.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation
import CoreData

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let avatar: String
}

struct Item: Codable, Identifiable {
    let id: Int
    let title: String?
    let summary: String?
    let userId: Int
    let image: String?
}

struct Comment: Codable, Identifiable {
    let id: Int
    let author: String
    let message: String
    let timestamp: String
}

extension PostEntity {
    var asItem: Item {
        Item(
            id: Int(self.id),
            title: self.title,
            summary: self.summary,
            userId: Int(self.users?.id ?? 0),
            image: self.image
        )
    }

    var commentModels: [Comment] {
        let set = comments as? Set<CommentEntity> ?? []
        return set.map { $0.asComment }.sorted { $0.timestamp < $1.timestamp }
    }
}

extension UserEntity {
    var asUser: User? {
        guard let name = name,
              let email = email,
              let avatar = avatar else {
            return nil
        }

        return User(id: Int(id), name: name, email: email, avatar: avatar)
    }
}

extension CommentEntity {
    var asComment: Comment {
        Comment(
            id: Int(bitPattern: self.id),
            author: self.author ?? "",
            message: self.message ?? "",
            timestamp: self.timestamp ?? ""
        )
    }
}
