//
//  RowView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

// Reusable row view for displaying a summarized card of an item with its image and author
struct RowView: View {
    // MARK: - Properties

    // The item to be displayed
    @State var item: Item

    // The name of the user who posted the item
    @State var username: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Display item title
                Text(item.title ?? "")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .bold()

                // Display item summary
                Text(item.summary ?? "")
                    .font(.caption)

                // Display author's name
                Text("By \(username)")
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .bold()
                    .padding(.top, 5)
            }

            Spacer()

            // Thumbnail Image
            AsyncImageView(imageUrl: item.image ?? "")
                .frame(width: 125, height: 75) // Fixed size for the image
        }
        .padding(15)
        .shadow(radius: 5)
        .background(Color.white)
        .cornerRadius(10)
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}
