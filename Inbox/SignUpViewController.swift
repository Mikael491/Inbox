//
//  SignUpViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 12/14/16.
//  Copyright © 2016 Mikael Teklehaimanot. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let phoneNumberTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private var fields = [(UITextField, String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        label.text = "Sign Up!"
        label.font = UIFont.systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.black, for: .normal)
        continueButton.addTarget(self, action: #selector(SignUpViewController.pressedContinue(sender:)), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        phoneNumberTextField.keyboardType = .phonePad
        passwordTextField.isSecureTextEntry = true
        fields = [(phoneNumberTextField, "Phone Number"), (emailTextField, "Email"), (passwordTextField, "Password")]
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
            label.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        phoneNumberTextField.becomeFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fields.forEach{ $0.0.resignFirstResponder() }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pressedContinue(sender: AnyObject) {
        
    }

}
