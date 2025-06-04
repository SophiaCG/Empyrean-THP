//
//  AsyncImageView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

struct AsyncImageView: View {
    
    var imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Color.gray
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
