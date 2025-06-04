//
//  Empyrean_THPApp.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/2/25.
//

import SwiftUI

@main
struct Empyrean_THPApp: App {
    @StateObject var loginVM = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginVM)
        }
    }
}
