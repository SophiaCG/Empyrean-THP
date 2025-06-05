//
//  HeartButton.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/5/25.
//

import SwiftUI
import CoreData

struct HeartButton: View {

    @Environment(\.managedObjectContext) private var viewContext

    @Binding var isLiked: Bool
    @Binding var item: Item
    @Binding var user: User
    @Binding var comments: [Comment]

    var onUnlike: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            let postId = $item.id

            if doesPostExist(withId: postId, in: viewContext) {
                deletePost(withId: postId, in: viewContext)
                isLiked = false
                onUnlike?()
            } else {
                let newPost = PostEntity(context: viewContext)
                newPost.id = Int64(postId)
                newPost.title = item.title
                newPost.summary = item.summary
                newPost.image = item.image

                let newUser = UserEntity(context: viewContext)
                newUser.id = Int64(user.id)
                newUser.name = user.name
                newUser.email = user.email
                newUser.avatar = user.avatar
                newUser.post = newPost

                for comment in comments {
                    let newComment = CommentEntity(context: viewContext)
                    newComment.author = comment.author
                    newComment.message = comment.message
                    newComment.timestamp = comment.timestamp
                    newComment.post = newPost
                }

                do {
                    try viewContext.save()
                    isLiked = true
                } catch {
                    print("Failed to save post: \(error)")
                }
            }
        }) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .primary)
                .font(.system(size: 30))
                .fontWeight(.light)
        }
        .onAppear {
            isLiked = doesPostExist(withId: $item.id, in: viewContext)
        }
        .onChange(of: item.id) {
            isLiked = doesPostExist(withId: item.id, in: viewContext)
        }
    }

    // MARK: - Core Data Helpers

    func doesPostExist(withId id: Int, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.fetchLimit = 1

        do {
            return try context.count(for: fetchRequest) > 0
        } catch {
            print("Error checking if post exists: \(error)")
            return false
        }
    }

    func deletePost(withId id: Int, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            for post in results {
                context.delete(post)
            }
            try context.save()
        } catch {
            print("Error deleting post: \(error)")
        }
    }
}
