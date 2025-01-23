//
//  AuthView.swift
//  To-DoListApp
//
//  Created by Александр Муклинов on 22.01.2025.
//

import UIKit

final class AuthView: UIView {
    //MARK: - сonstants
    private enum Constants {
        static let padding: CGFloat = 16.0
    }

    //MARK: - properties
    lazy var emailTextField: UITextField = {
        let indentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.padding, height: .zero)))
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Почта"
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.tintColor = .systemGray
        textField.textColor = .systemGray
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.textContentType = .username
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let indentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.padding, height: .zero)))
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Пароль"
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.tintColor = .systemGray
        textField.textColor = .systemGray
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.returnKeyType = .done
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = UIColor.systemGray4
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupUI
    private func setupUI() {
        backgroundColor = .systemBackground
        
        let gorizontalStackView = UIStackView(arrangedSubviews: [
            registerButton,
            loginButton
        ])
        gorizontalStackView.distribution = .fillProportionally
        gorizontalStackView.axis = .horizontal
        gorizontalStackView.spacing = 8.0
        let verticalStackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            gorizontalStackView
        ])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 8.0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            verticalStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding)
        ])
    }
    
    //MARK: - override metods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension AuthView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            passwordTextField.becomeFirstResponder()
        } else if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}
