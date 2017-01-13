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
    
    var remoteStore : RemoteStore?
    var rootViewController : UIViewController?
    var contactImporter : ContactImporter?
    
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
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
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
    
    func pressedContinue(sender: UIButton) {
        print("hit continue....")
        sender.isEnabled = false
        guard let phonenumber = phoneNumberTextField.text , phonenumber.characters.count > 0 else {
            alertForError(error: "Phone number invalid")
            sender.isEnabled = true
            return
        }
        
        guard let email = emailTextField.text , email.characters.count > 0 else {
            alertForError(error: "Email invalid")
            sender.isEnabled = true
            return
        }
        
        guard let password = passwordTextField.text , password.characters.count > 6 else {
            alertForError(error: "Password length must be greater than 6")
            sender.isEnabled = true
            return
        }
        print("===========================================")
        print("phoneNumber: \(phonenumber), email: \(email), password: \(password)")
        print("===========================================")

        remoteStore?.signUp(phoneNumber: phonenumber, email: email, password: password, success: {
            print("hit success...")
            guard let rootVC = self.rootViewController, let importer = self.contactImporter, let remoteStore = self.remoteStore else {return}
            remoteStore.startSyncing()
            importer.fetchContacts()
            importer.listenForChanges()
            
            self.present(rootVC, animated: true, completion: nil)
            
        }, error: {
            error in
            print("hit error....")
            self.alertForError(error: error.description)
            sender.isEnabled = true
        })
    }
    
    func alertForError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}















