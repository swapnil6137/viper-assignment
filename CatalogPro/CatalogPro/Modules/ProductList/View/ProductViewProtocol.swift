//
//  ProductViewProtocol.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

protocol ProductViewProtocol: AnyObject {
    func displayProducts(_ products: [Product])
    func allProductsFetched()
    
    func showLoading()
    func hideLoading()
    func showNoData()
    
    func showError(error: APIError)
}
