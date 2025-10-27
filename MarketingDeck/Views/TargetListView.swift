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

    @State private var searchText = ""
    #if false
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
                ForEach(filteredTargets) { target in
                    NavigationLink(destination: TargetDetailView(target: target)) {
                        Text(target.name)
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Marketing Targets")
        }
    }
}
