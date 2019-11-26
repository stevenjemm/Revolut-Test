//
//  Extension-ViewController.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 25/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Got it!", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(okButton)
        present(alertVC, animated: true, completion: nil)
    }
}
