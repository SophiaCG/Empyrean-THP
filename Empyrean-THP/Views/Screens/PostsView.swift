//
//  PostsView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

struct PostsView: View {
    @StateObject private var itemsVM = ItemsViewModel()
    @StateObject private var usersVM = UsersViewModel()
    @EnvironmentObject var loginVM: LoginViewModel
    
    @State private var currentIndex = 0
    @State private var selectedItem: Item? = nil
    @State private var showingDetail = false

    var body: some View {
        ZStack {
            Color.blue
                .opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                if !itemsVM.errorMessage.isEmpty {
                    Text("Error: \(itemsVM.errorMessage)")
                        .foregroundColor(.red)
                }
                
                ScrollView {
                    VStack (spacing: 15) {
                        if itemsVM.items.count >= 5 {
                            VStack {
                                TabView(selection: $currentIndex) {
                                    ForEach(Array(itemsVM.items.prefix(5).enumerated()), id: \.element.id) { index, item in
                                        CardView(item: item, username: usersVM.name(for: item.userId))
                                            .onTapGesture {
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
                        
                        ForEach(itemsVM.items.dropFirst(5)) { item in
                            RowView(item: item, username: usersVM.name(for: item.userId))
                                .onTapGesture {
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
        .toolbar {
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
                }.buttonStyle(.plain)
            }
        }
        .onAppear {
            if let token = loginVM.token {
                itemsVM.fetchAllItems(token: token)
                usersVM.fetchAllUsers(token: token)
            }
        }
        .sheet(isPresented: $showingDetail) {
            if let item = selectedItem {
                DetailView(item: item, user: usersVM.user, comments: itemsVM.comments)
            }
        }
    }
}
