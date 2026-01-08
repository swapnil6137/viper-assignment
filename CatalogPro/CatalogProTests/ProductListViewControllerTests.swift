//
//  ProductListViewControllerTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//
//

import XCTest
@testable import CatalogPro

private final class PresenterMock: ProductPresenterProtocol {
    var view: ProductViewProtocol?
    var interactor: ProductInteractorInputProtocol?
    var router: ProductRouterProtocol?

    private(set) var viewDidLoadCalled = 0
    private(set) var didScrollToBottomCalled = 0
    private(set) var selectedProduct: Product?

    func viewDidLoad() { viewDidLoadCalled += 1 }
    func didScrollToBottom() { didScrollToBottomCalled += 1 }
    func didSelectProduct(_ product: Product) { selectedProduct = product }
}

final class ProductListViewControllerTests: XCTestCase {

    func makeVC() -> ProductListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ProductListViewController.self))
        let productListViewController = storyboard.instantiateViewController(withIdentifier: ProductListViewController.className) as! ProductListViewController
        productListViewController.loadViewIfNeeded()
        return productListViewController
    }

    func testViewDidLoadCallsPresenter() {
        let productListVC = makeVC()
        let presenter = PresenterMock()
        productListVC.presenter = presenter

        productListVC.viewDidLoad()

        XCTAssertEqual(presenter.viewDidLoadCalled, 1)
    }

    func testShowAndHideLoadingSetsFooter() {
        let productListVC = makeVC()

        productListVC.showLoading()
        
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertNotNil(productListVC.tableView.tableFooterView)

        productListVC.hideLoading()
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        XCTAssertNil(productListVC.tableView.tableFooterView)
    }

    func testScrollTriggersPagination() {
        let productListVC = makeVC()
        let presenter = PresenterMock()
        productListVC.presenter = presenter

        // Simulate content tall enough to scroll
        productListVC.products = []
        productListVC.tableView.reloadData()
        productListVC.tableView.contentSize = CGSize(width: 320, height: 2000)
        productListVC.tableView.frame = CGRect(x: 0, y: 0, width: 320, height: 400)

        // Scroll near bottom beyond threshold
        productListVC.tableView.setContentOffset(CGPoint(x: 0, y: 1700), animated: false)
        productListVC.scrollViewDidScroll(productListVC.tableView)

        XCTAssertEqual(presenter.didScrollToBottomCalled, 2)
    }
    
    func getTestDummyProductData() -> Product? {
        
        let json = """
        {
            "id": 1,
            "title": "Item",
            "price": 10.0,
            "description": "Desc",
            "category": "electronics"
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

    func testDidSelectRowNotifiesPresenter() throws {
        let productListVC = makeVC()
        let presenter = PresenterMock()
        productListVC.presenter = presenter
        
        guard let product = getTestDummyProductData() else {
            return
        }

        productListVC.products = [product]
        productListVC.tableView.reloadData()

        let indexPath = IndexPath(row: 0, section: 0)
        productListVC.tableView(productListVC.tableView, didSelectRowAt: indexPath)

        XCTAssertEqual(presenter.selectedProduct?.title, "Item")
    }

    func testDisplayProductsAppendsAndReloads() throws {
        let productListVC = makeVC()

        guard let product = getTestDummyProductData() else {
            return
        }

        productListVC.displayProducts([product])
       
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))

        XCTAssertEqual(productListVC.products.count, 1)
        XCTAssertEqual(productListVC.tableView.numberOfRows(inSection: 0), 1)
    }

    func testShowErrorNoInternetPresentsWarningVC() {
        let productListVC = makeVC()
        let host = UIViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = host
        window.makeKeyAndVisible()

        host.present(productListVC, animated: false)

        productListVC.showError(error: .noInternetConnection)

        // Allow presentation
        let exp = expectation(description: "Presented")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { exp.fulfill() }
        wait(for: [exp], timeout: 1.0)

        XCTAssertTrue(productListVC.presentedViewController is NoInternetWarningVC)
    }

    func testBtnRetryHidesNoDataViewAndTriggersLoadMore() {
        let productListVC = makeVC()
        let presenter = PresenterMock()
        productListVC.presenter = presenter

        // Ensure noDataFoundView starts visible to test hiding
        productListVC.noDataFoundView.isHidden = false

        // Invoke the IBAction
        productListVC.btnRetryClicked(UIButton())

        // noDataFoundView should be hidden immediately
        XCTAssertTrue(productListVC.noDataFoundView.isHidden)

        // loadMoreIfNeeded should have been called once -> didScrollToBottom once
        XCTAssertEqual(presenter.didScrollToBottomCalled, 1)
    }
}
