//
//  MarketingDeckApp.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import SwiftUI
import SwiftData

@main
struct MarketingDeckApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MarketingTarget.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
