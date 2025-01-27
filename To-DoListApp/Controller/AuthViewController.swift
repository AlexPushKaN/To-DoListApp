//
//  AuthViewController.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 22.01.2025.
//

import UIKit
import FirebaseAuth

final class AuthViewController: UIViewController {
    typealias AuthorizationData = (mail: String, password: String)
    //MARK: - properties
    private let authView = AuthView()
    
    //MARK: - lifecycle
    override func loadView() {
        view = authView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        authView.registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
    
    //MARK: - actions
    @objc private func loginTapped() {
        guard let authData = checkingMailAndPassword() else { return }
        Auth.auth().signIn(withEmail: authData.mail, password: authData.password) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                UIAlertController.showAlert(on: self, title: "Ошибка входа", message: "\(error.localizedDescription)")
                return
            }
            goToTasksScreen()
            view.endEditing(true)
        }
    }
    
    @objc private func registerTapped() {
        guard let authData = checkingMailAndPassword() else { return }
        Auth.auth().createUser(withEmail: authData.mail, password: authData.password) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                UIAlertController.showAlert(on: self, title: "Ошибка регистрации", message: "\(error.localizedDescription)")
                return
            }
            goToTasksScreen()
            view.endEditing(true)
        }
    }
    
    private func checkingMailAndPassword() -> AuthorizationData? {
        guard let email = authView.emailTextField.text,
              let password = authView.passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty
        else {
            UIAlertController.showAlert(on: self, title: "Внимание", message: "Введите почту и пароль")
            return nil
        }
        
        guard email.isEmail() else {
            UIAlertController.showAlert(on: self, title: "Внимание", message: "Введенная почта некорректна")
            return nil
        }
        
        return (mail: email, password: password)
    }
    
    private func goToTasksScreen() {
        if let id = Auth.auth().currentUser?.uid {
            let service = FirebaseService(user: id)
            navigationController?.pushViewController(TasksListController(service: service), animated: true)
        }
    }
}
