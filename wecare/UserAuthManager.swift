import Foundation
import UIKit

// UserAuthManager.swift
class UserAuthManager {
    static let shared = UserAuthManager()
    private let defaults = UserDefaults.standard
    
    private let isLoggedInKey = "isLoggedIn"
    private let usersKey = "users"
    
    struct User: Codable {
        let email: String
        let password: String  // In real app, never store plain passwords
    }
    
    var isLoggedIn: Bool {
        get { defaults.bool(forKey: isLoggedInKey) }
        set { defaults.set(newValue, forKey: isLoggedInKey) }
    }
    
    private var users: [User] {
        get {
            guard let data = defaults.data(forKey: usersKey),
                  let users = try? JSONDecoder().decode([User].self, from: data) else {
                return []
            }
            return users
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: usersKey)
            }
        }
    }
    
    func signUp(email: String, password: String) -> Bool {
        // Check if user already exists
        guard !users.contains(where: { $0.email == email }) else {
            return false
        }
        
        let newUser = User(email: email, password: password)
        var updatedUsers = users
        updatedUsers.append(newUser)
        users = updatedUsers
        return true
    }
    
    func login(email: String, password: String) -> Bool {
        guard let user = users.first(where: { $0.email == email }),
              user.password == password else {
            return false
        }
        
        isLoggedIn = true
        return true
    }
    
    func logout() {
        isLoggedIn = false
    }
}

// LoginViewController.swift
class LoginViewController: UIViewController {
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
}

// SignUpViewController.swift
class SignUpViewController: UIViewController {
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
