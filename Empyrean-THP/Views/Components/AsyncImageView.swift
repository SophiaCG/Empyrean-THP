//
//  AsyncImageView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

// Reusable view that asynchronously loads and displays an image from a URL
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
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .padding(.top, 30)
                    Text("Failed to load image")
                        .foregroundColor(.red)
                        .font(.caption)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
