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
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var imageData: Data?
    
    override static func primaryKey() -> String? {
        return Task.Property.id.rawValue
    }
    
    convenience init(name: String, descript: String, date: Date? = nil, image: UIImage? = nil) {
        self.init()
        self.name = name
        self.descript = descript
        self.date = date
        self.imageData = image?.jpegData(compressionQuality: 0.5)
    }
}

//MARK: - methods Task-object and work with Realm
extension Task {
    static func all(in realm: Realm = try! Realm()) -> Results<Task> {
        return realm.objects(Task.self).sorted(byKeyPath: Task.Property.isCompleted.rawValue)
    }
    
    static func add(item: Task, in realm: Realm = try! Realm()) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Ошибка записи: \(error.localizedDescription)")
        }
    }
    
    func toggleCompleted() {
        guard let realm = realm else { return }
        do {
            try realm.write {
                isCompleted = !isCompleted
            }
        } catch {
            write(error: error)
        }
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
    
    func update(name: String, descript: String, date: Date?, image: UIImage?) {
        guard let realm = realm else { return }
        do {
            try realm.write {
                self.name = name
                self.descript = descript
                self.date = date
                self.imageData = image?.jpegData(compressionQuality: 0.5)
            }
        } catch {
            write(error: error)
        }
    }
    
    private func write(error: Error) {
        print("Ошибка записи: \(error.localizedDescription)")
    }
}
