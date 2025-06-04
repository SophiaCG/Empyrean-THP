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

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .opacity(0.60)
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
                                            NavigationLink {
                                                DetailView(item: item)
                                            } label: {
                                                CardView(item: item, username: usersVM.name(for: item.userId))
                                                    .tag(index)
                                            }.buttonStyle(.plain)
                                        }
                                    }
                                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default dots
                                    .frame(height: 250)
                                    
                                    // Custom dots
                                    HStack(spacing: 8) {
                                        ForEach(0..<min(itemsVM.items.count, 5), id: \.self) { index in
                                            Circle()
                                                .fill(index == currentIndex ? Color.white : Color.gray.opacity(0.5))
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                }
                            }
                            
                            ForEach(itemsVM.items.dropFirst(5)) { item in
                                NavigationLink {
                                    DetailView(item: item)
                                } label: {
                                    RowView(item: item, username: usersVM.name(for: item.userId))
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if let token = loginVM.token {
                itemsVM.fetchAllItems(token: token)
                usersVM.fetchAllUsers(token: token)
            }
        }
    }
}

#Preview {
    PostsView()
}
