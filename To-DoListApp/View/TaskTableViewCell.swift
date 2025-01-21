//
//  TaskTableViewCell.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    static let identifier = String(describing: TaskTableViewCell.self)
    private var onToggleCompleted: ((Task) -> Void)?
    
    private var item: Task?
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
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
    
    private func setupUI() {
        contentView.addSubview(label)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8.0),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            button.widthAnchor.constraint(equalToConstant: 30.0),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.topAnchor.constraint(equalTo: label.topAnchor, constant: -8.0),
            contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0)
        ])
    }
    
    @objc private func toggleCompleted() {
        guard let item = item else { fatalError("Missing task") }
        onToggleCompleted?(item)
    }
    
    func configureWith(_ item: Task, onToggleCompleted: ((Task) -> Void)? = nil) {
        self.item = item
        self.onToggleCompleted = onToggleCompleted
        label.attributedText = NSAttributedString(string: item.text,
                                                  attributes: item.isCompleted ? [.strikethroughStyle: true] : [:])
        button.setTitle(item.isCompleted ? "✅" : "📌", for: .normal)
    }
}
