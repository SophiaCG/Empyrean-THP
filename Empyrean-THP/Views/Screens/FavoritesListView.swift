//
//  FavoritesListView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/4/25.
//

import SwiftUI
import CoreData

// Displays a list of favorited posts stored in Core Data.
struct FavoritesListView: View {

    // Core Data Context
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch Request for Saved Posts
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.id, ascending: true)],
        animation: .default
    )
    private var posts: FetchedResults<PostEntity>

    @State private var selectedPost: PostEntity? = nil  // Selected post for detail view
    @State private var showingDetail = false            // Controls whether the detail view is shown

    var body: some View {
        ZStack {
            // Background color with light blue overlay
            Color.blue
                .opacity(0.4)
                .ignoresSafeArea()

            // MARK: - Empty State
            if posts.isEmpty {
                VStack {
                    Text("No Favorites")
                        .bold()
                        .font(.title)

                    Text("You haven't saved any posts yet.")
                        .bold()

                    HStack (alignment: .top) {
                        Text("Tap on the")
                            .bold()
                            .foregroundColor(.red)

                        Image(systemName: "heart")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                            .fontWeight(.light)

                        Text("in the top right corner of a post to save it.")
                            .bold()
                            .foregroundColor(.red)
                    }
                }
                .padding()

            // MARK: - Favorites List
            } else {
                ScrollView {
                    ForEach(posts, id: \.id) { post in
                        // Display each post using RowView
                        RowView(item: post.asItem, username: post.users?.name ?? "")
                            .onTapGesture {
                                // When tapped, show the post in detail view
                                selectedPost = post
                                showingDetail = true
                            }
                    }
                }
            }
        }

        // MARK: - Sheet for Post Details
        .sheet(item: $selectedPost) { item in
            // Only show detail view if we can extract a user object
            if let coreDataUser = item.users?.asUser {
                DetailView(
                    item: item.asItem,
                    user: coreDataUser,
                    comments: item.commentModels,
                    onUnlike: {
                        // Dismiss detail view if user unlikes the post
                        selectedPost = nil
                    }
                )
            }
        }
    }
}
