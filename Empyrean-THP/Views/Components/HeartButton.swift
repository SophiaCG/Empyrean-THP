//
//  HeartButton.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/5/25.
//

import SwiftUI
import CoreData

// A button that toggles the "like" state of an item and stores/removes it from Core Data
struct HeartButton: View {

    // The Core Data context used to read/write PostEntity, UserEntity, and CommentEntity
    @Environment(\.managedObjectContext) private var viewContext

    // Binding to track whether the current item is liked
    @Binding var isLiked: Bool

    // Binding to the item being displayed
    @Binding var item: Item

    // Binding to the associated user (author of the item)
    @Binding var user: User

    // Binding to the comments associated with the item
    @Binding var comments: [Comment]

    // Optional callback when the item is unliked
    var onUnlike: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            let postId = $item.id  // Access item ID

            if doesPostExist(withId: postId, in: viewContext) {
                // If item is already liked, remove it from Core Data
                deletePost(withId: postId, in: viewContext)
                isLiked = false
                onUnlike?()
            } else {
                // Otherwise, create new Core Data entries for the post, user, and comments
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

                // Attempt to save all data to Core Data
                do {
                    try viewContext.save()
                    isLiked = true
                } catch {
                    print("Failed to save post: \(error)")
                }
            }
        }) {
            // Heart Icon UI
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .primary)
                .font(.system(size: 30))
                .fontWeight(.light)
        }
        .onAppear {
            // Set `isLiked` on load by checking Core Data
            isLiked = doesPostExist(withId: $item.id, in: viewContext)
        }
        .onChange(of: item.id) {
            // Update `isLiked` if the item changes
            isLiked = doesPostExist(withId: item.id, in: viewContext)
        }
    }

    // MARK: - Core Data Helpers
    // Checks whether a post with the given ID exists in Core Data
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

    // Deletes a post with the given ID from Core Data
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
