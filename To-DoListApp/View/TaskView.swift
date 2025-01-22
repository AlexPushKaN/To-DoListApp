//
//  TaskView.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class TaskView: UIView {
    //MARK: - properties
    private lazy var taskNameTextField: UITextField = {
        let indentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 16.0, height: .zero)))
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Введите название задачи"
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.tintColor = .systemGray
        textField.textColor = .systemGray
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.returnKeyType = .done
        textField.layer.cornerRadius = 12.0
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание задачи и дата выполнения"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var taskDescriptionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.textColor = .systemGray
        textView.tintColor = .systemGray
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.returnKeyType = .done
        textView.layer.cornerRadius = 12.0
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        return textView
    }()
    
    private lazy var taskDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = .distantFuture
        picker.preferredDatePickerStyle = .wheels
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .systemBackground
        picker.locale = Locale(identifier: "ru_RU")
        return picker
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12.0
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        return button
    }()
    
    typealias TaskData = (name: String, description: String, date: Date)
    var completion: ((TaskData) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupUI
    func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(taskNameTextField)
        addSubview(descriptionLabel)
        addSubview(taskDescriptionTextView)
        addSubview(taskDatePicker)
        addSubview(saveButton)

        taskNameTextField.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        taskDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            taskNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            taskNameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 110.0),
            taskNameTextField.heightAnchor.constraint(equalToConstant: 44.0),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            descriptionLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 8.0),
            
            taskDescriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            taskDescriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            taskDescriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0),
            taskDescriptionTextView.heightAnchor.constraint(equalToConstant: 100.0),
            
            taskDatePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            taskDatePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            taskDatePicker.topAnchor.constraint(equalTo: taskDescriptionTextView.bottomAnchor, constant: 8.0),
            taskDatePicker.heightAnchor.constraint(equalToConstant: 150.0),
            
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            saveButton.topAnchor.constraint(equalTo: taskDatePicker.bottomAnchor, constant: 8.0),
            saveButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    //MARK: - override metods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
    
    //MARK: - actions
    @objc private func saveTask() {
        let name = taskNameTextField.text ?? ""
        let description = taskDescriptionTextView.text ?? ""
        let date = taskDatePicker.date
        completion?((name: name, description: description, date: date))
    }
    
    //MARK: - methods
    func setting(from task: Task?) {
        guard let task else { return }
        taskNameTextField.text = task.name
        taskDescriptionTextView.text = task.descript
        if let safeDate = task.date, let date = Calendar.current.date(byAdding: .day, value: 0, to: safeDate) {
            taskDatePicker.date = date
        }
    }
}
