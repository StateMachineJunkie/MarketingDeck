//
//  BundleExtension.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 6/20/25.
//

import UIKit

extension Bundle {
    static let loggerID: String = {
        if let id = Bundle.main.bundleIdentifier {
            return id
        } else {
            return Bundle.main.description
        }
    }()
}
