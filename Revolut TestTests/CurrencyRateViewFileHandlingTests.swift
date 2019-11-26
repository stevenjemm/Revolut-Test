//
//  CurrencyRateTableViewControllerTests.swift
//  Revolut TestTests
//
//  Created by Steven Jemmott on 23/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import XCTest
@testable import Revolut_Test
class CurrencyRateViewFileHandlingTests: XCTestCase {

    let currency = Currency(imageName: nil, name: "Canadian Dollar", shortCode: "CAD")
    let currency2 = Currency(imageName: nil, name: "US Dollar", shortCode: "USD")
    let currency3 = Currency(imageName: nil, name: "Euro", shortCode: "EUR")
    var jsonData = [[String : Currency]]()
    var encodedData: Data!
    
    var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = CurrencyNetwork.scheme
        components.host = CurrencyNetwork.host
        components.path = CurrencyNetwork.path
        components.queryItems = []
        return components
    }()
    
    var currencyPairURL: URL!
    var fileURL: URL!
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    
    override func setUp() {
    }
    
    override class func tearDown() {
        
    }
    
    // MARK: - Test Decoding Data
    func testDecodingJSONData() throws {
        let message = ["message" : "Please hire me, code coverage is difficult."]
        let encodedMessage = try! encoder.encode(message)
        
        let decodedMessage = try! decoder.decode([String : String].self, from: encodedMessage)
        
        XCTAssertEqual(decodedMessage, ["message" : "Please hire me, code coverage is difficult."])
    }
    
//     MARK: - Test Encoding Data
    func testEncodingJSONData() throws {
        let currencyPair = CurrencyPair(from: currency, to: currency2)
        
        XCTAssertNoThrow( try encoder.encode(currencyPair))
    }
    

    
    func testAddingCurrencyPair() {
        var currencyPairModel = CurrencyPairModel(testing: true)
        let currencyPairCount = currencyPairModel.count
        
        let currencyPair = CurrencyPair(from: currency, to: currency2)
        let _ = currencyPairModel.add(currencyPair)
        
        XCTAssertEqual(currencyPairModel.count, currencyPairCount + 1)
    }
    
    func testRemovingCurrencyPair() {
        var currencyPairModel = CurrencyPairModel(testing: true)
        
        let currencyPair = CurrencyPair(from: currency, to: currency2)
        currencyPairModel.add(currencyPair)
        
        let currencyPair2 = CurrencyPair(from: currency2, to: currency3)
        currencyPairModel.add(currencyPair2)
        let currentCount = currencyPairModel.count
        
        currencyPairModel.removeCurrency(at: 0)
        
        XCTAssertEqual(currencyPairModel.count, currentCount - 1)
        
    }
    
    func testGettingCurrencyRateKey() {
        var currencyPairModel = CurrencyPairModel(testing: true)
        let currencyPair = CurrencyPair(from: currency, to: currency2)
        
        currencyPairModel.add(currencyPair)
        
        XCTAssertEqual("CADUSD", currencyPair.currencyPairKey)
    }
    
    func testAddingCurrenyPairRate() {
        var currencyPair = CurrencyPair(from: currency, to: currency2)
        let rate = [ currencyPair.currencyPairKey : 0.6789]
        
        currencyPair.addRate(rate)
        
        XCTAssertEqual(currencyPair.getRate(), 0.6789)
    }
    
    func testGetAlreadySelectedCurrencies() {
        var currencyPairArray = [CurrencyPair]()
        
        let currencyPair = CurrencyPair(from: currency, to: currency2)
        currencyPairArray.append(currencyPair)
        
        let currencyPair2 = CurrencyPair(from: currency2, to: currency3)
        currencyPairArray.append(currencyPair2)
        
        let currencyPair3 = CurrencyPair(from: currency, to: currency3)
        currencyPairArray.append(currencyPair3)
        
        var alreadySelectedCurrencies = [String]()
        let selectedCurrencyShortCode = "CAD"
        
        for currencyPair in currencyPairArray {
            if currencyPair.from.shortCode == selectedCurrencyShortCode {
                alreadySelectedCurrencies.append(currencyPair.to.shortCode)
            }
        }
        
        XCTAssertEqual(alreadySelectedCurrencies, ["USD", "EUR"])
    }
    
}
