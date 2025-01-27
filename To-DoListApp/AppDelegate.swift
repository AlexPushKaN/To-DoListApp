//
//  AppDelegate.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit
import RealmSwift
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
