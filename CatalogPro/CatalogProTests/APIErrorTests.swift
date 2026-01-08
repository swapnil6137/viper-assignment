//
//  APIErrorTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import XCTest
@testable import CatalogPro

final class APIErrorTests: XCTestCase {

    func testInvalidURLDescription() {
        let error = APIError.invalidURL
        XCTAssertEqual(error.description, "Invalid URL")
    }

    func testDecodingErrorDescription() {
        let error = APIError.decodingError
        XCTAssertEqual(error.description, "Decoding Error")
    }

    func testNoInternetConnectionDescription() {
        let error = APIError.noInternetConnection
        XCTAssertEqual(error.description, "No Internet Connection")
    }

    func testFailedWithStatusCodeDescription() {
        let code = 404
        let error = APIError.failedWithStatusCode(code)
        XCTAssertEqual(error.description, "Failed with status code: \(code)")
    }

    func testInvalidStatusCodeDescription() {
        let error = APIError.invalidStatusCode
        XCTAssertEqual(error.description, "Failed with invalid status code.")
    }

    func testDataIsNilDescription() {
        let error = APIError.dataIsNil
        XCTAssertEqual(error.description, "Nil data received from API.")
    }
    
    func testUnAuthorizedDomain() {
        let error = APIError.unAuthorizedDomain
        XCTAssertEqual(error.description, "Unauthorized Domain.")
    }
    
    func testInvalidResponse() {
        let error = APIError.invalidResponse
        XCTAssertEqual(error.description, "Invalid Response.")
    }
    
    func testOtherErrorUsesWrappedLocalizedDescription() {
        struct DummyError: LocalizedError {
            var errorDescription: String? { "Something went wrong" }
        }
        let wrapped = DummyError()
        let error = APIError.other(wrapped)
        XCTAssertEqual(error.description, "Something went wrong")
    }

    func testOtherErrorFallsBackToDefaultLocalizedDescription() {
        enum PlainError: Error { case boom }
        let wrapped = PlainError.boom
        let expected = (wrapped as NSError).localizedDescription
        let error = APIError.other(wrapped)
        XCTAssertEqual(error.description, expected)
    }
}
