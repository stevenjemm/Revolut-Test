//
//  CurrencyListTableViewTests.swift
//  Revolut TestTests
//
//  Created by Steven Jemmott on 23/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import XCTest
@testable import Revolut_Test

class CurrencyListTableViewTests: XCTestCase {

    func testCurrencyDataExists() {
        
        let resourceName = "currencies"
        XCTAssert(resourceName == "currencies", "No file found with the name: \(resourceName)")
        guard let currenciesJSONURL = Bundle.main.path(forResource: resourceName, ofType: "json") else {
            return
        }
        XCTAssertNotNil(FileManager.default.fileExists(atPath: currenciesJSONURL))
        
    }
    
    func testLoadindCurrencies() {
        let currencyModel = CurrencyModel()
        XCTAssert(currencyModel.count == 32)
    }

    func testSelectingCurrency() {
        let currencyModel = CurrencyModel()
        
        if currencyModel.count > 0 {
            let currency = currencyModel.currency(at: 0)
            XCTAssert(currency.shortCode == "AUD")
        }
    }
}
