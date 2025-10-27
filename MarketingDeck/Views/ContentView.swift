//
//  ContentView.swift
//  CustomerDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    /// The SwiftData model context injected from the environment, allowing for data operations.
    @Environment(\.modelContext) private var modelContext
    @State private var isImporting = false

    var body: some View {
        TabView {
            NavigationStack {
                TargetListView()
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                isImporting = true
                            }) {
                                Image(systemName: "square.and.arrow.down")
                            }
                            .fileImporter(isPresented: $isImporting,
                                          allowedContentTypes: [UTType.commaSeparatedText],
                                          onCompletion: importCSVFile)
                        }
                    }
            }
            .tabItem {
                Label("Targets", systemImage: "person.3")
            }
        }
    }

    private func importCSVFile(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            do {
                if url.startAccessingSecurityScopedResource() {
                    defer { url.stopAccessingSecurityScopedResource() }
                    try modelContext.importMarketingTargets(from: url)
                }
            } catch {
                print("Failed to import CSV: \(error)")
            }
        case .failure:
            break
        }
    }
}

#Preview {
    ContentView()
}
