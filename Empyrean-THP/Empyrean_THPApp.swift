//
//  Empyrean_THPApp.swift
//  Empyrean-THP
//
//  Created by Sophia Gorgonio on 6/2/25.
//

import SwiftUI
import CoreData

@main
struct Empyrean_THPApp: App {
    @StateObject var loginVM = LoginViewModel()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginVM)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

        }
    }
}

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PostsModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
