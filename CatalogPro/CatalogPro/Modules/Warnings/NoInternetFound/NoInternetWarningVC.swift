//
//  NoInternetWarningVC.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import UIKit

protocol NoInternetWarningVCDelegate: AnyObject {
    func noInternetWarningVCRetryTapped()
}

class NoInternetWarningVC: UIViewController {
    @IBOutlet weak var imgvInternetLost: UIImageView!
    weak var delegate: NoInternetWarningVCDelegate?
    
    @IBAction func btnRetryClicked(_ sender: UIButton) {
        self.dismiss(animated: true) {[weak self] in
            self?.delegate?.noInternetWarningVCRetryTapped()
        }
    }
    
}
