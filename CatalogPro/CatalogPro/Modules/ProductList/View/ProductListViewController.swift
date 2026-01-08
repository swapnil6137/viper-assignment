//
//  ProductListViewController.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-26.
//
import UIKit
import Toast

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var presenter: ProductPresenterProtocol?
    var products: [Product] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataFoundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.className, for: indexPath) as! ProductCell
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
    
    // Pagination Logic: Detect scroll to bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight + 50 {
            loadMoreIfNeeded()
        }
    }

    private func loadMoreIfNeeded() {
        presenter?.didScrollToBottom()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectProduct(products[indexPath.row])
    }
    
    @IBAction func btnRetryClicked(_ sender: UIButton) {
        self.noDataFoundView.isHidden = true
        self.loadMoreIfNeeded()
    }
}

extension ProductListViewController {
    
    func makeTableFooterLoader() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = footerView.center
        activityIndicator.color = UIColor.init(hex: ColorConstants.appThemeColor)
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.tag = 999

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        return footerView
    }
    
}

extension ProductListViewController: ProductViewProtocol {
    func showLoading() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = self.makeTableFooterLoader()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
        }
    }
    
    func allProductsFetched() {
        DispatchQueue.main.async {
            if self.presentedViewController is NoInternetWarningVC {
                return
            }
            self.view.makeToast(MessageConstants.allRecodsFetched, duration: 1.0, position: .bottom)
        }
    }
    
    func displayProducts(_ products: [Product]) {
        
        guard !products.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {[weak self] in

            guard let weakSelf = self else { return}
            weakSelf.products.append(contentsOf: products)
            
            if weakSelf.products.isEmpty {
                weakSelf.showNoData()
            } else {
                weakSelf.noDataFoundView.isHidden = true
                weakSelf.tableView.reloadData()
            }
            
        }
    }
    
    func showError(error: APIError) {
        
        DispatchQueue.main.async {[weak self] in
            switch error {
            case .noInternetConnection:
                self?.showNoInternetWarning()
            default:
                self?.view.makeToast(error.description, duration: 1.0, position: .bottom)
            }
        }
    }
    
    func showNoInternetWarning() {
        DispatchQueue.main.async {[weak self] in
            
            let main = UIStoryboard(name: "Main", bundle: nil)
            guard let noInternetWarningVC: NoInternetWarningVC = main.instantiateViewController(withIdentifier: NoInternetWarningVC.className) as? NoInternetWarningVC else {
                return
            }
          
            noInternetWarningVC.delegate = self
            
            if self?.presentedViewController is NoInternetWarningVC {
                return
            }
            
            noInternetWarningVC.modalTransitionStyle = .crossDissolve
            noInternetWarningVC.modalPresentationStyle = .overCurrentContext
            self?.present(noInternetWarningVC, animated: true)
        }
    }
    
    func showNoData() {
        DispatchQueue.main.async {[weak self] in
            self?.noDataFoundView.isHidden = false
        }
    }
}

extension ProductListViewController: NoInternetWarningVCDelegate {
    func noInternetWarningVCRetryTapped() {
        self.presenter?.viewDidLoad()
    }
}
