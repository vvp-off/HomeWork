//
//  APIManager.swift
//  HomeWork
//
//  Created by VP on 15.10.2025.
//

import Foundation


enum ApiError: Error {
    case errorFetchingData
    case noDataAvailable
    case unableToDecodeData
    case invalidURL
}

final class APIManager {
    static let shared = APIManager()
    
    private let accessKey = "fijP4H6CNj5A_D-KxUwaeJAstoMQs8rRuxM1zTS5VSI"
    private let urlHost = "https://api.unsplash.com"
    
    func getImage(page: Int = 1, completion: @escaping (Result<[UnsplashModel], ApiError>) -> Void){
        var urlComponents = URLComponents(string: urlHost)
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let urlRequest = urlComponents?.url else {
            completion(Result.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: urlRequest)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else {
                completion(Result.failure(.errorFetchingData))
                return
            }
            
            guard let data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let result = try JSONDecoder().decode([UnsplashModel].self, from: data)
                completion(.success(result))
            }
            catch { completion(.failure(.unableToDecodeData))}
        }
        task.resume()
    }
}
