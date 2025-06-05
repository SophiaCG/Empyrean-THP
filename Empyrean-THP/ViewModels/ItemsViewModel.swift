//
//  ItemsViewModel.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation

// ViewModel class for managing and providing data related to Items and their comments
// Conforms to ObservableObject so SwiftUI views can observe and react to data changes
class ItemsViewModel: ObservableObject {
    
    // List of all items
    @Published var items: [Item] = []
    
    // Single item
    @Published var item: Item = Item(id: 0, title: "", summary: "", userId: 0, image: "")
    
    // Array of comments related to the selected item
    @Published var comments: [Comment] = []
    
    // Stores error messages to display or handle errors in the UI
    @Published var errorMessage = ""

    // Fetch all items from the API
    func fetchAllItems(token: String) {
        APIService.shared.fetch(.items, token: token) { [weak self] (result: Result<[Item], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.items = items
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Fetch details of a single item by its ID
    func fetchItemDetails(token: String, id: Int) {
        APIService.shared.fetch(.item(id: id), token: token) { [weak self] (result: Result<Item, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let item):
                    self?.item = item
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Fetch comments for a given item by its ID
    func fetchItemComments(token: String, id: Int) {
        APIService.shared.fetch(.comments(itemId: id), token: token) { [weak self] (result: Result<[Comment], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.comments = comments
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
