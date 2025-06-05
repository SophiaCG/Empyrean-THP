//
//  FavoritesListView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/4/25.
//

import SwiftUI
import CoreData

struct FavoritesListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PostEntity.id, ascending: true)],
        animation: .default
    )
    private var posts: FetchedResults<PostEntity>

    @State private var selectedPost: PostEntity? = nil
    @State private var showingDetail = false

    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.4)
                .ignoresSafeArea()
            
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
                }.padding()
            } else {
                ScrollView {
                    ForEach(posts, id: \.id) { post in
                        RowView(item: post.asItem, username: post.users?.name ?? "")
                            .onTapGesture {
                                selectedPost = post
                                showingDetail = true
                            }
                    }
                }
            }
        }
        .sheet(item: $selectedPost) { item in
            if let coreDataUser = item.users?.asUser {
                DetailView(
                    item: item.asItem,
                    user: coreDataUser,
                    comments: item.commentModels,
                    onUnlike: {
                        selectedPost = nil
                    }
                )
            }
        }
    }
}
