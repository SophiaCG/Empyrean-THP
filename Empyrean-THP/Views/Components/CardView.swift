//
//  CardView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

// A view that displays a stylized card with an image background, title, summary, and author information
// Part of the carousel component
struct CardView: View {
    
    // The item containing data to display (image, title, summary)
    @State var item: Item
    
    // The username of the item's author
    @State var username: String

    var body: some View {
        ZStack {
            ZStack {
                // Async image loading for the background
                AsyncImageView(imageUrl: item.image ?? "")
                
                // Semi-transparent overlay to improve text readability
                Color.white
                    .opacity(0.6)
            }
            .frame(
                maxWidth: UIScreen.main.bounds.width * 0.9,
                maxHeight: .infinity
            )
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 5)
            
            VStack(alignment: .leading) {
                Spacer()
                
                // Title of the item
                Text(item.title ?? "")
                    .font(.title2)
                    .bold()
                
                // Short summary of the item
                Text(item.summary ?? "")
                    .font(.caption)
                    .bold()
                
                // Author attribution
                Text("By \(username)")
                    .font(.caption)
                    .bold()
                    .padding(.top, 2)
            }
            .padding(.bottom, 30)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
        }
    }
}
