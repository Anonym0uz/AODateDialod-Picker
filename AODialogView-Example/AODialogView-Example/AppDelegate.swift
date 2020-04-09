//
//  AppDelegate.swift
//  DialogAlert
//
//  Created by Alexander Orlov on 30/01/2020.
//  Copyright © 2020 Alexander Orlov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.rootViewController = ViewController()
        return true
    }
}

