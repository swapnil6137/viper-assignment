//
//  ProductPresenterTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import XCTest
@testable import CatalogPro

final class PresenterMockView: ProductViewProtocol {
    var displayedProducts: [[Product]] = []
    var showedLoading = false
    var hidLoading = false
    var showedNoData = false
    var showedErrorMessage: APIError?
    var allFetchedCalled = false

    func displayProducts(_ products: [Product]) {
        displayedProducts.append(products)
    }

    func allProductsFetched() {
        allFetchedCalled = true
    }

    func showLoading() { showedLoading = true }
    func hideLoading() { hidLoading = true }
    func showNoData() { showedNoData = true }
    func showError(error: APIError) { showedErrorMessage = error }
}

final class PresenterMockInteractor: ProductInteractorInputProtocol {
    weak var output: ProductInteractorOutputProtocol?

    var nextProductsToReturn: [Product] = []
    var nextPage: Int? = 1
    var totalPages: Int? = 2
    var shouldFail = false
    var failError = APIError.invalidURL

    func fetchProducts(page: Int) {
        if shouldFail {
            output?.didFailWithError(failError)
        } else {
            output?.didFetchProducts(nextProductsToReturn, nextPage: nextPage, totalPages: totalPages)
        }
    }
}

final class ProductPresenterTests: XCTestCase {
    var presenter: ProductPresenter!
    var view: PresenterMockView!
    var interactor: PresenterMockInteractor!

    override func setUp() {
        super.setUp()
        presenter = ProductPresenter()
        view = PresenterMockView()
        interactor = PresenterMockInteractor()

        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter // not used directly, but we’ll call presenter's methods.
    }

    func testViewDidLoadFetchesFirstPageShowsLoadingThenDisplays() {
        
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
            return
        }
        
        let product = try! JSONDecoder().decode(Product.self, from: productData)
        
        interactor.nextProductsToReturn = [product]

        presenter.viewDidLoad()

        XCTAssertTrue(view.showedLoading)
        XCTAssertTrue(view.hidLoading)
        XCTAssertEqual(view.displayedProducts.first?.first?.title, "Phone")
    }

    func testPaginationStopsAtTotalPages() {
        
        presenter.viewDidLoad()
        XCTAssertFalse(view.allFetchedCalled)
        
        presenter.currentPage = 1
        presenter.totalPages = 1
        
        // Now scrolling should trigger check and call allProductsFetched
        presenter.didScrollToBottom()
        XCTAssertTrue(view.allFetchedCalled)
    }

    func testEmptyFirstPageShowsNoData() {
        interactor.nextProductsToReturn = []
        interactor.nextPage = 1
        interactor.totalPages = 1

        presenter.viewDidLoad()

        XCTAssertTrue(view.showedNoData)
        XCTAssertTrue(view.hidLoading)
    }

    func testErrorShowsErrorAndHidesLoading() {
        interactor.shouldFail = true
        presenter.viewDidLoad()

        XCTAssertNotNil(view.showedErrorMessage)
        XCTAssertTrue(view.hidLoading)
    }
}
