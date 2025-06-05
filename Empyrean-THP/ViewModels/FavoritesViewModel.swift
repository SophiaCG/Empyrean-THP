//
//  FavoritesViewModel.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/4/25.
//

import Foundation

struct UserPreferences {
    private static let favoritesKey = "favoriteIndices"

    static var favoriteIndices: [Int] {
        get {
            UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: favoritesKey)
        }
    }
}

class FavoritesViewModel: ObservableObject {
    @Published var favoriteIndices: [Int] = UserPreferences.favoriteIndices

    func toggleFavorite(for index: Int) {
        if favoriteIndices.contains(index) {
            favoriteIndices.removeAll { $0 == index }
        } else {
            favoriteIndices.append(index)
        }
        UserPreferences.favoriteIndices = favoriteIndices
    }
}
