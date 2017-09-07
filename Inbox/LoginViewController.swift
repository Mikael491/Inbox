//
//  LoginViewController.swift
//  Inbox
//
//  Created by Mikael Teklehaimanot on 9/4/17.
//  Copyright © 2017 Mikael Teklehaimanot. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, Authenticatable {

    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var continueButton: UIButton?
    private var fields = [(UITextField, String)]()
    
    var remoteStore: RemoteStore?
    var rootViewController: UIViewController?
    var contactImporter: ContactImporter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        
        let loginLabel = UILabel()
        loginLabel.text = "Login"
        loginLabel.font = UIFont.systemFont(ofSize: 24)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        let continueButton = UIButton()
        self.continueButton = continueButton
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
        
        let signupButton = UIButton()
        signupButton.setTitle("don't have an account? Sign Up now!", for: .normal)
        signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        signupButton.setTitleColor(.black, for: .normal)
        signupButton.addTarget(self, action: #selector(LoginViewController.toSignUpVC(sender:)), for: .touchUpInside)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signupButton)
        
        let constraints = [
            loginLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
        continueButton?.isEnabled = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func pressedContinue(sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let rootVC = self.rootViewController else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("There was an error -> \(error)")
            } else {
                //Move to roor vc
                guard let user = user else { return }
                self.saveUserToDefaults()
                self.present(rootVC, animated: true, completion: nil)
            }
        })
    }
    
    func toSignUpVC(sender: UIButton) {
        let signUpVC = SignUpViewController()
        signUpVC.remoteStore = remoteStore
        signUpVC.rootViewController = rootViewController
        signUpVC.contactImporter = contactImporter
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
}
