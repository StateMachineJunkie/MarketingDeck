//
//  MarketingTarget.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import Foundation
import MapKit
import SwiftData

@Model
final class MarketingTarget: Identifiable {
    @Attribute(.unique)
    private(set) var id = UUID()
    private(set) var createdAt = Date.now
    private(set) var updatedAt = Date.now
    private(set) var name: String
    private(set) var address: Address
    private(set) var location: Location?

    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }

    func updateName(with name: String) {
        self.name = name
        updatedAt = Date.now
    }

    func updateAddress(with address: Address) {
        self.address = address
        location = nil
        updatedAt = Date.now
    }

    func updateLocation(with locationCoordinates: CLLocationCoordinate2D) {
        self.location = Location(from: locationCoordinates)
        updatedAt = Date.now
    }
}

extension MarketingTarget {
    var searchIndex: String {
        "\(name)\(address.searchIndex)"
    }
}

extension MarketingTarget: CustomStringConvertible {
    @MainActor var description: String {
        "\(name)\n\(address)"
    }
}

extension MarketingTarget: CustomDebugStringConvertible {
    var debugDescription: String {
        "\(Self.self): \(id)"
    }
}
