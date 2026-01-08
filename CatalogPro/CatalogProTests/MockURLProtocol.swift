//
//  MockURLProtocol.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var stubError: Error?
    static var stubResponse: URLResponse?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = MockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        if let response = MockURLProtocol.stubResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = MockURLProtocol.stubResponseData {
            client?.urlProtocol(self, didLoad: data)
        } else if MockURLProtocol.stubResponse != nil {
            // Explicitly send no data when response is present but data is nil
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
