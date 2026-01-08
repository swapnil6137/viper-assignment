//
//  ProductDetailViewController.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-26.
//

import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let specsLabel = UILabel()
    private let ratingLabel = UILabel()
    
    var product: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureData()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 15
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [productImageView, titleLabel, categoryLabel, priceLabel, descriptionLabel, specsLabel, ratingLabel].forEach {
            contentView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            productImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
        ])
        
        productImageView.cornerRadius = 10
      
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        categoryLabel.font = .boldSystemFont(ofSize: 24)
        categoryLabel.numberOfLines = 0
        priceLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        priceLabel.textColor = .systemGreen
        descriptionLabel.numberOfLines = 0
        specsLabel.numberOfLines = 0
        specsLabel.font = .systemFont(ofSize: 16)
        specsLabel.textColor = .darkGray
    }
    
    private func configureData() {
        guard let product = product else {
            assertionFailure(MessageConstants.productNotFound)
            return }
        
        let titleLabelFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let valueLabelFont = UIFont.systemFont(ofSize: 22, weight: .regular)
        
        self.setAttributedText(titleLabel, TitleConstants.name + ": ", valueText: product.title ?? TitleConstants.unavailable, labelFont: titleLabelFont, valueFont: valueLabelFont)
        
        self.setAttributedText(categoryLabel, TitleConstants.category + ": ",
                               valueText: (product.category ?? TitleConstants.unavailable).capitalized,
                               labelFont: titleLabelFont, valueFont: valueLabelFont)
        
        self.setAttributedText(descriptionLabel, TitleConstants.description +  ": ",
                               valueText: product.description ?? TitleConstants.unavailable,
                               labelFont: titleLabelFont, valueFont: valueLabelFont)
        
        self.setAttributedText(priceLabel, TitleConstants.price + ": ",
                               valueText: "$\(product.price ?? 0.0)",
                               labelFont: titleLabelFont, valueFont: titleLabelFont)
       
        if let rating = product.rating {
            self.setAttributedText(ratingLabel, TitleConstants.rating + ": ",
                                   valueText: "\(rating.rate ?? 0.0) (\(rating.count ?? 0) \(TitleConstants.reviews))",
                                   labelFont: titleLabelFont, valueFont: valueLabelFont)
        }
        
        self.setSpecifications()
        
        if let imageUrl = product.image, let url = URL(string: imageUrl) {
            guard let placeHolderImage = UIImage.init(named: "productPlaceholder") else {
                assertionFailure("Placeholder Image is missing")
                return
            }
            
            productImageView.sd_setImage(with: url, placeholderImage: placeHolderImage )
        }
    }
    
    func setSpecifications() {
        
        if let specs = product?.specs {
            
            let specsAttributedText = NSMutableAttributedString()
            
            let titleLabelFont = UIFont.systemFont(ofSize: 24, weight: .bold)
            let subLabelFont = UIFont.systemFont(ofSize: 18, weight: .bold)
            let valueText = UIFont.systemFont(ofSize: 16, weight: .regular)
            
            specsAttributedText.appendWith(text: "\(TitleConstants.specifications):", font: titleLabelFont)
            
            specsAttributedText.appendWith(text: "\n\(TitleConstants.color): ", font: subLabelFont)
            specsAttributedText.appendWith(text: (specs.color ?? TitleConstants.unavailable).capitalized, font: valueText)
            
            specsAttributedText.appendWith(text: "\n\(TitleConstants.weight): ", font: subLabelFont)
            specsAttributedText.appendWith(text: specs.weight ?? TitleConstants.unavailable, font: valueText)
            
            specsAttributedText.appendWith(text: "\n\(TitleConstants.storageSize): ", font: subLabelFont)
            specsAttributedText.appendWith(text: specs.storage ?? TitleConstants.unavailable, font: valueText)
            
            specsLabel.attributedText = specsAttributedText
            
        }
    }
    
    func setAttributedText( _ label: UILabel, _ labelText: String, valueText: String, labelFont: UIFont, valueFont: UIFont) {
        
        let attributedText = NSMutableAttributedString()
    
        attributedText.appendWith(text: labelText, font: labelFont)
        attributedText.appendWith(text: valueText, font: valueFont)
        
        label.attributedText = attributedText
        
    }
}
