//
//  LoadImage.swift
//  HomeWork
//
//  Created by VP on 05.02.2026.
//

import UIKit

class LoadImage {
    static let shared = LoadImage()
    
    func getImage(from string: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = string, let url = URL(string: urlString)
        else { return  }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let image = UIImage(data: data)
            else { return }
            CacheService.shared.setCache(forKey: urlString as AnyObject, image: image)
            completion(image)
        }
        task.resume()
    }
}
