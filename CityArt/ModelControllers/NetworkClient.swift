//
//  NetworkClient.swift
//  CityArt
//
//  Created by Colin Smith on 6/20/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

class NetworkClient {
    
    static let shared = NetworkClient()
    let baseURL = URL(string: "https://data.cityofchicago.org/resource/we8h-apcf.json")
    
    var murals: [Mural] = []
    
    func fetchMurals(completion: @escaping ([Mural]) -> Void){
        guard let url = baseURL else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(" \(error.localizedDescription) \(error) in function \(#function)")
                completion([])
                return
            }
            guard let data = data else {return}
            do{
                let murals = try JSONDecoder().decode([Mural].self, from: data)
                completion(murals)
            }catch{
                print(error)
            }
        }.resume()
    }
    
    
}
