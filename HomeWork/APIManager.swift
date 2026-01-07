//
//  APIManager.swift
//  HomeWork
//
//  Created by VP on 15.10.2025.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    
    let accessKey = "fijP4H6CNj5A_D-KxUwaeJAstoMQs8rRuxM1zTS5VSI"
    let urlHost = "https://api.unsplash.com"
    
    func getImage(completion: @escaping ([String]) -> Void){
        var urlComponents = URLComponents(string: urlHost)
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [URLQueryItem(name: "client_id", value: accessKey)]
        
        guard let urlRequest = urlComponents?.url else { return }
        
        let request = URLRequest(url: urlRequest)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let dataPrint = data else { return }
            
            do {
                let result = try JSONDecoder().decode([UnsplashModel].self, from: dataPrint)
                var images: [String] = []
                for model in result {
                    images.append(model.urls.full)
                }
                completion(images)
            } catch { print(error.localizedDescription) }
        }
        task.resume()
        print(urlRequest.absoluteString)
    }
}
