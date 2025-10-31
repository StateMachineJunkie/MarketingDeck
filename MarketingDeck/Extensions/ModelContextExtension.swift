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
        let importContext = ModelContext(self.container)

        logger.debug("\(table)")

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
            let target = MarketingTarget(name: name, address: address)
            logger.debug("\(target)")
            importContext.insert(target)
        }

        // Check this import before committing to main.
        // TODO: Come up with some reasonable checks to make before committing this data.

        // Replace main context contents with import contents.
        try transaction {
            // Clear out old data in main context
            try self.delete(model: MarketingTarget.self)
            let importedMarketingTargets = try importContext.fetch(FetchDescriptor<MarketingTarget>())

            // Insert new data from import
            for target in importedMarketingTargets {
                let newMarketingTarget = MarketingTarget(name: target.name, address: target.address)
                self.insert(newMarketingTarget)
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
