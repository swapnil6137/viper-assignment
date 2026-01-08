//
//  ProductPresenter.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-26.
//
import UIKit

class ProductPresenter: ProductPresenterProtocol, ProductInteractorOutputProtocol {
    
    weak var view: ProductViewProtocol?
    var interactor: ProductInteractorInputProtocol?
    var router: ProductRouterProtocol?
    
    var currentPage = 0
    var totalPages = 0
    var isFetching = false
    
    func viewDidLoad() {
        fetchNextPage()
    }

    func didScrollToBottom() {
        if !isFetching {
            fetchNextPage()
        }
    }

    private func fetchNextPage() {
        
        if currentPage > 0 && currentPage >= totalPages {
            view?.allProductsFetched()
            return
        }
        
        isFetching = true
        view?.showLoading()
        interactor?.fetchProducts(page: currentPage + 1)
    }

    func didFetchProducts(_ products: [Product], nextPage: Int?, totalPages: Int?) {
        isFetching = false
        view?.hideLoading()
        
        if products.isEmpty && currentPage == 0 {
            view?.showNoData()
            return
        }
        
        if let nextPage = nextPage {
            currentPage = nextPage
        }
        
        if let lastPage = totalPages {
            self.totalPages = lastPage
        }
        
        view?.displayProducts(products)
    }

    func didFailWithError(_ error: APIError) {
        isFetching = false
        view?.hideLoading()
        view?.showError(error: error)
    }
    
    func didSelectProduct(_ product: Product) {
        
        guard let view = view else {
            assertionFailure("View is not set")
            return
        }
        
        router?.navigateToDetail(from: view, with: product)
    }
    
}
