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
        
        populateMockData()
        FirebaseApp.configure()
        return true
    }

    private func populateMockData() {
        let realm = try! Realm()
        guard realm.isEmpty else { return }
        try! realm.write {
            realm.add(Task(name: "Хорошенько отдохнуть", descript: "Посмотреть Рик и Морти"))
            let task = Task(name: "Доделать тестовый проект", descript: "Крайний срок 23.01 до 15:00")
            task.isCompleted = true
            realm.add(task)
        }
    }
}
