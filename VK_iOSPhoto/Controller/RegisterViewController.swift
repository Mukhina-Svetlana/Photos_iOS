//
//  ViewController.swift
//  VK_iOSPhoto
//
//  Created by Светлана Мухина on 06.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    static var name: String = ""
    static var password: String = ""
    let defaults = UserDefaults.standard
    private lazy var textFieldLogin: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите логин"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .bezel
        tf.font = .systemFont(ofSize: 24)
        tf.textColor = .black
        tf.clearButtonMode = .whileEditing
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var textFieldPassword: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите пароль"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.borderStyle = .bezel
        tf.font = .systemFont(ofSize: 24)
        tf.textColor = .black
        tf.clearButtonMode = .whileEditing
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var didLogIn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Регистрация", for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .black
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var didEnter: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вход", for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .black
        button.layer.cornerRadius = 4
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapEnter), for: .touchUpInside)
        return button
    }()
   
    override func viewDidLoad() {
        navigationItem.backButtonTitle = ""
        super.viewDidLoad()
        configuration()
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let name = textFieldLogin.text, let password = textFieldPassword.text{
            if name != "" && password != "" {
                didEnter.isEnabled = true
                didLogIn.isEnabled = true
            }
        }
    }
}
extension ViewController {
    private func configuration() {
        view.backgroundColor = .secondarySystemGroupedBackground
        view.addSubview(textFieldLogin)
        view.addSubview(textFieldPassword)
        view.addSubview(didLogIn)
        view.addSubview(didEnter)
        
        NSLayoutConstraint.activate([
            textFieldLogin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            textFieldLogin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            textFieldLogin.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldLogin.bottomAnchor, constant: 20),
            textFieldPassword.leadingAnchor.constraint(equalTo: textFieldLogin.leadingAnchor),
            textFieldPassword.trailingAnchor.constraint(equalTo: textFieldLogin.trailingAnchor),
            
            didLogIn.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 80),
            didLogIn.leadingAnchor.constraint(equalTo: textFieldLogin.leadingAnchor),
            didLogIn.trailingAnchor.constraint(greaterThanOrEqualTo: didEnter.leadingAnchor, constant: -40),
            didLogIn.heightAnchor.constraint(equalToConstant: 40),
            
            didEnter.topAnchor.constraint(equalTo: didLogIn.topAnchor),
            didEnter.trailingAnchor.constraint(equalTo: textFieldLogin.trailingAnchor),
            didEnter.widthAnchor.constraint(equalTo: didLogIn.widthAnchor),
            didEnter.heightAnchor.constraint(equalTo: didLogIn.heightAnchor)
        ])
    }
    
    @objc
    private func didTapEnter(){
        for i in Base.shared.users {
            if textFieldLogin.text == i.name && textFieldPassword.text == i.password  {
                let mainViewController = UINavigationController(rootViewController: MainViewController())
              mainViewController.modalPresentationStyle = .fullScreen
              present(mainViewController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Пользователь с таким именем еще не зарегестрирован!", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc
    private func didTapLogIn() {
        guard let name = textFieldLogin.text, let password = textFieldPassword.text else {return}
        ViewController.name = name
        ViewController.password = password
        for i in Base.shared.users {
            if name == i.name && password == i.password  {
                let alert = UIAlertController(title: "Вы уже зарегестрированы! ", message: "", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default) { action in
                    let newViewController = UINavigationController(rootViewController: MainViewController())
                     newViewController.modalPresentationStyle = .fullScreen
                    self.present(newViewController, animated: true, completion: nil)
                }
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            } else if  name == i.name {
                let alert = UIAlertController(title: "Пользователь с таким именем уже существует!", message: "Измените имя!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
        let secondVC = ChooseImageViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
}

