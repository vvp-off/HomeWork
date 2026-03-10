//
//  SceneDelegate.swift
//  HomeWork
//
//  Created by VP on 14.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = HomeTableViewController()
        let navController = UINavigationController(rootViewController: vc)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }
}

