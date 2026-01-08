//
//  ProductCell.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-26.
//

import UIKit
import SDWebImage

class ProductCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var imageTask: URLSessionDataTask?

    func configure(with product: Product) {
        titleLabel.text = product.title
        descriptionLabel.text = product.description
        categoryLabel.text = (product.category ?? "").capitalized
        priceLabel.text = "$\(product.price ?? 0)"
        
        productImageView.image = UIImage(named: "productPlaceholder")
        
        if let imageUrlString = product.image, let url = URL(string: imageUrlString) {
            productImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "productPlaceholder"),
                options: [.continueInBackground, .lowPriority],
                completed: nil
            )
        }
    }
}
