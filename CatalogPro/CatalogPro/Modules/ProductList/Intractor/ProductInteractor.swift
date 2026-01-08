//
//  ProductInteractor.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-26.
//
import Foundation

protocol ProductInteractorInputProtocol {
    func fetchProducts(page: Int)
}

protocol ProductInteractorOutputProtocol: AnyObject {
    func didFetchProducts(_ products: [Product], nextPage: Int?, totalPages: Int?)
    func didFailWithError(_ error: APIError)
}

class ProductInteractor: ProductInteractorInputProtocol {
    
    private let networkService: NetworkServiceProtocol
    weak var presenter: ProductInteractorOutputProtocol?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchProducts(page: Int) {
        
        guard NetworkMonitor.shared.isConnected else {
            self.presenter?.didFailWithError(APIError.noInternetConnection)
            return
        }
        
        var productsEndpoint = APIEndPoints.PRODUCTS

        productsEndpoint.queryParams = [EndPointParams.page.rawValue: "\(page)",
                                   EndPointParams.limit.rawValue: "10",
                                   EndPointParams.category.rawValue: "electronics"]
        
        networkService.request(endPoint: productsEndpoint, completion: {[weak self] (result: Result<ProductResponse, APIError>) in
            
            switch result {
            case .success(let response):
                let products = response.products ?? []
                self?.presenter?.didFetchProducts(products, nextPage: response.pagination?.page, totalPages: response.pagination?.total )
                
            case .failure(let error):
                self?.presenter?.didFailWithError(error)
            }
        })
    }
}
