//
//  LoginViewController.swift
//  IOS Social Network
//
//  Created by  SENAT on 31/07/2019.
//  Copyright © 2019 <ASi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLabel(label: label)
        configTextField(textFields: [emailTextField, passwordTextField])
        
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        let email = emailTextField.text
        let password = passwordTextField.text
        if email!.contains("@") && !password!.isEmpty {
            performSegue(withIdentifier: "segueOnMain", sender: nil)
            Service.shared.login(email: email!, password: password!)
        } else {
            errorAlertController()
        }
    }
    
    fileprivate func errorAlertController() {
        let massage = "The credentials you entered are not associated with an account. Please check your email and/or password and try again."
        let title = "Failed log in"
        let alert = UIAlertController(title: title , message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: Configuration
    fileprivate func configLabel(label: UILabel) {
        label.font = UIFont(name: "Arial Hebrew", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "Sign in to your account"
    }
    
    fileprivate func configButton(button: UIButton) {
    
    }
    
    fileprivate func configTextField(textFields: [UITextField]) {
        for textField in textFields {
            switch textField {
            case passwordTextField:
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            case emailTextField:
                textField.placeholder = "Email Address"
            default:
                break
            }
        }
    }

}
