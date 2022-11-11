//
//  OhMyPlantApp.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import SwiftUI

@main
struct OhMyPlantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(AppState.shared)
        }
    }
}
