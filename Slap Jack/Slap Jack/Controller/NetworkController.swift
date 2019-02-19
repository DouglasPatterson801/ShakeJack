//
//  NetworkController.swift
//  Slap Jack
//
//  Created by Douglas Patterson on 1/17/19.
//  Copyright © 2019 Douglas Patterson. All rights reserved.
//

import Foundation

class NetworkController {
    
    static let networkController = NetworkController()
    
    static func performNetworkRequest(for url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            completion(data, error)
            
            print(data)
            
        }
        dataTask.resume()
    }
}


