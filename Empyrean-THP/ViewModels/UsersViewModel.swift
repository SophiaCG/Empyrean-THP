//
//  UsersViewModel.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var user: User = User(id: 0, name: "", email: "", avatar: "")
    @Published var errorMessage = ""
    
    var usersById: [Int: User] {
        Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
    }

    func name(for userId: Int) -> String {
        usersById[userId]?.name ?? "Unknown User"
    }

    func fetchAllUsers(token: String) {
        APIService.shared.fetch(.users, token: token) { [weak self] (result: Result<[User], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchUserDetails(token: String, id: Int) {
        APIService.shared.fetch(.user(id: id), token: token) { [weak self] (result: Result<User, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
