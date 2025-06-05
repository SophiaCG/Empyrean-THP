//
//  LoginViewModel.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation

// ViewModel responsible for handling user login logic and validating credentials
class LoginViewModel: ObservableObject {
        
    @Published var username = "test"
    @Published var password = "password123"
    @Published var token: String?   // Stores the JWT token received after successful login
    @Published var errorMessage = ""
    
    @Published var isAuthenticated = false  // Indicates whether login was successful
    @Published var wrongUsername = false
    @Published var wrongPassword = false
    @Published var isLoading = false    // Indicates login request is loading

    // Attempts to log the user in with the current username and password.
    func login() {
        // Reset state before attempting login
        isLoading = true
        errorMessage = ""
        isAuthenticated = false
        wrongUsername = false
        wrongPassword = false

        // Username and password validation
        wrongUsername = username != "test"
        wrongPassword = password != "password123"

        // If either username or password is wrong, update error state and exit early
        if wrongUsername || wrongPassword {
            errorMessage = "Invalid credentials"
            isAuthenticated = false
            isLoading = false
            return
        }

        // If hardcoded validation passes, call the API login method
        APIService.shared.login(username: username, password: password) { [weak self] result in
            // Make sure UI updates happen on main thread
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let newToken):
                    // Store the received token and update authentication state
                    self?.token = newToken
                    self?.errorMessage = ""
                    self?.isAuthenticated = true
                case .failure(let error):
                    // Update error message on failure and mark not authenticated
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                }
            }
        }
    }
}
