//
//  DetailView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/3/25.
//

import SwiftUI
import Foundation

struct DetailView: View {
    
    @StateObject private var usersVM = UsersViewModel()
    @StateObject private var itemsVM = ItemsViewModel()
    @EnvironmentObject var loginVM: LoginViewModel

    @State var item: Item

    var body: some View {
        ScrollView {
                AsyncImageView(imageUrl: item.image)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, maxHeight: 250)
            VStack (alignment: .leading, spacing: 10) {

                Text(item.title)
                    .font(.title)
                    .bold()
                
                Text(item.summary)
                    .font(.caption)
                    .bold()
                
                Spacer(minLength: 50)
                
                ZStack {
                    Color.brown
                        .opacity(0.3)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    
                    HStack {
                        AsyncImageView(imageUrl: usersVM.user.avatar)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack (alignment: .leading) {
                            Text("Author: \(usersVM.user.name)")
                                .fontWeight(.heavy)
                            Text("Contact: \(usersVM.user.email)")
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
                        
                        Text("\(itemsVM.comments.count)")
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.heavy)
                    }
                }

                ForEach(itemsVM.comments) { comment in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.random)
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
        .onAppear {
            if let token = loginVM.token {
                usersVM.fetchUserDetails(token: token, id: item.userId)
                itemsVM.fetchItemComments(token: token, id: item.id)
            }
        }

    }
    
    func formatTimestamp(_ isoString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Adjust as needed

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

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
