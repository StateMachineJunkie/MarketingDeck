//
//  TargetListView.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import MapKit
import SwiftData
import SwiftUI

struct TargetListView: View {

    enum Error: Swift.Error {
        case noLocation
    }

    @Environment(\.modelContext) private var context

    enum SortOrder { case ascending, descending }

    @State private var error: Swift.Error?
    @State private var isLoading = false
    @State private var isNavigating = false
    @State private var isShowingError = false
    @State private var searchText = ""
    @State private var selectedTarget: MarketingTarget?

    #if false // I chose to filter in memory. If the dataset size grows past hundreds into thousands, this will change.
    @Query(filter: #Predicate<MarketingTarget> { target in
        target.searchIndex.localizedCaseInsensitiveContains(searchText.lowercased())
    }) private var targets: [MarketingTarget]
    #else
    @Query private var targets: [MarketingTarget]
    #endif

    var filteredTargets: [MarketingTarget] {
        if searchText.isEmpty {
            return targets
        } else {
            return targets.filter { $0.searchIndex.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section(header: Header(text: "\(filteredTargets.count) Records")) {
                        ForEach(filteredTargets) { target in
                            Button {
                                if target.location == nil {
                                    isLoading = true
                                    Task {
                                        do {
                                            let coord = try await geocodeWithMapKit(address: target.address)
                                            target.updateLocation(with: coord)
                                            navigate(to: target)
                                        } catch {
                                            self.error = error
                                            isShowingError = true
                                        }
                                        isLoading = false
                                    }
                                } else {
                                    navigate(to: target)
                                }
                            } label: {
                                Text(target.name)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                if isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView("Please wait...")
                        .padding(40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Marketing Targets")
            .navigationDestination(isPresented: $isNavigating) {
                if let selectedTarget {
                    TargetDetailView(target: selectedTarget)
                }
            }
            .alert("Error", isPresented: $isShowingError, presenting: error?.localizedDescription) { _ in
                Button("OK", role: .cancel) {}
            } message: { msg in
                Text(msg)
            }
        }
    }

    init(sortOrder: SortOrder = .ascending) {
        let order = sortOrder
        _targets = Query(sort: \MarketingTarget.name, order: order == .ascending ? .forward : .reverse)
    }

    private func geocodeWithMapKit(address: Address) async throws -> CLLocationCoordinate2D {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address.description
        // Optionally, you can bias the search to the current region
        request.resultTypes = [.address]

        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            if let mapItem = response.mapItems.first {
                return mapItem.location.coordinate
            } else {
                throw Error.noLocation
            }
        }
    }

    private func navigate(to target: MarketingTarget) {
        selectedTarget = target
        isNavigating = true
    }
}

private struct Header: View {

    let text: String

    var body: some View {
        HStack {
            Spacer()
            Text(text)
            Spacer()
        }
    }
}
