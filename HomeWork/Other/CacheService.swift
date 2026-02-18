//
//  CacheService.swift
//  HomeWork
//
//  Created by VP on 05.02.2026.
//

import UIKit

class CacheService {
    static let shared = CacheService()
    let cache = NSCache<AnyObject, UIImage>()
    
    func setCache(forKey:AnyObject, image:UIImage) {
        cache.setObject(image, forKey: forKey)
    }
    
    func getObject(forKey: AnyObject) -> UIImage? {
        cache.object(forKey: forKey)
    }
    func cleanCache() {
        cache.removeAllObjects()
    }
    
}
