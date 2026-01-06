//
//  Model.swift
//  HomeWork
//
//  Created by VP on 05.01.2026.
//

import Foundation

struct UnsplashModel: Decodable {
    let id: String
    let slug: String
    let urls: Urls
}

struct Urls: Decodable {
    let regular: String
    let full: String
}
