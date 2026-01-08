//
//  ProductInteractorTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import XCTest
@testable import CatalogPro

// MARK: - Mock Network Service

private final class MockNetworkService: NetworkServiceProtocol {
    var nextResult: Result<ProductResponse, APIError> = .failure(.invalidURL)
    func request<T>(endPoint: APIEndPoint, completion: @escaping (Result<T, APIError>) -> Void) where T: Decodable {
        switch nextResult {
        case .success(let response):
            if let typed = response as? T {
                completion(.success(typed))
            } else {
                completion(.failure(.decodingError))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

// MARK: - Testable Interactor that skips reachability only

private final class TestableProductInteractor: ProductInteractor {
    override func fetchProducts(page: Int) {
        // Bypass NetworkMonitor for tests
        var productsEndpoint = APIEndPoints.PRODUCTS
        productsEndpoint.queryParams = [EndPointParams.page.rawValue: "\(page)",
                                   EndPointParams.limit.rawValue: "10",
                                   EndPointParams.category.rawValue: "electronics"]
        
        super.fetchProducts(page: page)
    }
}

// MARK: - Mock Presenter

final class InteractorMockPresenter: ProductInteractorOutputProtocol {
    var receivedProducts: [Product] = []
    var receivedNextPage: Int?
    var receivedTotalPages: Int?
    var receivedError: APIError?

    var onDidFetch: (() -> Void)?
    var onDidFail: (() -> Void)?

    func didFetchProducts(_ products: [Product], nextPage: Int?, totalPages: Int?) {
        receivedProducts = products
        receivedNextPage = nextPage
        receivedTotalPages = totalPages
        onDidFetch?()
    }

    func didFailWithError(_ error: APIError) {
        receivedError = error
        onDidFail?()
    }
}

// MARK: - Tests

final class ProductInteractorTests: XCTestCase {
    private var interactor: ProductInteractor!
    var presenter: InteractorMockPresenter!
    private var mockService: MockNetworkService!

    override func setUp() {
        super.setUp()
        presenter = InteractorMockPresenter()
        mockService = MockNetworkService()
        interactor = ProductInteractor(networkService: mockService)
        interactor.presenter = presenter
    }

    override func tearDown() {
        interactor = nil
        presenter = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchProductsSuccess() throws {
        let responseJson = """
        {
          "data": [
            { "id": 1, "title": "Laptop", "description": "Fast", "category": "electronics", "price": 999.99 }
          ],
          "pagination": { "page": 1, "limit": 10, "total": 1 }
        }
        """
        let responseData = try XCTUnwrap(responseJson.data(using: .utf8))
        let response = try JSONDecoder().decode(ProductResponse.self, from: responseData)
        mockService.nextResult = .success(response)

        let exp = expectation(description: "Fetch success")
        presenter.onDidFetch = { exp.fulfill() }

        interactor.fetchProducts(page: 0)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(presenter.receivedProducts.count, 1)
        XCTAssertEqual(presenter.receivedProducts.first?.title, "Laptop")
        XCTAssertEqual(presenter.receivedNextPage, 1)
        XCTAssertEqual(presenter.receivedTotalPages, 1)
    }

    func testFetchProductsNetworkError() {
        mockService.nextResult = .failure(.other(NSError(domain: NSURLErrorDomain, code: -1009)))

        let exp = expectation(description: "Fetch error")
        presenter.onDidFail = { exp.fulfill() }

        interactor.fetchProducts(page: 0)

        waitForExpectations(timeout: 1.0)
        XCTAssertNotNil(presenter.receivedError)
    }

    func testFetchProductsInvalidStatusCode() {
        mockService.nextResult = .failure(.invalidStatusCode)

        let exp = expectation(description: "Invalid status")
        presenter.onDidFail = { exp.fulfill() }

        interactor.fetchProducts(page: 0)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(presenter.receivedError, .invalidStatusCode)
    }
    
    func testFetchProductsInvalidURL() {
        mockService.nextResult = .failure(.invalidURL)

        let exp = expectation(description: "Invalid URL")
        presenter.onDidFail = { exp.fulfill() }

        interactor.fetchProducts(page: 0)

        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(presenter.receivedError, .invalidURL)
    }
}
