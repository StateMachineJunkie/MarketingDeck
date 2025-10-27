//
//  TargetDetailView.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import SwiftData
import SwiftUI

struct TargetDetailView: View {
    @Bindable var target: MarketingTarget

    var body: some View {
        VStack {
            HStack {
                Label("Name", systemImage: "person.fill")
                Text(target.name)
            }
            .border(.red)
            HStack {
                Label("Address", systemImage: "house.fill")
                Text(target.address.description)
            }
            .border(.blue)
        }
        .border(.yellow)
        .navigationTitle("\(target.name)")
    }
}

#Preview {
    TargetDetailView(target: .init(name: "Test", address: .init(address1: "123 Main", city: "Springfield", state: "IL", zip: "62701")))
}
