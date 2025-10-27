//
//  Address.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/24/25.
//

import Foundation

nonisolated struct Address: Codable, Hashable, Sendable {
    let address1: String
    let address2: String
    let city: String
    let state: String
    let zip: String
    let county: String?
    let country: String

    init(address1: String,
         address2: String = "",
         city: String,
         state: String,
         zip: String,
         county: String? = nil,
         country: String = "US") {
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.county = county
        self.country = country
    }
}

extension Address {
    var isValid: Bool {
        !address1.isEmpty && !city.isEmpty && !state.isEmpty && !zip.isEmpty
    }

    var searchIndex: String {
        "\(address1)\(address2)\(city)\(state)\(zip)"
    }

    var streetAddress: String {
        if address2.isEmpty {
            "\(address1)"
        } else {
            "\(address1)\n\(address2)"
        }
    }
}

extension Address: CustomStringConvertible {
    var description: String {
        if address2.isEmpty {
            "\(address1)\n\(city), \(state), \(zip)"
        } else {
            "\(address1)\n\(address2)\n\(city), \(state), \(zip)"
        }
    }
}
