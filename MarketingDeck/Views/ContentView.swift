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
                            Menu {
                                Button {
                                    isImporting = true
                                } label: {
                                    Label("Import CSV", systemImage: "square.and.arrow.down")
                                }

                                Button {
                                    Task {
                                        let marketingTargets = try modelContext.fetch(FetchDescriptor<MarketingTarget>())
                                        guard marketingTargets.count > 0 else { return }
                                        let pdfData = AddressLabelPDFRenderer.makePDF(for: marketingTargets)
                                        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("MailingLabels.pdf")
                                        try pdfData.write(to: fileURL)

                                        let printController = UIPrintInteractionController.shared
                                        let info = UIPrintInfo(dictionary: nil)
                                        info.outputType = .general
                                        info.jobName = "Mailing Labels"
                                        printController.printInfo = info
                                        printController.printingItem = fileURL
                                        printController.present(animated: true, completionHandler: nil)
                                    }
                                } label: {
                                    Label("Print Targets Labels", systemImage: "printer")
                                }
                                .disabled((try? !modelContext.hasAnyRecords(of: MarketingTarget.self)) ?? false)
                            } label: {
                                Image(systemName: "document")
                            }
                        }
                    }
                    .fileImporter(isPresented: $isImporting,
                                  allowedContentTypes: [UTType.commaSeparatedText],
                                  onCompletion: importCSVFile)
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
