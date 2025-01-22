//
//  AppDelegate.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        initializeRealm()
        return true
    }

    private func initializeRealm() {
        let realm = try! Realm()
        guard realm.isEmpty else { return }
        try! realm.write {
            realm.add(Task(name: "Купить колбасу", descript: "В пятерочке", date: Date()))
            realm.add(Task(name: "Доделать тестовый проект", descript: "Крайний срок 23.01 до 15:00", date: Date()))
        }
    }
}
