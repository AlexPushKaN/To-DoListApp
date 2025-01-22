//
//  UIAlertController+Extensions.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 22.01.2025.
//

import UIKit

extension UIAlertController {
    static func showAlert(
        on viewController: UIViewController,
        title: String,
        message: String,
        buttonTitle: String = "OK",
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: handler)
        alertController.addAction(action)
        viewController.present(alertController, animated: true)
    }
}
