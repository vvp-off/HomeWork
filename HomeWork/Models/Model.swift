//
//  Model.swift
//  HomeWork
//
//  Created by VP on 05.01.2026.
//

import Foundation

struct UnsplashModel: Decodable {
    let id: String
    let slug: String?
    let urls: Urls
    let alt_description: String?
    let blur_hash : String?
    let user: User
}

struct Urls: Decodable {
    let regular: String?
    let full: String?
    let small: String?
}

struct User: Decodable {
    let links: Links?
    let name: String?
}

struct Links: Decodable {
    let html: String?
}
