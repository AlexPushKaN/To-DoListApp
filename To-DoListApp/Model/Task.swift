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
        case id, name, descript, date, isCompleted, imageData
    }
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var descript: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var imageData: Data?
    
    override static func primaryKey() -> String? {
        return Task.Property.id.rawValue
    }
    
    convenience init(
        id: String = UUID().uuidString,
        name: String,
        descript: String,
        date: Date? = nil,
        imageData: Data? = nil
    ) {
        self.init()
        self.id = id
        self.name = name
        self.descript = descript
        self.date = date
        self.imageData = imageData
    }
}

//MARK: - methods Task-object and work with Realm
extension Task {
    static func all(in realm: Realm = try! Realm()) -> Results<Task> {
        return realm.objects(Task.self).sorted(byKeyPath: Task.Property.isCompleted.rawValue)
    }
    
    static func add(item: Task, in realm: Realm = try! Realm()) -> Task? {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Ошибка записи: \(error.localizedDescription)")
        }
        return item
    }
    
    func toggleCompleted() -> Task?{
        guard let realm = realm else { return nil }
        do {
            try realm.write {
                isCompleted = !isCompleted
            }
        } catch {
            write(error: error)
        }
        return self
    }
    
    func delete() {
        guard let realm = realm else { return }
        do {
            try realm.write {
                realm.delete(self)
            }
        } catch {
            write(error: error)
        }
    }
    
    func update(name: String, descript: String, date: Date?, imageData: Data?) -> Task? {
        guard let realm = realm else { return nil }
        do {
            try realm.write {
                self.name = name
                self.descript = descript
                self.date = date
                self.imageData = imageData
            }
        } catch {
            write(error: error)
        }
        return self
    }
    
    private func write(error: Error) {
        print("Ошибка записи: \(error.localizedDescription)")
    }
}
