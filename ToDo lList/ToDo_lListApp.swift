//
//  ToDo_lListApp.swift
//  ToDo List
//
//  Created by Akhmed on 22.09.23.
//

import SwiftUI

@main
struct ToDo_lListApp: App {
    let persistenceController = PersistenceController.shared
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
