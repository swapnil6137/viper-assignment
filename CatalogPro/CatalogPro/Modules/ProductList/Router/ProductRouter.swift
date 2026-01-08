//
//  ProductRouter.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-26.
//

import UIKit

protocol ProductRouterProtocol {
    static func createModule() -> UIViewController
    func navigateToDetail(from view: ProductViewProtocol, with product: Product)
}

class ProductRouter: ProductRouterProtocol {
    static func createModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: ProductListViewController.className) as! ProductListViewController
        
        let presenter = ProductPresenter()
        let interactor = ProductInteractor()
        let router = ProductRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToDetail(from view: ProductViewProtocol, with product: Product) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: ProductDetailViewController.className) as? ProductDetailViewController

        detailVC?.product = product
        
        if let sourceView = view as? UIViewController, let detailVC = detailVC {
            sourceView.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
