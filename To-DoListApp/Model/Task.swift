//
//  Task.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import Foundation
import RealmSwift

final class Task: Object {
    enum Property: String {
        case id, text, isCompleted
    }
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var text = ""
    @objc dynamic var isCompleted = false
    
    override static func primaryKey() -> String? {
        return Task.Property.id.rawValue
    }
    
    convenience init(_ text: String) {
        self.init()
        self.text = text
    }
}

extension Task {
    static func all(in realm: Realm = try! Realm()) -> Results<Task> {
        return realm.objects(Task.self).sorted(byKeyPath: Task.Property.isCompleted.rawValue)
    }
    
    static func add(text: String, in realm: Realm = try! Realm()) -> Task {
        let item = Task(text)
        try! realm.write {
            realm.add(item)
        }
        return item
    }
    
    func toggleCompleted() {
        guard let realm = realm else { return }
        try! realm.write {
            isCompleted = !isCompleted
        }
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func update(text: String) {
        guard let realm = realm else { return }
        try! realm.write {
            self.text = text
        }
    }
}
