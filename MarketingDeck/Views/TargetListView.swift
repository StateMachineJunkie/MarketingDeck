//
//  TargetListView.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import SwiftData
import SwiftUI

struct TargetListView: View {
    @Environment(\.modelContext) private var context

    enum SortOrder { case ascending, descending }

    @State private var searchText = ""

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
            List {
                Section(header: Header(text: "\(filteredTargets.count) Records")) {
                    ForEach(filteredTargets) { target in
                        NavigationLink(destination: TargetDetailView(target: target)) {
                            Text(target.name)
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Marketing Targets")
        }
    }

    init(sortOrder: SortOrder = .ascending) {
        let order = sortOrder
        _targets = Query(sort: \MarketingTarget.name, order: order == .ascending ? .forward : .reverse)
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
