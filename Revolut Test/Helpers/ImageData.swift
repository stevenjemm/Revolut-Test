//
//  ImageAsset.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 15/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

enum ImageData: String {
    case add = "ic-addButton"
    case flagPlaceholder = "ic-flagPlaceholder"
    case us, uk, sweden, singapore, poland, norway, hungary, hk, eu, denmark, czech
    
    static func getImage(for asset: ImageData) -> UIImage! {
        return UIImage(named: asset.rawValue)
    }
    
    static func getText(for asset: ImageData) -> (title: String, description: String) {
        return (title: "Add currency pair", description: "Choose a currency pair to compare their live rates")
    }
    
    static func getDescription(for asset: ImageData) -> String {
        return "Choose a currency pair to compare their live rates"
    }
}
