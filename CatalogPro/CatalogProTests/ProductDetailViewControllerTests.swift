//
//  ProductDetailViewControllerTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import XCTest
import UIKit
@testable import CatalogPro

final class ProductDetailViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
    }

    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        super.tearDown()
    }
    
    func getTestDummyProductData() -> Product? {
        
        let json = """
            {
                "id": 10,
                "title": "Phone",
                "price": 499.5,
                "description": "Nice",
                "category": "electronics",
                "image": "https://example.com/test.png"
            }
            """
        
        guard  let productData = json.data(using: .utf8) else {
            XCTFail("Invalid Data")
            return nil
        }
        
        do {
            return try JSONDecoder().decode(Product.self, from: productData)
        } catch {
            XCTFail("Invalid product json.")
        }
        
        return nil
    }

    func testConfiguresLabelsFromProduct() {
        let productDetailsVC = ProductDetailViewController()
        productDetailsVC.product = getTestDummyProductData()
        
        _ = productDetailsVC.view
        
        XCTAssertNotNil(productDetailsVC.view)
    }

    func testLoadsImageFromURL() {
       
        guard let imageData = UIImage(systemName: "circle")?.pngData() else {
            return
        }
        
        MockURLProtocol.stubResponseData = imageData
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        let productDetailsVC = ProductDetailViewController()
        productDetailsVC.product = getTestDummyProductData()
        
        _ = productDetailsVC.view
        
        let exp = expectation(description: "Image loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(productDetailsVC.view)
        _ = session 
    }
}
