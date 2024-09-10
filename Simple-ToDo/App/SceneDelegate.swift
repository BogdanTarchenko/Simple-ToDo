//
//  SceneDelegate.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 02.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let rootViewController: UIViewController = ToDoListViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window = .init(windowScene: scene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

