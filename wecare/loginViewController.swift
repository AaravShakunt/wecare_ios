//
//  loginViewController.swift
//  wecare
//
//  Created by Harshit Pesala on 15/11/24.
//

import UIKit

class loginViewController: UIViewController {

    
    
    @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Check if user is already logged in
            if UserAuthManager.shared.isLoggedIn {
                navigateToHome()
            }
        }
        
        @IBAction func loginButtonTapped(_ sender: UIButton) {
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert(message: "Please fill in all fields")
                return
            }
            
            if UserAuthManager.shared.login(email: email, password: password) {
                navigateToHome()
            } else {
                showAlert(message: "Invalid email or password")
            }
        }
        
        private func navigateToHome() {
            performSegue(withIdentifier: "toHome", sender: nil)
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
