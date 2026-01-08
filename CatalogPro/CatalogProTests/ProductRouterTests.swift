//
//  ProductRouterTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import XCTest
@testable import CatalogPro

final class ProductRouterTests: XCTestCase {

    func testCreateModuleWiresViper() {
        let productListVC = ProductRouter.createModule()
        XCTAssertTrue(productListVC is ProductListViewController)

        let listVC = productListVC as! ProductListViewController
        let presenter = listVC.presenter as? ProductPresenter

        XCTAssertNotNil(presenter)
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertNotNil(presenter?.router)
        XCTAssertTrue(presenter?.view === listVC)
    }

}
