//
//  TaskView.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class TaskView: UIView {
    //MARK: - сonstants
    private enum Constants {
        static let itemViewSize: CGFloat = 44.0
        static let stackViewSize: CGFloat = 32.0
        static let datePickeSize: CGFloat = 130.0
        static let textViewSize: CGFloat = 100.0
        static let padding: CGFloat = 16.0
        static let spacing: CGFloat = 8.0
    }

    //MARK: - properties
    private lazy var taskNameTextField: UITextField = {
        let indentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.padding, height: .zero)))
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Введите название задачи"
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.tintColor = .systemGray
        textField.textColor = .systemGray
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.returnKeyType = .next
        textField.layer.cornerRadius = 12.0
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        return textField
    }()
    
    lazy var descriptionStackView: UIStackView = {
        let label = UILabel()
        label.text = "Описание задачи и дата выполнения"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(label)
        return stackView
    }()
    
    private lazy var taskDescriptionTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.textColor = .systemGray
        textView.tintColor = .systemGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.returnKeyType = .next
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
        taskNameTextField.delegate = self
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
        addSubview(descriptionStackView)
        addSubview(taskDescriptionTextView)
        addSubview(taskDatePicker)
        addSubview(saveButton)

        taskNameTextField.translatesAutoresizingMaskIntoConstraints = false
        taskDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        taskDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            taskNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            taskNameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            taskNameTextField.heightAnchor.constraint(equalToConstant: Constants.itemViewSize),
            
            descriptionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            descriptionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            descriptionStackView.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: Constants.spacing),
            descriptionStackView.heightAnchor.constraint(equalToConstant: Constants.stackViewSize),
            
            taskDescriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            taskDescriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            taskDescriptionTextView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: Constants.spacing),
            taskDescriptionTextView.heightAnchor.constraint(equalToConstant: Constants.textViewSize),
            
            taskDatePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            taskDatePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            taskDatePicker.topAnchor.constraint(equalTo: taskDescriptionTextView.bottomAnchor, constant: Constants.spacing),
            taskDatePicker.heightAnchor.constraint(equalToConstant: Constants.datePickeSize),
            
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            saveButton.topAnchor.constraint(equalTo: taskDatePicker.bottomAnchor, constant: Constants.spacing),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.itemViewSize)
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

//MARK: - UITextFieldDelegate
extension TaskView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            taskDescriptionTextView.becomeFirstResponder()
        }
        return true
    }
}
