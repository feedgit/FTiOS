//
//  SignUpPhoneNumberViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DTTextField
import MBProgressHUD

class SignUpPhoneNumberViewController: UIViewController {
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: DTTextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextFiled: DTTextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var username: String?
    let phoneErrorMessage = NSLocalizedString("Phone number is invalid, please enter a valid number. Ex: +84123456789", comment: "")
    let emailErrorMessage = NSLocalizedString("Your email address is invalid. Please enter a valid address ", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem(title: NSLocalizedString("Sign Up", comment: "Sign Up"), style: .plain, target: self, action: #selector(back))
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        phoneNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        self.view.addGestureRecognizer(singleTap)
        self.view.isUserInteractionEnabled = true
        
        self.nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        self.nextButton.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
        
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let phone = phoneNumberTextField.text, !phone.isEmpty {
            if FTValidation().validatePhoneNumber(phone: phone) {
                phoneNumberTextField.hideError()
            } else {
                phoneNumberTextField.showError(message: phoneErrorMessage)
            }
        } else {
            phoneNumberTextField.showError(message: phoneErrorMessage)
        }
        
        if let email = emailTextFiled.text, !email.isEmpty {
            if FTValidation().validateEmail(email: email) {
                emailTextFiled.hideError()
            } else {
                emailTextFiled.showError(message: emailErrorMessage)
            }
        } else {
            emailTextFiled.showError(message: emailErrorMessage)
        }
    }
    
    // MARK: - Helpers
    @objc func singleTapHandler(_ sender: Any?) {
        self.view.endEditing(true)
    }
    
    @objc func next(_ sender: Any) {
        guard let phone = phoneNumberTextField.text else {
            phoneNumberTextField.showError(message: phoneErrorMessage)
            return
        }
        
        guard FTValidation().validatePhoneNumber(phone: phone) == true else {
            phoneNumberTextField.showError(message: phoneErrorMessage)
            return
        }
        
        guard let email = emailTextFiled.text else {
            emailTextFiled.showError(message: emailErrorMessage)
            return
        }
        
        guard FTValidation().validateEmail(email: email) == true else {
            emailTextFiled.showError(message: emailErrorMessage)
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.default.validatePhone(phone: phone, email: email) {[weak self] (success, dict) in
            if success {
                DispatchQueue.main.async {
                    if let v = self?.view {
                        MBProgressHUD.hide(for: v, animated: true)
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let signupVC = storyboard.instantiateViewController(withIdentifier: "signupViewController") as! SignUpViewController
                    signupVC.phoneNumber = phone
                    signupVC.emai = email
                    signupVC.username = self?.username
                    self?.navigationController?.pushViewController(signupVC, animated: true)
                    
                }
            } else {
                DispatchQueue.main.async {
                    if let v = self?.view {
                        MBProgressHUD.hide(for: v, animated: true)
                    }
                    
                    if let phone_error_msgs = dict!["phone_number"] as? [String] {
                        self?.phoneNumberTextField.showError(message: phone_error_msgs.first)
                    }
                    
                    if let email_error_msgs = dict!["email"] as? [String] {
                        self?.emailTextFiled.showError(message: email_error_msgs.first)
                    }
                }
            }
        }
    }
}
