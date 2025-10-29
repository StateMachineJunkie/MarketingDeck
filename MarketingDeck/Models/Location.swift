//
//  Location.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import Foundation
import CoreLocation

nonisolated struct Location: Codable, Hashable, Sendable {
    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Location {
    var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(from locationCoordinates: CLLocationCoordinate2D) {
        latitude = locationCoordinates.latitude
        longitude = locationCoordinates.longitude
    }
}

extension Location: CustomStringConvertible {
    var description: String {
        "\(latitude)° \(latitude > 0.0 ? "N" : "S"), \(longitude)° \(longitude > 0.0 ? "E" : "W")"
    }
}
