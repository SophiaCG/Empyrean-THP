//
//  RowView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI

struct RowView: View {
    @State var item: Item
    @State var username: String

    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(item.title)
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .bold()
                Text(item.summary)
                    .font(.caption)
                Text("By \(username)")
                    .font(.caption)
                    .foregroundStyle(.blue)
                    .bold()
                    .padding(.top, 5)
            }
            
            Spacer()

            AsyncImageView(imageUrl: item.image)
                .frame(width: 125, height: 75)

        }
        .padding(15)
        .shadow(radius: 5)
        .background(Color.white)
        .cornerRadius(10)
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

