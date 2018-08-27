//
//  SignUpViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var femaleIconButton: UIButton!
    @IBOutlet weak var femaleTextButton: UIButton!
    @IBOutlet weak var maleIconButton: UIButton!
    @IBOutlet weak var maleTextButton: UIButton!
    @IBOutlet weak var finishSignUpButton: UIButton!
    
    var username: String?
    var phoneNumber: String?
    var emai: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var confirmPassword: String?
    var gender: Gender = .female
    
    enum Gender: String {
        case male = "Male"
        case female = "Female"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem(title: NSLocalizedString("Sign Up", comment: "Sign Up"), style: .plain, target: self, action: #selector(back))
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        self.view.addGestureRecognizer(singleTap)
        self.view.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
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
    @IBAction func finishSignUpPressed(_ sender: Any) {
        firstName = firstNameTextField.text
        lastName = lastNameTextField.text
        password = passwordTextField.text
        confirmPassword = confirmPasswordTextField.text
        
        if checkLastName(lastName) &&
            checkFirstName(firstName) &&
            checkPassWord(password, confirmPassword: confirmPassword) {
            // TODO: do signup
            let info = SignUpInfo()
            info.username = username
            info.phone_number = phoneNumber
            info.email = emai
            info.first_name = firstName
            info.last_name = lastName
            info.password = password
            info.gender = gender.rawValue
            
            WebService.default.signUp(info: info) { (success, signUpResponse) in
                if success {
                    NSLog("\(#function) success: \(success), response: \(signUpResponse.debugDescription)")
                    DispatchQueue.main.async {
                        if self.presentingViewController != nil {
                            self.dismiss(animated: false, completion: {
                                self.navigationController!.popToRootViewController(animated: true)
                            })
                        }
                        else {
                            self.navigationController!.popToRootViewController(animated: true)
                        }
                    }
                } else {
                    NSLog("\(#function) signup failed")
                }
            }
        } else {
            // TODO: handler error
        }
    }
    
    // MARK: - Helpers
    func checkFirstName(_ firstName: String?) -> Bool {
        if firstName != nil && !firstName!.isEmpty {
            return true
        }
        
        return false
    }
    
    func checkLastName(_ lastName: String?) -> Bool {
        if lastName != nil && !lastName!.isEmpty {
            return true
        }
        
        return false
    }
    
    func checkPassWord(_ password: String?, confirmPassword: String?) -> Bool {
        if password != nil &&
            !password!.isEmpty &&
            confirmPassword != nil &&
            !confirmPassword!.isEmpty &&
            password == confirmPassword {
            return true
            
        }
        return false
    }
    
    // MARK: - Helpers
    @objc func singleTapHandler(_ sender: Any?) {
        self.view.endEditing(true)
    }
    

}
