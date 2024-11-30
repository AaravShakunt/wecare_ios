//
//  signupViewController.swift
//  wecare
//
//  Created by Harshit Pesala on 15/11/24.
//

import UIKit

class signupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var confirmPasswordTextField: UITextField!
        
        @IBAction func signUpButtonTapped(_ sender: UIButton) {
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty,
                  let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
                showAlert(message: "Please fill in all fields")
                return
            }
            
            guard password == confirmPassword else {
                showAlert(message: "Passwords don't match")
                return
            }
            
            if UserAuthManager.shared.signUp(email: email, password: password) {
                // Show success and navigate to login
                let alert = UIAlertController(title: "Success",
                                            message: "Account created successfully",
                                            preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                present(alert, animated: true)
            } else {
                showAlert(message: "Email already exists")
            }
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

}
