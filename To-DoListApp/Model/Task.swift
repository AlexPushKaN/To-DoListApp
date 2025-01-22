//
//  Task.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import Foundation
import RealmSwift

final class Task: Object {
    //MARK: - properties
    enum Property: String {
        case id, name, descript, date, isCompleted
    }
    
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var descript: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var isCompleted = false
    
    override static func primaryKey() -> String? {
        return Task.Property.id.rawValue
    }
    
    convenience init(name: String, descript: String, date: Date?) {
        self.init()
        self.name = name
        self.descript = descript
        self.date = date
    }
}

//MARK: - methods Task-object and work with Realm
extension Task {
    static func all(in realm: Realm = try! Realm()) -> Results<Task> {
        return realm.objects(Task.self).sorted(byKeyPath: Task.Property.isCompleted.rawValue)
    }
    
    static func add(item: Task, in realm: Realm = try! Realm()) {
        try! realm.write {
            realm.add(item)
        }
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
    
    func update(name: String, descript: String, date: Date?) {
        guard let realm = realm else { return }
        try! realm.write {
            self.name = name
            self.descript = descript
            self.date = date
        }
    }
}
