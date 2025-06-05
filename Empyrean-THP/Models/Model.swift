//
//  Model.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation
import CoreData

// MARK: - Codable Models (for decoding JSON responses)

// Represents a user in the system
struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let avatar: String
}

// Represents an item/post returned by the API
struct Item: Codable, Identifiable {
    let id: Int
    let title: String?
    let summary: String?
    let userId: Int
    let image: String?
}

// Represents a comment on an item/post
struct Comment: Codable, Identifiable {
    let id: Int
    let author: String
    let message: String
    let timestamp: String
}

// MARK: - Core Data Entity Extensions

// Converts a Core Data PostEntity into an Item model
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

    // Converts related CommentEntities into [Comment] models, sorted by timestamp
    var commentModels: [Comment] {
        let set = comments as? Set<CommentEntity> ?? []
        return set.map { $0.asComment }.sorted { $0.timestamp < $1.timestamp }
    }
}

// Converts a Core Data UserEntity into a User model
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

// Converts a Core Data CommentEntity into a Comment model
extension CommentEntity {
    var asComment: Comment {
        Comment(
            id: Int(bitPattern: self.id), // Uses bitPattern to convert NSManagedObjectID to Int
            author: self.author ?? "",
            message: self.message ?? "",
            timestamp: self.timestamp ?? ""
        )
    }
}
