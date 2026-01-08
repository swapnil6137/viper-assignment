//
//  UIViewStylingTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import XCTest
import UIKit
@testable import CatalogPro

final class UIViewStylingTests: XCTestCase {

    func testSetCornerRadius() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.setCornerRadius(8)
        XCTAssertEqual(view.layer.cornerRadius, 8)
        XCTAssertTrue(view.layer.masksToBounds)
    }

    func testMakeCircular() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 70))
        view.makeCircular()
        XCTAssertEqual(view.layer.cornerRadius, 25)
        XCTAssertTrue(view.layer.masksToBounds)
    }

    func testSetCornerRadiusMaskedCorners() {
        let view = UIView()
        view.setCornerRadius(10, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        XCTAssertEqual(view.layer.cornerRadius, 10)
        XCTAssertTrue(view.layer.masksToBounds)
        XCTAssertEqual(view.layer.maskedCorners, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }

    func testBorderHelpers() {
        let view = UIView()
        view.setBorder(width: 2, color: .red)
        XCTAssertEqual(view.layer.borderWidth, 2)
        let borderColor = view.layer.borderColor
        XCTAssertNotNil(borderColor)
        
        if let borderColor = borderColor {
            XCTAssertEqual(UIColor(cgColor: borderColor), .red)
        }

        view.removeBorder()
        XCTAssertEqual(view.layer.borderWidth, 0)
        XCTAssertNil(view.layer.borderColor)
    }

    func testShadowHelpers() {
        let view = UIView()
        view.setShadow(color: .black, opacity: 0.3, radius: 6, offset: CGSize(width: 1, height: 2))
        XCTAssertEqual(view.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(view.layer.shadowOpacity, 0.3, accuracy: 0.0001)
        XCTAssertEqual(view.layer.shadowRadius, 6)
        XCTAssertEqual(view.layer.shadowOffset, CGSize(width: 1, height: 2))
        XCTAssertFalse(view.layer.masksToBounds)

        view.removeShadow()
        XCTAssertEqual(view.layer.shadowOpacity, 0)
        XCTAssertEqual(view.layer.shadowRadius, 0)
        XCTAssertEqual(view.layer.shadowOffset, .zero)
        XCTAssertNil(view.layer.shadowColor)
    }

    func testApplyCardStyle() {
        let view = UIView()
        view.applyCardStyle()
        XCTAssertEqual(view.layer.cornerRadius, 12)
        XCTAssertEqual(view.layer.shadowOpacity, 0.1, accuracy: 0.0001)
        XCTAssertEqual(view.layer.shadowRadius, 6)
        XCTAssertEqual(view.layer.shadowOffset, CGSize(width: 0, height: 2))
    }

    func testIBInspectables() {
        let view = UIView()
        view.cornerRadius = 5
        XCTAssertEqual(view.layer.cornerRadius, 5)
        XCTAssertTrue(view.layer.masksToBounds)

        view.borderWidth = 3
        XCTAssertEqual(view.layer.borderWidth, 3)

        view.borderColor = .blue
        
        let borderColor = view.layer.borderColor
        XCTAssertNotNil(borderColor)
        
        if let borderColor = borderColor {
            XCTAssertEqual(UIColor(cgColor: borderColor), .blue)
        }

        view.shadowRadius = 7
        XCTAssertEqual(view.layer.shadowRadius, 7)

        view.shadowOpacity = 0.4
        XCTAssertEqual(view.layer.shadowOpacity, 0.4, accuracy: 0.0001)

        view.shadowOffset = CGSize(width: 2, height: 3)
        XCTAssertEqual(view.layer.shadowOffset, CGSize(width: 2, height: 3))
        
        let shadowColor = view.shadowColor
        XCTAssertNotNil(shadowColor)

        view.shadowColor = .green
        XCTAssertEqual(view.layer.shadowColor, UIColor.green.cgColor)
    }
}
