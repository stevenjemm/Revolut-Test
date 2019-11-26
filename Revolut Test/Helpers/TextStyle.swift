//
//  TextStyle.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 15/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

enum TextStyle {
    case title
    case body
    case detail
    
    static func getFont(for style: TextStyle) -> UIFont! {
        switch style {
        case .title:
            return  UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont(name: "Roboto-Medium", size: 20)!, maximumPointSize: 30)
        case .body:
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "Roboto-Regular", size: 18)!, maximumPointSize: 30)
        case .detail:
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont(name: "Roboto-Regular", size: 14)!, maximumPointSize: 30)
        }
    }
}
