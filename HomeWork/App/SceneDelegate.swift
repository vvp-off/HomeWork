//
//  SceneDelegate.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var models: [UnsplashModel] = []

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        updata()
        var count = 1
        while models.isEmpty {
                print("попытка № \(count)")
                count += 1
        }
        guard !models.isEmpty else {
            print("pusto blyat")
            return
        }
        let vc = TableViewController(unsplashModels: models)
        window.rootViewController = vc
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func updata() {
        APIManager.shared.getImage { [weak self] modelsUnspl   in
                 guard let self else { return }
                 self.models = modelsUnspl
         }
     }
 }

