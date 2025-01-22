//
//  TaskTableViewCell.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    //MARK: - properties
    static let identifier = String(describing: TaskTableViewCell.self)
    private var onToggleCompleted: ((Task) -> Void)?
    
    private var item: Task?
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var taskCompleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleCompleted), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupUI
    private func setupUI() {
        contentView.addSubview(taskLabel)
        contentView.addSubview(taskCompleteButton)

        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            taskLabel.trailingAnchor.constraint(equalTo: taskCompleteButton.leadingAnchor, constant: -8.0),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            taskCompleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            taskCompleteButton.widthAnchor.constraint(equalToConstant: 30.0),
            taskCompleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.topAnchor.constraint(equalTo: taskLabel.topAnchor, constant: -8.0),
            contentView.bottomAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 8.0)
        ])
    }
    //MARK: - actions
    @objc private func toggleCompleted() {
        guard let item = item else { fatalError("Missing task") }
        onToggleCompleted?(item)
    }
    
    func configureWith(_ item: Task, onToggleCompleted: ((Task) -> Void)? = nil) {
        self.item = item
        self.onToggleCompleted = onToggleCompleted
        taskLabel.attributedText = NSAttributedString(string: item.name,
                                                  attributes: item.isCompleted ? [.strikethroughStyle: true] : [:])
        taskCompleteButton.setTitle(item.isCompleted ? "✅" : "📌", for: .normal)
    }
}
