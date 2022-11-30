//
//  AppDelegate.swift
//  MarvelAssignment
//
//  Created by omaestra on 3/4/22.
//

import UIKit
import Hero

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigatorController = UINavigationController()
        navigatorController.hero.isEnabled = true
        let navigator = CharactersNavigator(navigationController: navigatorController)
        
        window?.rootViewController = navigatorController
        window?.makeKeyAndVisible()
        
        navigator.navigate(to: .charactersList)
        
        return true
    }
}

