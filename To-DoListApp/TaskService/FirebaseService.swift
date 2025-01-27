//
//  TaskService.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 27.01.2025.
//

import Foundation
import RealmSwift
import FirebaseFirestore

protocol TaskServiceProtocol: AnyObject {
    var localTasksCollection: Results<Task> { get }
    func fetch(tasks completion: @escaping () -> Void)
    func toggle(task: Task)
    func delete(task: Task)
    func add(task: Task)
    func update(task: Task)
}

final class FirebaseService: TaskServiceProtocol {
    private let dataBase = Firestore.firestore()
    private let userID: String
    private lazy var remoteTasksCollection = {
        dataBase
            .collection("users")
            .document(userID)
            .collection("tasks")
    }()
    var localTasksCollection: Results<Task> {
        Task.all()
    }
    private let taskQueue = DispatchQueue(
        label: "com.To-DoListApp.taskQueue",
        qos: .utility
    )
    
    init(user id: String) {
        self.userID = id
    }
    
    func fetch(tasks completion: @escaping () -> Void) {
        taskQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.remoteTasksCollection.getDocuments { snapshot, error in
                if let error = error {
                    print("Ошибка загрузки задач: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("Нет данных для загрузки.")
                    return
                }
                
                self.syncLocalTasks(with: snapshot.documents)
                completion()
            }
        }
    }
    
    func toggle(task item: Task) {
        updateTask(item) { ["isCompleted": item.isCompleted] }
    }
    
    func delete(task item: Task) {
        let ID = item.id
        taskQueue.async { [weak self] in
            self?.remoteTasksCollection.document(ID).delete { error in
                if let error = error {
                    print("Ошибка удаления задачи: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func add(task item: Task) {
        let data = taskData(from: item)
        setTask(item, data: data)
    }
    
    func update(task item: Task) {
        let data = taskData(from: item)
        updateTask(item, with: data)
    }
    
    //MARK: - private methods
    private func taskData(from task: Task) -> [String: Any] {
        [
            "name": task.name,
            "description": task.descript,
            "date": task.date?.description ?? "",
            "isCompleted": task.isCompleted,
            "imageData": task.imageData?.base64EncodedString() ?? ""
        ]
    }
    
    private func setTask(_ task: Task, data: [String: Any]) {
        let ID = task.id
        taskQueue.async { [weak self] in
            self?.remoteTasksCollection.document(ID).setData(data) { error in
                if let error = error {
                    print("Ошибка добавления задачи: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateTask(_ task: Task, with data: [String: Any]) {
        let ID = task.id
        taskQueue.async { [weak self] in
            self?.remoteTasksCollection.document(ID).updateData(data) { error in
                if let error = error {
                    print("Ошибка обновления задачи: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateTask(_ task: Task, changes: @escaping () -> [String: Any]) {
        let ID = task.id
        let data = changes()
        taskQueue.async { [weak self] in
            self?.remoteTasksCollection.document(ID).updateData(data) { error in
                if let error = error {
                    print("Ошибка обновления задачи (ID \(ID)): \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func syncLocalTasks(with documents: [QueryDocumentSnapshot]) {
        let existingIDs = Set(localTasksCollection.map { $0.id })
        
        for document in documents {
            let data = document.data()
            guard
                let name = data["name"] as? String,
                let description = data["description"] as? String,
                let isCompleted = data["isCompleted"] as? Bool
            else {
                print("Пропущен документ с некорректными данными: \(document.documentID)")
                continue
            }
            
            let date: Date? = (data["date"] as? String)?.toType()
            let imageData: Data? = (data["imageData"] as? String)?.toType()
            
            if !existingIDs.contains(document.documentID) {
                let task = Task.add(item: Task(
                    id: document.documentID,
                    name: name,
                    descript: description,
                    date: date,
                    imageData: imageData
                ))
                if task?.isCompleted != isCompleted {
                    let _ = task?.toggleCompleted()
                }
            }
        }
    }
}
