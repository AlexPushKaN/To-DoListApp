//
//  TaskTableViewCell.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    //MARK: - сonstants
    private enum Constants {
        static let imageSize: CGFloat = 25.0
        static let buttonSize: CGFloat = 30.0
        static let padding: CGFloat = 16.0
        static let spacing: CGFloat = 8.0
    }

    //MARK: - properties
    static let identifier = String(describing: TaskTableViewCell.self)
    private var onToggleCompleted: ((Task) -> Void)?
    private var item: Task?
    
    private lazy var taskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
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
        contentView.addSubview(taskImageView)
        contentView.addSubview(taskLabel)
        contentView.addSubview(taskCompleteButton)

        NSLayoutConstraint.activate([
            taskImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            taskImageView.trailingAnchor.constraint(equalTo: taskLabel.leadingAnchor, constant: -Constants.spacing),
            taskImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            taskImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            taskImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            taskLabel.trailingAnchor.constraint(equalTo: taskCompleteButton.leadingAnchor, constant: -Constants.spacing),
            taskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            taskCompleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            taskCompleteButton.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            taskCompleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.topAnchor.constraint(equalTo: taskLabel.topAnchor, constant: -Constants.spacing),
            contentView.bottomAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: Constants.spacing)
        ])
    }
    
    //MARK: - actions
    @objc private func toggleCompleted() {
        guard let item = item else { fatalError("Missing task") }
        onToggleCompleted?(item)
    }
    
    //MARK: - methods
    override func prepareForReuse() {
        super.prepareForReuse()
        taskImageView.image = nil
    }
    
    func configureWith(_ item: Task, onToggleCompleted: ((Task) -> Void)? = nil) {
        self.item = item
        self.onToggleCompleted = onToggleCompleted
        taskLabel.attributedText = NSAttributedString(string: item.name,
                                                  attributes: item.isCompleted ? [.strikethroughStyle: true] : [:])
        taskCompleteButton.setTitle(item.isCompleted ? "✅" : "📌", for: .normal)
        if let image = item.imageData {
            self.taskImageView.image = UIImage(data: image)
        }
    }
}
