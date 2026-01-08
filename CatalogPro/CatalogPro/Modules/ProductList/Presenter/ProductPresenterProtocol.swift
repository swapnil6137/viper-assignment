//
//  ProductPresenterProtocol.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

protocol ProductPresenterProtocol: AnyObject {
    var view: ProductViewProtocol? { get set }
    var interactor: ProductInteractorInputProtocol? { get set }
    var router: ProductRouterProtocol? { get set }
    
    func viewDidLoad()
    
    func didScrollToBottom()
    func didSelectProduct(_ product: Product)
}
