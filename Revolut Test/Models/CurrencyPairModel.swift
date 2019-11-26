//
//  CurrencyPairModel.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 24/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import Foundation

struct CurrencyPairModel {
    
    // MARK: - Properties
    private var currencyPairs = [CurrencyPair]()
    private var currencyParams = [URLQueryItem]()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()
    
    var count: Int {
        return currencyPairs.count
    }
    
    var isEmpty: Bool {
        return currencyPairs.isEmpty
    }
    
    private var fileURL: URL
    
    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = CurrencyNetwork.scheme
        components.host = CurrencyNetwork.host
        components.path = CurrencyNetwork.path
        components.queryItems = []
        return components
    }()
    
    // MARK: - Initialiser
    init(testing: Bool = false) {
        let directory: FileManager.SearchPathDirectory = testing ? .documentDirectory : .applicationSupportDirectory
        let pathName = testing ? "Saved Currency Pairs - Test" : "Saved Currency Pairs"
        
        let currencyPairURL = URL(fileURLWithPath: pathName,
                                  relativeTo: FileManager.default.urls(for: directory,
                                                                       in: .userDomainMask)[0])
        try? FileManager.default.createDirectory(at: currencyPairURL, withIntermediateDirectories: true)
        
        fileURL = URL(fileURLWithPath: "currencyPairs",
                          relativeTo: currencyPairURL).appendingPathExtension("json")
        
        try? readFromDisk()
    }
    
    
    // MARK: - Helper Methods
    func currencyPair(at position: Int) -> CurrencyPair {
        return currencyPairs[position]
    }
    
    func getAllCurrencies() -> [CurrencyPair] {
        return currencyPairs
    }
    
    mutating func add(_ currencyPair: CurrencyPair) throws {
        currencyPairs.append(currencyPair)
        
        let param = URLQueryItem(name: "pairs", value: currencyPair.currencyPairKey)
        currencyParams.append(param)
        urlComponents.queryItems = currencyParams
        try save()
        
    }
    
    mutating func removeCurrency(at index: Int) throws {
        currencyPairs.remove(at: index)
        urlComponents.queryItems?.remove(at: index)
        try save()
    }
    
    mutating func save() throws {
        try writeToDisk(currencyPairs)
    }
    
    mutating func getUrlComponent() -> URLComponents {
        
        for currencyPair in currencyPairs {
            let param = URLQueryItem(name: "pairs", value: currencyPair.currencyPairKey)
            urlComponents.queryItems?.append(param)
        }
        
        return urlComponents
    }
    
    fileprivate mutating func writeToDisk<T: Encodable>(_ data: T) throws {
        let encodedData = try encoder.encode(data)
        try encodedData.write(to: fileURL, options: .atomic)
    }
    
    fileprivate mutating func readFromDisk() throws {
        let jsonData = try Data(contentsOf: fileURL)
        currencyPairs = try decoder.decode([CurrencyPair].self, from: jsonData)
    }
    
}
