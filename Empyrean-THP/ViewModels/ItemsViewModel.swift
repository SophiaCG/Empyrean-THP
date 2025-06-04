//
//  ItemsViewModel.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var item: Item = Item(id: 0, title: "", summary: "", userId: 0, image: "")
    @Published var comments: [Comment] = []
    @Published var errorMessage = ""

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
