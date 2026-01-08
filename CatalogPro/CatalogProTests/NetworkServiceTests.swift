//
//  NetworkServiceTests.swift
//  CatalogProTests
//
//  Created by Tests on 2025-12-28.
//

import XCTest
@testable import CatalogPro

private struct DummyModel: Decodable, Equatable {
    let name: String
    let value: Int
}

final class NetworkServiceTests: XCTestCase {

    private var service: NetworkService!

    override func setUp() {
        super.setUp()
        service = NetworkService()
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubResponse = nil
    }

    override func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubResponse = nil
        service = nil
        super.tearDown()
    }

    private func makeEndpoint(path: String? = "test", method: HTTPMethod = .get, query: [String: String]? = nil, body: [String: String]? = nil, headers: [String: String]? = nil) -> APIEndPoint {
        var endPoint = APIEndPoint()
        endPoint.endPoint = path
        endPoint.method = method
        endPoint.queryParams = query
        endPoint.bodyParams = body
        endPoint.headers = headers
        return endPoint
    }

    func testRequestSuccessDecodesModel() {
        let json = """
        { "name": "ok", "value": 42 }
        """
        MockURLProtocol.stubResponseData = json.data(using: .utf8)

        // Need a URL for HTTPURLResponse
        let url = URL(string: "https://example.com/test")!
        MockURLProtocol.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        let exp = expectation(description: "success decode")
        let endpoint = makeEndpoint()

        service.request(endPoint: endpoint) { (result: Result<DummyModel, APIError>) in
            switch result {
            case .success(let model):
                XCTAssertEqual(model, DummyModel(name: "ok", value: 42))
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testRequestInvalidURL() {
        let exp = expectation(description: "invalid url")
        let endpoint = makeEndpoint(path: nil)

        service.request(endPoint: endpoint) { (result: Result<DummyModel, APIError>) in
            switch result {
            case .success:
                XCTFail("Expected failure for invalid URL")
            case .failure(let error):
                XCTAssertEqual(error, .invalidURL)
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testRequestInvalidStatusCode() {
        let url = URL(string: "https://example.com/test")!
        MockURLProtocol.stubResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)
        MockURLProtocol.stubResponseData = Data()

        let exp = expectation(description: "invalid status")
        let endpoint = makeEndpoint()

        service.request(endPoint: endpoint) { (result: Result<DummyModel, APIError>) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .invalidStatusCode)
            } else {
                XCTFail("Expected invalidStatusCode")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testRequestDecodingError() {
        // Malformed JSON for DummyModel
        let json = """
        { "unexpected": "fields" }
        """
        MockURLProtocol.stubResponseData = json.data(using: .utf8)

        let url = URL(string: "https://example.com/test")!
        MockURLProtocol.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        let exp = expectation(description: "decoding error")
        let endpoint = makeEndpoint()

        service.request(endPoint: endpoint) { (result: Result<DummyModel, APIError>) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, .decodingError)
            } else {
                XCTFail("Expected decodingError")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testRequestOtherError() {
        MockURLProtocol.stubError = NSError(domain: NSURLErrorDomain, code: -1009, userInfo: nil)

        let exp = expectation(description: "other error")
        let endpoint = makeEndpoint()

        service.request(endPoint: endpoint) { (result: Result<DummyModel, APIError>) in
            if case .failure(let error) = result {
                // We cannot directly compare .other(Error) reliably since Equatable compares description.
                XCTAssertEqual(error.description, APIError.other(NSError(domain: NSURLErrorDomain, code: -1009, userInfo: nil)).description)
            } else {
                XCTFail("Expected other(error)")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}
