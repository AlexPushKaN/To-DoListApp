//
//  ViewControllerFactory.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 21.01.2025.
//

import UIKit

final class ViewControllerFactory {
    static func makeTaskViewController(task: Task? = nil) -> TaskViewController {
        let taskView = TaskView()
        let taskViewController = TaskViewController(task: task, taskView: taskView)
        return taskViewController
    }
}
