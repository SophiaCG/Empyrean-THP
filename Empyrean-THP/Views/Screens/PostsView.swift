//
//  PostsView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

// Displays all posts in a scrollable list with a featured carousel, includes navigation to favorites and detailed post view.
struct PostsView: View {
    
    // Controls the view’s presentation state
    @Environment(\.presentationMode) var presentationMode

    // View models to fetch and manage data
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject private var itemsVM = ItemsViewModel()
    @StateObject private var usersVM = UsersViewModel()

    // View state for tracking current carousel index and selected item
    @State private var currentIndex = 0
    @State private var selectedItem: Item? = nil
    @State private var showingDetail = false

    var body: some View {
        ZStack {
            // Background styling
            Color.blue
                .opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                // Display an error message if item fetching failed
                if !itemsVM.errorMessage.isEmpty {
                    Text("Error: \(itemsVM.errorMessage)")
                        .foregroundColor(.red)
                }

                // Scrollable list of posts
                ScrollView {
                    VStack(spacing: 15) {
                        // MARK: - Featured Carousel (Top 5 Posts)
                        if itemsVM.items.count >= 5 {
                            VStack {
                                TabView(selection: $currentIndex) {
                                    ForEach(Array(itemsVM.items.prefix(5).enumerated()), id: \.element.id) { index, item in
                                        CardView(item: item, username: usersVM.name(for: item.userId))
                                            .onTapGesture {
                                                // Fetch user and comment details when a card is tapped
                                                if let token = loginVM.token {
                                                    usersVM.fetchUserDetails(token: token, id: item.userId)
                                                    itemsVM.fetchItemComments(token: token, id: item.id)
                                                }
                                                selectedItem = item
                                                showingDetail = true
                                            }
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .frame(height: 250)
                            }
                        }

                        // MARK: - List of Remaining Posts
                        ForEach(itemsVM.items.dropFirst(5)) { item in
                            RowView(item: item, username: usersVM.name(for: item.userId))
                                .onTapGesture {
                                    // Fetch detailed data when row is tapped
                                    if let token = loginVM.token {
                                        usersVM.fetchUserDetails(token: token, id: item.userId)
                                        itemsVM.fetchItemComments(token: token, id: item.id)
                                    }
                                    selectedItem = item
                                    showingDetail = true
                                }
                        }
                    }
                }
            }
        }
        // MARK: - Toolbar with Navigation to Favorites
        .toolbar {
            // Logout button
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Logout") {
                    loginVM.logout()
                    presentationMode.wrappedValue.dismiss()
                }
            }

            // Favorites List button
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    FavoritesListView()
                } label: {
                    HStack {
                        Text("Favorited")
                            .bold()
                            .foregroundColor(.red)
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("favoritesButton")
            }
        }

        // Hide back button
        .navigationBarBackButtonHidden(true)

        // MARK: - Data Fetching on View Appear
        .onAppear {
            if let token = loginVM.token {
                itemsVM.fetchAllItems(token: token)
                usersVM.fetchAllUsers(token: token)
            }
        }

        // MARK: - Detail View Sheet
        .sheet(isPresented: $showingDetail) {
            if let item = selectedItem {
                DetailView(
                    item: item,
                    user: usersVM.user,
                    comments: itemsVM.comments
                )
            }
        }
    }
}
