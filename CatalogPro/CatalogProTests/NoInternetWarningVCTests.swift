//
//  NoInternetWarningVCTests.swift
//  CatalogProTests
//
//  Created by Swapnil Vinayak Shinde on 2025-12-28.
//
//

import XCTest
@testable import CatalogPro

final class NoInternetWarningVCTests: XCTestCase {

    private final class DelegateMock: NoInternetWarningVCDelegate {
        var retryTappedCount = 0
        func noInternetWarningVCRetryTapped() {
            retryTappedCount += 1
        }
    }

    func makeVC() -> NoInternetWarningVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: NoInternetWarningVC.self))
        if let noInternetWarningVC = storyboard.instantiateViewController(withIdentifier: "NoInternetWarningVC") as? NoInternetWarningVC {
            noInternetWarningVC.loadViewIfNeeded()
            return noInternetWarningVC
        } else {
            let noInternetWarningVC = NoInternetWarningVC(nibName: nil, bundle: nil)
            noInternetWarningVC.loadViewIfNeeded()
            return noInternetWarningVC
        }
    }

    func testRetryButtonCallsDelegateAfterDismiss() {
        let noInternetWarningVC = makeVC()
        let delegate = DelegateMock()
        noInternetWarningVC.delegate = delegate

        let window = UIWindow(frame: UIScreen.main.bounds)
        let host = UIViewController()
        window.rootViewController = host
        window.makeKeyAndVisible()

        host.present(noInternetWarningVC, animated: false)

        noInternetWarningVC.btnRetryClicked(UIButton())

        let exp = expectation(description: "Dismiss completion")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(delegate.retryTappedCount, 1, "Delegate should be notified once after retry tap.")
    }

    func testDelegateIsWeaklyHeld() {
        let noInternetWarningVC = makeVC()

        var delegate: DelegateMock? = DelegateMock()
        weak var weakRef = delegate
        noInternetWarningVC.delegate = delegate

        delegate = nil
        XCTAssertNil(weakRef, "Delegate should not be strongly retained by the VC (weak).")
    }
}
