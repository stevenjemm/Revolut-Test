//
//  Extension-TableView.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 20/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

extension UITableView {
    func setupEmptyState(with view: UIView) {
        self.backgroundView = UIView()
        self.backgroundView?.addSubview(view)
        
        view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
