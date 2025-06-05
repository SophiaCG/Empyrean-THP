//
//  UsersViewModel.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation

// ViewModel responsible for managing user data, including fetching all users, fetching a specific user, and mapping users by ID.
class UsersViewModel: ObservableObject {
        
    // List of all users
    @Published var users: [User] = []
    
    // A single user's details
    @Published var user: User = User(id: 0, name: "", email: "", avatar: "")
    
    @Published var errorMessage = ""
        
    // Dictionary mapping user IDs to User objects for quick lookup
    var usersById: [Int: User] {
        Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
    }

    // Returns the name of a user by their ID, or "Unknown User" if not found
    func name(for userId: Int) -> String {
        usersById[userId]?.name ?? "Unknown User"
    }
    
    // Fetches all users from the API
    func fetchAllUsers(token: String) {
        APIService.shared.fetch(.users, token: token) { [weak self] (result: Result<[User], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    // Update the list of users on success
                    self?.users = users
                case .failure(let error):
                    // Display error message if request fails
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Fetches details for a specific user based on ID
    func fetchUserDetails(token: String, id: Int) {
        APIService.shared.fetch(.user(id: id), token: token) { [weak self] (result: Result<User, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    // Update the single user object with fetched details
                    self?.user = user
                case .failure(let error):
                    // Display error message if request fails
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
