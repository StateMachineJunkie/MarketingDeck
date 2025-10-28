//
//  ContentView.swift
//  MarketingDeck
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
    @State private var sortOrder = TargetListView.SortOrder.ascending

    var body: some View {
        TabView {
            NavigationStack {
                TargetListView(sortOrder: sortOrder)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button {
                                sortOrder = .ascending
                            } label: {
                                Image(systemName: sortOrder == .ascending ? "arrow.up.square.fill" : "arrow.up.square")
                            }

                            Button {
                                sortOrder = .descending
                            } label: {
                                Image(systemName: sortOrder == .descending ? "arrow.down.square.fill" :"arrow.down.square")
                            }
                        }

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
