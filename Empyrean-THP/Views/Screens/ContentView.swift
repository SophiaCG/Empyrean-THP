//
//  ContentView.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/2/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginVM: LoginViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue
                    .ignoresSafeArea()

                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)

                VStack {
                    Text("Empyrean News")
                        .font(.largeTitle)
                        .bold()

                    Spacer().frame(height: 50)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(loginVM.wrongUsername ? Color.red : Color.gray, lineWidth: loginVM.wrongUsername ? 2 : 1)
                            .background(Color.black.opacity(0.05).cornerRadius(10))
                            .frame(height: 50)
                        
                        TextField("Username", text: $loginVM.username)
                            .padding(.horizontal)
                            .autocapitalization(.none)
                    }
                    .frame(width: 300)
                    .padding(.bottom, 10)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(loginVM.wrongPassword ? Color.red : Color.gray, lineWidth: loginVM.wrongPassword ? 2 : 1)
                            .background(Color.black.opacity(0.05).cornerRadius(10))
                            .frame(height: 50)
                        
                        SecureField("Password", text: $loginVM.password)
                            .padding(.horizontal)
                            .autocapitalization(.none)
                    }
                    .frame(width: 300)

                    Spacer().frame(height: 50)
                    
                    Button(action: {
                        loginVM.login()
                    }) {
                        Text("Login")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)

                    if !loginVM.errorMessage.isEmpty {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text("Error: \(loginVM.errorMessage)").foregroundColor(.red)
                    }
                }
                if loginVM.isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView("Logging in...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $loginVM.isAuthenticated) {
                PostsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
