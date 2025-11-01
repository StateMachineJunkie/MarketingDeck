//
//  AddressLabelPDFRenderer.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/31/25.
//

import UIKit

class AddressLabelPDFRenderer {

    static func makePDF(for targets: [MarketingTarget]) -> Data {
        let pageSize = CGSize(width: 612, height: 792) // 8.5x11 inches at 72 DPI
        let labelSize = CGSize(width: 189, height: 72) // 2-5/8" x 1"
        let cols = 3
        let rows = 10
        let hSpacing: CGFloat = 12
        let vSpacing: CGFloat = 0
        let marginX: CGFloat = 18
        let marginY: CGFloat = 36

        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))

        let data = pdfRenderer.pdfData { context in
            var index = 0
            var page = 0

            while index < targets.count {
                context.beginPage()
                page += 1

                for row in 0..<rows {
                    for col in 0..<cols {
                        guard index < targets.count else { break }
                        let target = targets[index]

                        let x = marginX + CGFloat(col) * (labelSize.width + hSpacing)
                        let y = marginY + CGFloat(row) * (labelSize.height + vSpacing)
                        let rect = CGRect(origin: CGPoint(x: x, y: y), size: labelSize)

                        draw(target, in: rect)
                        index += 1
                    }
                }
            }
        }

        return data
    }

    private static func draw(_ target: MarketingTarget, in rect: CGRect) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        let font = UIFont.systemFont(ofSize: 10)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph
        ]

        let text = "\(target.name) or current resident\n\(target.address.streetAddress)\n\(target.address.city), \(target.address.state) \(target.address.zip)"
        let textRect = rect.insetBy(dx: 6, dy: 6)
        text.draw(in: textRect, withAttributes: attrs)
    }
}
