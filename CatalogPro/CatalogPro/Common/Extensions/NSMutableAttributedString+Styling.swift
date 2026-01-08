//
//  NSMutableAttributedString+Styling.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import UIKit

extension NSMutableAttributedString {
    func appendWith(text: String, font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        self.append(attributedString)
    }
}
