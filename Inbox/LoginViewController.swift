//
//  LoginViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 9/4/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var fields = [(UITextField, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let loginLabel = UILabel()
        loginLabel.text = "Login"
        loginLabel.font = UIFont.systemFont(ofSize: 24)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        let continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.addTarget(self, action: #selector(LoginViewController.pressedContinue(sender:)), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        fields = [(emailTextField, "Email"), (passwordTextField, "Password")]
        fields.forEach {
            $0.0.placeholder = $0.1
        }
        
        let stackView = UIStackView(arrangedSubviews: fields.map{$0.0})
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let constraints = [
            loginLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        emailTextField.becomeFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func pressedContinue(sender: UIButton) {
        
    }
    
}
