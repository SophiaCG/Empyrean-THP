//
//  LoginViewModel.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var username = "test"
    @Published var password = "password123"
    @Published var token: String?
    @Published var errorMessage = ""

    @Published var isAuthenticated = false
    @Published var wrongUsername = false
    @Published var wrongPassword = false
    @Published var isLoading = false

    func login() {
        // Reset state
        isLoading = true
        errorMessage = ""
        isAuthenticated = false
        wrongUsername = false
        wrongPassword = false

        // Temporary hardcoded check
        wrongUsername = username != "test"
        wrongPassword = password != "password123"

        if wrongUsername || wrongPassword {
            errorMessage = "Invalid credentials"
            isAuthenticated = false
            return
        }

        // If hardcoded credentials pass, continue with API login
        APIService.shared.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let newToken):
                    self?.token = newToken
                    self?.errorMessage = ""
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                }
            }
        }
    }
}
