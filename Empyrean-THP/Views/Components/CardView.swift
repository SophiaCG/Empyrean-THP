//
//  CardView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

struct CardView: View {
    @State var item: Item
    @State var username: String

    var body: some View {
        ZStack {
            ZStack {
                AsyncImageView(imageUrl: item.image ?? "")

                Color.white
                    .opacity(0.6)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: .infinity)
            .clipped()
            .cornerRadius(20)
            .shadow(radius: 5)

            VStack (alignment: .leading) {
                Spacer()
                Text(item.title ?? "")
                    .font(.title2)
                    .bold()
                Text(item.summary ?? "")
                    .font(.caption)
                    .bold()
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
