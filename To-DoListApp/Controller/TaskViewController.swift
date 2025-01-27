//
//  TaskViewController.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit
import Photos

final class TaskViewController: UIViewController {
    // MARK: - properties
    lazy private var addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(attachImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var taskView: TaskView
    private var task: Task?
    private var isNewTask: Bool
    private var selectedImage: UIImage?
    weak var service: TaskServiceProtocol?

    init(task: Task?, taskView: TaskView) {
        self.taskView = taskView
        isNewTask = (task == nil)
        self.task = task ?? Task()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func loadView() {
        view = taskView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskView.descriptionStackView.addArrangedSubview(addImageButton)
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
    
    // MARK: - methods
    private func saveOrUpdateTask(name: String, description: String, date: Date) {
        guard let task else { return }
        do {
            let name = try name.validate()
            if isNewTask {
                if let newTask = Task.add(item: Task(
                    name: name,
                    descript: description,
                    date: date, 
                    imageData: selectedImage?.jpegData(compressionQuality: 0.5))
                ) {
                    service?.add(task: newTask)
                }
            } else {
                if let updateTask = task.update(
                    name: name,
                    descript: description,
                    date: date,
                    imageData: selectedImage?.jpegData(compressionQuality: 0.5)
                ) {
                    service?.update(task: updateTask)
                }
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
    
    // MARK: - actions
    @objc private func attachImage() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self else { return }
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    UIAlertController.showAlert(
                        on: self,
                        title: "Ошибка",
                        message: "Приложению не разрешен доступ к фотобиблиотеке, откройте доступ в настройках."
                    )
                }
            case .notDetermined, .limited:
                break
            @unknown default:
                break
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension TaskViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        addImageButton.setImage(UIImage(systemName: "rectangle.and.paperclip"), for: .normal)
        addImageButton.tintColor = .systemGreen
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
