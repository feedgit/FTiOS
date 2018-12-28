//
//  SignUpViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import DTTextField
import MBProgressHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: DTTextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: DTTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: DTTextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: DTTextField!
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
    var progressHUB: MBProgressHUD?
    
    let firstNameErrorMessage = NSLocalizedString("First name is invalid.", comment: "")
    let lastNameErrorMessage = NSLocalizedString("Last name is invalid.", comment: "")
    let passwordErrorMessage = NSLocalizedString("Password is invalid. At least 1 alphabet and 1 special character", comment: "")
    let confirmPasswordErrorMessage = NSLocalizedString("Your password and confirm password do not match.", comment: "")
    
    enum Gender: Int {
        case unidentified = 0
        case male = 1
        case female = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: self, action: #selector(back))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        self.view.addGestureRecognizer(singleTap)
        self.view.isUserInteractionEnabled = true
        
        // registration textfiled did change
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // gender actions
        maleIconButton.addTarget(self, action: #selector(maleSelected), for: .touchUpInside)
        maleIconButton.isUserInteractionEnabled = true
        
        maleTextButton.addTarget(self, action: #selector(maleSelected), for: .touchUpInside)
        maleTextButton.isUserInteractionEnabled = true
        
        femaleIconButton.addTarget(self, action: #selector(femaleSelected), for: .touchUpInside)
        femaleIconButton.isUserInteractionEnabled = true
        
        femaleTextButton.addTarget(self, action: #selector(femaleSelected), for: .touchUpInside)
        femaleTextButton.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
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
        guard let first_name = firstNameTextField.text else {
            firstNameTextField.showError(message: firstNameErrorMessage)
            return
        }
        
        guard let last_name = lastNameTextField.text else {
            lastNameTextField.showError(message: lastNameErrorMessage)
            return
        }
        
        guard let pwd = passwordTextField.text else {
            passwordTextField.showError(message: passwordErrorMessage)
            return
        }
        
        if pwd != confirmPasswordTextField.text {
            confirmPasswordTextField.showError(message: confirmPasswordErrorMessage)
            return
        }
        
        firstName = first_name
        lastName = last_name
        password = pwd
        
        // TODO: do signup
        let info = SignUpInfo()
        info.username = username
        info.phone_number = phoneNumber
        info.email = emai
        info.first_name = firstName
        info.last_name = lastName
        info.password = password
        info.gender = gender.rawValue
        progressHUB = MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.share.signUp(info: info) {[weak self] (success, signUpResponse) in
            if success {
                NSLog("\(#function) success: \(success), response: \(signUpResponse.debugDescription)")
                DispatchQueue.main.async {
                    self?.progressHUB?.detailsLabel.text = NSLocalizedString("Success", comment: "")
                    self?.progressHUB?.hide(animated: true, afterDelay: 2)
                    if self?.presentingViewController != nil {
                        self?.dismiss(animated: false, completion: {
                            self?.navigationController!.popToRootViewController(animated: true)
                        })
                    }
                    else {
                        self?.navigationController!.popToRootViewController(animated: true)
                    }
                }
            } else {
                NSLog("\(#function) signup failed")
                DispatchQueue.main.async {
                    self?.progressHUB?.detailsLabel.text = NSLocalizedString("Sign Up failed, please try again", comment: "")
                    self?.progressHUB?.hide(animated: true, afterDelay: 2)
                }
            }
        }
    }
    
    // MARK: - Helpers
    @objc func singleTapHandler(_ sender: Any?) {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        // firstname
        if let firstname = firstNameTextField.text, !firstname.isEmpty {
            if FTValidation().validateFirstname(str: firstname) {
                firstNameTextField.hideError()
            } else {
                firstNameTextField.showError(message: firstNameErrorMessage)
            }
        } else {
            firstNameTextField.showError(message: firstNameErrorMessage)
        }
        
        // lastname
        if let lastname = lastNameTextField.text, !lastname.isEmpty {
            if FTValidation().validateLastname(str: lastname) {
                lastNameTextField.hideError()
            } else {
                lastNameTextField.showError(message: lastNameErrorMessage)
            }
        } else {
            lastNameTextField.showError(message: lastNameErrorMessage)
        }
        
        // password
        if let pwd = passwordTextField.text, !pwd.isEmpty {
            if FTValidation().validatePassword(str: pwd) {
                passwordTextField.hideError()
            } else {
                passwordTextField.showError(message: passwordErrorMessage)
            }
        } else {
            passwordTextField.showError(message: passwordErrorMessage)
        }
        
        // confirm password
        if let confirmPwd = confirmPasswordTextField.text, !confirmPwd.isEmpty {
            if confirmPwd == passwordTextField.text {
                confirmPasswordTextField.hideError()
            } else {
                confirmPasswordTextField.showError(message: confirmPasswordErrorMessage)
            }
        } else {
            confirmPasswordTextField.showError(message: confirmPasswordErrorMessage)
        }
        
    }
    
    @objc func maleSelected() {
        gender = .male
        self.configGender()
    }
    
    @objc func femaleSelected() {
        gender = .female
        self.configGender()
    }
    
    // MARK: - Helpers
    fileprivate func configGender() {
        switch gender {
        case .female:
            femaleIconButton.setImage(#imageLiteral(resourceName: "female_selected"), for: .normal)
            femaleTextButton.setTitleColor(UIColor.genderSelectedColor(), for: .normal)
            maleIconButton.setImage(#imageLiteral(resourceName: "male_unseleted"), for: .normal)
            maleTextButton.setTitleColor(UIColor.genderUnselectedColor(), for: .normal)
        case .male:
            femaleIconButton.setImage(#imageLiteral(resourceName: "female_unselect"), for: .normal)
            femaleTextButton.setTitleColor(UIColor.genderUnselectedColor(), for: .normal)
            maleIconButton.setImage(#imageLiteral(resourceName: "male_selected"), for: .normal)
            maleTextButton.setTitleColor(UIColor.genderSelectedColor(), for: .normal)
        case .unidentified:
            break
        }
    }
    
    @IBAction func haveAnAccountPressed(_ sender: Any) {
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
