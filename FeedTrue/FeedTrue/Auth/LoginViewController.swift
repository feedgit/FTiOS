//
//  LoginViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginWithFacebookButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var useWithoutLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        // TODO: login with FB
    }
    
    @IBAction func useWithoutLogin(_ sender: Any) {
        // TODO: do login without login
    }
    
}
