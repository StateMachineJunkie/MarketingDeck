//
//  LoggerExtension.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 6/20/25.
//

import Foundation
import os.log

extension Logger {
    static func logger<T>(for type: T.Type) -> Logger {

        if let aClass = T.self as? AnyClass {
            return Logger(subsystem: Bundle.loggerID, category: String(describing: aClass))
        } else {
            return Logger(subsystem: "com.cdellc.MarketingDeck", category: String(describing: T.self))
        }
    }

    init(subsystem: String = Bundle.loggerID, function: String = #function, line: Int = #line, _ context: String) {
        let category = "\(line):\(function):\(context)"
        self.init(subsystem: subsystem, category: category)
    }
}
