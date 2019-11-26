//
//  CurrencyModel.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 24/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import Foundation

struct CurrencyModel {
    
    // MARK: - Properties
    private var currencies = [Currency]()
    var currencyPairs = [CurrencyPair]()
    
    var count: Int {
        return currencies.count
    }
    
    // MARK: - Initialiser
    init(){
        var currencyData: Data
        
        if let path = Bundle.main.path(forResource: "currencies", ofType: "json") {
            let fileURL = URL(fileURLWithPath: path)
            
            currencyData = try! Data(contentsOf: fileURL)
            
            let decoder = JSONDecoder()
            currencies = try! decoder.decode([Currency].self, from: currencyData)
        }
    }
    
    
    // MARK: - Helper Methods
    func currency(at position: Int) -> Currency {
        return currencies[position]
    }
    
    func getAll() -> [Currency] {
        
        return currencies
    }
    
    func getCorrespondingCurrencies(for selectedCurrency: Currency, in currencyPairs: [CurrencyPair]) -> [Currency] {
        var selectedCurrencies = [Currency]()
        for currencyPair in currencyPairs {
            if currencyPair.from.shortCode == selectedCurrency.shortCode {
                selectedCurrencies.append(currencyPair.to)
            }
        }
        
        return selectedCurrencies
    }
}
