//
//  ViewControllerFactory.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class ViewControllerFactory {
    static func makeTaskViewController(task: Task? = nil) -> TaskViewController {
        let taskViewController = TaskViewController()
        taskViewController.task = task
        taskViewController.modalPresentationStyle = .automatic
        taskViewController.modalTransitionStyle = .flipHorizontal
        return taskViewController
    }
}
