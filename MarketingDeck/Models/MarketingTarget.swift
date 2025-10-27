//
//  MarketingTarget.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import Foundation
import SwiftData

@Model
final class MarketingTarget: Identifiable {
    @Attribute(.unique)
    var id = UUID()
    var createdAt = Date.now
    var updatedAt = Date.now
    var name: String
    var address: Address

    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
}

extension MarketingTarget {
    var searchIndex: String {
        "\(name)\(address.searchIndex)"
    }
}

extension MarketingTarget: CustomStringConvertible {
    var description: String {
        "\(name)\n\(address)"
    }
}

extension MarketingTarget: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(Self.self): \(id)"
    }
}
