//
//  LoginViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/26/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit
import CloudKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var toggleSignUpOrIn: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var toggleHelp: UIButton!
    @IBOutlet weak var toggleFAQ: UIButton!
    @IBOutlet weak var signUpOrInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func signUpOrInSegmentController(_ sender: Any) {
        if toggleSignUpOrIn.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.2) {
                self.confirmPasswordTextField.isHidden = true
                self.signUpOrInButton.setTitle("Log Me In", for: .normal)
                self.toggleHelp.setTitle("Forgot?", for: .normal)
                self.toggleFAQ.setTitle("Remind", for: .normal)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.confirmPasswordTextField.isHidden = false
                self.signUpOrInButton.setTitle("Sign Me Up", for: .normal)
                self.toggleHelp.setTitle("Help?", for: .normal)
                self.toggleFAQ.setTitle("FAQ", for: .normal)
            }
        }
    }
    @IBAction func signUpOrInButtonPressed(_ sender: Any) {
        if toggleSignUpOrIn.selectedSegmentIndex == 0 {
            guard usernameTextField.text == UserController.shared.currentUser?.recordID.recordName else { return }
            fetchUser()
            presentMediaListVC()
        }
        if toggleSignUpOrIn.selectedSegmentIndex == 1 {
            guard let username = usernameTextField.text,
                !username.isEmpty,
                let password = passwordTextField.text,
                !password.isEmpty,
                let confirmPassword = confirmPasswordTextField.text,
                !confirmPassword.isEmpty
                else { return }
            UserController.shared.createUser(with: username) { (success) in
                
                if success {
                    guard let username = self.usernameTextField.text,
                    !username.isEmpty,
                    let password = self.passwordTextField.text,
                    !password.isEmpty,
                    let confirmPassword = self.confirmPasswordTextField.text,
                    !confirmPassword.isEmpty
                    else { return }
                    self.presentMediaListVC()
                } else {
                    return
                }
            }
        }
    }
    
    // MARK: - Alerts
    
    // Also need an error alert for password strength and non unique username
    
    func presentLoginError() {
        let alertController = UIAlertController(title: "Incorrect password or Username", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.passwordTextField.text = ""
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
    
    func presentFetchUserFailedError() {
        let alertController = UIAlertController(title: "Incorrect Username", message: "That Username doesn't exist", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
    
    func presentWeakPasswordError() {
        let alertController = UIAlertController(title: "Password Not Strong Enough", message: "Passwords must be 8 characters long and contain one special character", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.passwordTextField.text = ""
            self.confirmPasswordTextField.text = ""
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
    
    func presentDuplicateUserError() {
        let alertController = UIAlertController(title: "That Username already exists", message: "", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Custom Methods
    
    func setUpUI() {
        companyLabel.textColor = .cyan
        appDescriptionLabel.textColor = .mediumGreen
        toggleSignUpOrIn.rotate()
        toggleSignUpOrIn.tintColor = .unclickedText
        signUpOrInButton.setTitleColor(.cyan, for: .normal)
        toggleHelp.setTitleColor(.white, for: .normal)
        toggleFAQ.setTitleColor(.mediumGreen, for: .normal)
        signUpOrInButton.backgroundColor = .black
        view.backgroundColor = .spaceGrey
        confirmPasswordTextField.isHidden = true
        signUpOrInButton.setTitle("Log Me In", for: .normal)
        toggleHelp.setTitle("Forgot?", for: .normal)
        toggleFAQ.setTitle("Remind", for: .normal)
    }
    
    func fetchUser() {
        let username = UserConstants.usernameKey
        UserController.shared.fetchUser(userName: username) { (success) in
            if success {
                self.presentMediaListVC()
            }
        }
    }
    
    // MARK: - Navigation
    
    func presentMediaListVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "MediaSearch", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
}
