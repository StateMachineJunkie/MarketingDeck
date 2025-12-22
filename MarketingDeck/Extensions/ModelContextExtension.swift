//
//  ModelContextExtension.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/27/25.
//

import CreateML
import Foundation
import os.log
import SwiftData

extension ModelContext {

    enum Error: Swift.Error {
        case missingRequiredField(row: MLDataTable.Row, field: String)
    }

    enum ImportField: String, CaseIterable {
        case name       = "Name"
        case address    = "Address"
        case city       = "City"
        case state      = "State"
        case zipcode    = "Zipcode"
    }

    func hasAnyRecords<T: PersistentModel>(of type: T.Type) throws -> Bool {
        let count = try recordCount(of: type)
        return count > 0
    }

    func importMarketingTargets(from csvFile: URL) throws {
        let logger = Logger.logger(for: Self.self)
        let table = try MLDataTable(contentsOf: csvFile)

        logger.debug("\(table)")

        // Parse into plain values first (no insertion in any context yet)
        struct ParsedRow {
            let name: String
            let address: Address
        }

        var parsed: [ParsedRow] = []
        parsed.reserveCapacity(table.rows.count)

        for row in table.rows {
            logger.debug("\(row)")

            guard let name = row[ImportField.name.rawValue]?.stringValue else {
                throw Error.missingRequiredField(row: row, field: ImportField.name.rawValue)
            }

            guard let address1 = row[ImportField.address.rawValue]?.stringValue else {
                throw Error.missingRequiredField(row: row, field: ImportField.address.rawValue)
            }

            guard let city = row[ImportField.city.rawValue]?.stringValue else {
                throw Error.missingRequiredField(row: row, field: ImportField.city.rawValue)
            }

            guard let state = row[ImportField.state.rawValue]?.stringValue else {
                throw Error.missingRequiredField(row: row, field: ImportField.state.rawValue)
            }

            var zip = row[ImportField.zipcode.rawValue]?.stringValue

            if zip == nil {
                guard let intValue = row[ImportField.zipcode.rawValue]?.intValue else {
                    throw Error.missingRequiredField(row: row, field: ImportField.zipcode.rawValue)
                }
                zip = String(intValue)
            }

            let address = Address(address1: address1, city: city, state: state, zip: zip!)
            parsed.append(.init(name: name, address: address))
        }

        // Perform a single-context, single-transaction replace of data
        try transaction {
            // Clear out old data
            try self.delete(model: MarketingTarget.self)

            // Insert new data
            for item in parsed {
                let target = MarketingTarget(name: item.name, address: item.address)
                // naturalKey is set in init based on name + address
                self.insert(target)
                logger.debug("\(target)")
            }

            // Save the main context
            try save()
        }
    }

    func recordCount<T: PersistentModel>(of type: T.Type) throws -> Int {
        let descriptor = FetchDescriptor<T>()
        return try fetchCount(descriptor)
    }
}
