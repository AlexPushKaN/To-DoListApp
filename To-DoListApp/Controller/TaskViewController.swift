//
//  TaskViewController.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class TaskViewController: UIViewController {
    //MARK: - properties
    private var taskView: TaskView
    private var task: Task?
    private var isNewTask: Bool
    
    init(task: Task?, taskView: TaskView) {
        self.taskView = taskView
        isNewTask = task == nil ? true : false
        self.task = task == nil ? Task() : task
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func loadView() {
        view = taskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isNewTask ? "Новая задача" : "Редактировать задачу"
        taskView.setting(from: task)
        taskView.completion = { [weak self] taskData in
            self?.saveOrUpdateTask(
                name: taskData.name,
                description: taskData.description,
                date: taskData.date
            )
        }
    }
    
    //MARK: - actions
    private func saveOrUpdateTask(name: String, description: String, date: Date) {
        guard let task else { return }
        do {
            let name = try name.validate()
            if isNewTask {
                Task.add(item: Task(name: name, descript: description, date: date))
            } else {
                task.update(name: name, descript: description, date: date)
            }
            self.navigationController?.popViewController(animated: true)
        } catch let error as String.ValidationError {
            let alertTitle: String = "Внимание"
            var alertMessage: String!
            switch error {
            case .emptyInput:
                alertMessage = "Полe названия задачи не должно быть пустым"
            case .invalidFormat:
                alertMessage = "Поле названия задачи не должно содержать только цифры"
            }
            UIAlertController.showAlert(on: self, title: alertTitle, message: alertMessage)
        } catch {
            UIAlertController.showAlert(
                on: self,
                title: "Внимание, неизвестная ошибка",
                message: error.localizedDescription
            )
        }
    }
}
