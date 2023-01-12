//
//  SeneDelegate.swift
//  My Reform
//
//  Created by 곽민섭 on 2023/01/12.
//

import UIKit

class SeneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        let rootViewController = CategoryCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
