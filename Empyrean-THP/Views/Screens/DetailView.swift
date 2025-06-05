//
//  DetailView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import Foundation
import SwiftUI
import CoreData

struct DetailView: View {

    @State var item: Item
    @State var user: User
    @State var comments: [Comment]

    @State private var isLiked = false
    var onUnlike: (() -> Void)? = nil

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                HeartButton(isLiked: $isLiked, item: $item, user: $user, comments: $comments, onUnlike: onUnlike)
            }
            .padding([.horizontal, .top], 25)
            .padding(.bottom, 10)

            AsyncImageView(imageUrl: item.image ?? "")
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: 250)

            VStack (alignment: .leading, spacing: 10) {

                Text(item.title ?? "")
                    .font(.title)
                    .bold()
                
                Text(item.summary ?? "")
                    .font(.caption)
                    .bold()
                                
                Divider()
                    .frame(height: 1)
                    .overlay(.gray)
                    .padding(.vertical)
                
                ZStack {
                    Color.brown
                        .opacity(0.3)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    
                    HStack {
                        AsyncImageView(imageUrl: user.avatar)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack (alignment: .leading) {
                            Text("Author: \(user.name)")
                                .fontWeight(.heavy)
                            Text("Contact: \(user.email)")
                                .bold()
                        }.padding(.leading, 10)
                        
                        Spacer()
                    }.padding()

                }
                .frame(width: UIScreen.main.bounds.width * 0.9)

                HStack (spacing: 5) {
                    Text("Comments")
                        .fontWeight(.heavy)
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 25, height: 25)
                        
                        Text("\(comments.count)")
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.heavy)
                    }
                }

                ForEach(comments) { comment in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .opacity(0.5)
                                .frame(width: 35, height: 35)
                            
                            Text(String(comment.author.first ?? " "))
                                .foregroundColor(.white)
                        }
                        VStack (alignment: .leading) {
                            HStack {
                                Text(comment.author)
                                    .fontWeight(.heavy)
                                    .font(.caption)
                                Text(formatTimestamp(comment.timestamp))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                            }
                            
                            Text(comment.message)
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
            }.padding(.horizontal)
        }
    }
    
    func formatTimestamp(_ isoString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .short
        outputFormatter.timeStyle = .short

        if let date = inputFormatter.date(from: isoString) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }    
}
