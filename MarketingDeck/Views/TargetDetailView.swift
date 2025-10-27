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
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "person.fill")
                    .frame(width: 24, alignment: .center)
                Text(target.name)
                    .multilineTextAlignment(.leading)
            }

            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "house.fill")
                    .frame(width: 24, alignment: .center)
                Text(target.address.description)
                    .multilineTextAlignment(.leading)
            }

            MapView(address: target.address)
        }
        .navigationTitle("\(target.name)")
    }
}

#Preview {
    TargetDetailView(target: .init(name: "Test", address: .init(address1: "123 Main", city: "Springfield", state: "IL", zip: "62701")))
}
