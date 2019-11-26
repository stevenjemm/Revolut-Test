//
//  CurrencyPair.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 24/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import Foundation

struct CurrencyPair: Codable {
    
    // MARK: - Properties
    var from: Currency
    var to: Currency
    
    private var rate = [String : Double]()
    var currencyPairKey: String = ""
    
    // MARK: - Initialiser
    init(from currency1: Currency, to currency2: Currency){
        from = currency1
        to = currency2
        
        currencyPairKey = from.shortCode + to.shortCode
    }
    
    // MARK: - Helper Methods
    mutating func getRate() -> Double {
  
        return rate[currencyPairKey] ?? 0
    }
    
    mutating func addRate(_ newRate: [String : Double]) {
        rate = newRate
    }
    
}
