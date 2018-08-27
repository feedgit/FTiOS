//
//  LoginViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD
import DTTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: DTTextField!
    @IBOutlet weak var passwordTextField: DTTextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var useWithoutLoginButton: UIButton!
    
    fileprivate var progressHub: MBProgressHUD?
    let usernameErrorMessage = NSLocalizedString("Username field is require.", comment: "")
    let passwordErrorMessage = NSLocalizedString("Password field is require.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        self.view.addGestureRecognizer(singleTap)
        self.view.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("Sign Up", comment: "Sign Up")
        if let button = sender as? UIButton {
            if button == signupButton {
                backItem.title = NSLocalizedString("Sign Up", comment: "Sign Up")
            } else if button == forgotButton {
                backItem.title = NSLocalizedString("Forgot Password", comment: "Forgot Password")
            }
        }
        backItem.tintColor = .black
        navigationItem.backBarButtonItem = backItem
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    @IBAction func login(_ sender: Any) {
        // TODO: collect data, check & do login
        guard let username = usernameTextField.text, !username.isEmpty else {
            usernameTextField.showError(message: usernameErrorMessage)
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.showError(message: passwordErrorMessage)
            return
        }
        
        progressHub = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHub?.label.text = NSLocalizedString("Login...", comment: "")
        WebService.default.signIn(username: username, password: password) { [weak self] (success, signInResponse) in
            NSLog("success: \(success ? "TRUE": "FALSE") response: \(signInResponse.debugDescription)")
            if success {
                DispatchQueue.main.async {
                    self?.progressHub?.label.text = NSLocalizedString("Successful", comment: "")
                    self?.progressHub?.hide(animated: true, afterDelay: 1.0)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeVC = storyboard.instantiateViewController(withIdentifier: "homeVC")
                    self?.navigationController?.pushViewController(homeVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self?.progressHub?.label.text = NSLocalizedString("Login failed.", comment: "")
                    self?.progressHub?.hide(animated: true, afterDelay: 1.0)
                }
            }
            // TODO: display response info
        }
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        // TODO: login with FB
    }
    
    @IBAction func useWithoutLogin(_ sender: Any) {
        // TODO: do login without login
    }
    
    // MARK: - Helpers
    @objc func singleTapHandler(_ sender: Any?) {
        self.view.endEditing(true)
    }
    
}
