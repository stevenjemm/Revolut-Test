//
//  CurrencyNetwork.swift
//  Revolut Test
//
//  Created by Steven Jemmott on 15/10/2019.
//  Copyright © 2019 Revolut Test. All rights reserved.
//

import UIKit

struct CurrencyNetwork {
    static let shared = CurrencyNetwork()
    static let scheme = "https"
    static let host = "europe-west1-revolut-230009.cloudfunctions.net"
    static let path = "/revolut-ios"
    
    func fetchData<T: Decodable>(from urlString: String, completionHandler: @escaping (Result<T, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completionHandler(.failure(error!))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(objects))
                
            } catch {
                completionHandler(.failure(error))
            }
        }.resume()
    }

}
