//
//  TasksListController.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit
import RealmSwift

final class TasksListController: UITableViewController {
    //MARK: - properties
    private var items: Results<Task>?
    private var itemsToken: NotificationToken?
    private var service: TaskServiceProtocol
    
    init(service: TaskServiceProtocol) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список задач"
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = .systemRed
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem()
        backButton.tintColor = .systemRed
        navigationItem.backBarButtonItem = backButton
        
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        items = service.localTasksCollection
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemsToken = items?.observe({ [weak tableView] (changes) in
            guard let tableView = tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error:
                break
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        service.fetch { [weak self] in
            guard let self else { return }
            items = service.localTasksCollection
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
    }
    
    //MARK: - actions
    @objc private func addItem() {
        let taskViewController = ViewControllerFactory.makeTaskViewController(service: service)
        navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    func toggleItem(_ item: Task) {
        guard let updateTask = item.toggleCompleted() else { return }
        service.toggle(task: updateTask)
    }
    
    func deleteItem(_ item: Task) {
        service.delete(task: item)
        item.delete()
    }
}

//MARK: - tableViewDataSource
extension TasksListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell,
              let item = items?[indexPath.row] else { return TaskTableViewCell(frame: .zero) }
        cell.configureWith(item) { [weak self] item in
            self?.toggleItem(item)
        }
        return cell
    }
}

//MARK: - tableViewDelegate
extension TasksListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = items?[indexPath.row] else { return }
        let taskViewController = ViewControllerFactory.makeTaskViewController(task: item, service: service)
        navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let item = items?[indexPath.row], editingStyle == .delete else { return }
        deleteItem(item)
    }
}
