//
//  SceneDelegate.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let rootController = AuthViewController()
        let navigationController = UINavigationController(rootViewController: rootController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

