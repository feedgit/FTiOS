//
//  SignUpUsernameViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD

class SignUpUsernameViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextFiled: DTTextField!
    @IBOutlet weak var nextButton: UIButton!
    
    let usernameMessage = NSLocalizedString("Username must be at least 6 characters.", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(back))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        
        usernameTextFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapHandler(_:)))
        self.view.addGestureRecognizer(singleTap)
        self.view.isUserInteractionEnabled = true
        usernameTextFiled.defaultBorder()
        nextButton.defaultBorder()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "username" {
            if let vc = segue.destination as? SignUpPhoneNumberViewController {
                vc.username = usernameTextFiled.text
            }
        }
    }
    
    @objc func textFieldDidChange(_ sender: Any?) {
        if let text = usernameTextFiled.text, !text.isEmpty {
            // TODO: check username correct
            NSLog("\(#function) username: \(text)")
            //nextButton.isEnabled = true
            if FTValidation().validateUsername(str: text) {
                usernameTextFiled.hideError()
            } else {
                usernameTextFiled.showError(message: usernameMessage)
            }
        } else {
            //nextButton.isEnabled = false
            usernameTextFiled.showError(message: usernameMessage)
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
        guard let text = usernameTextFiled.text else {
            usernameTextFiled.showError(message: usernameMessage)
            return
        }
        
        guard FTValidation().validateUsername(str: text) == true else {
            usernameTextFiled.showError(message: usernameMessage)
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WebService.share.validateUsername(username: text) {[weak self] (success, msg) in
            if success {
                DispatchQueue.main.async {
                    if let v = self?.view {
                        MBProgressHUD.hide(for: v, animated: true)
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let phoneVC = storyboard.instantiateViewController(withIdentifier: "phoneNumberIdentifier") as! SignUpPhoneNumberViewController
                    phoneVC.username = text
                    self?.navigationController?.pushViewController(phoneVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    if let v = self?.view {
                        MBProgressHUD.hide(for: v, animated: true)
                    }
                    
                    self?.usernameTextFiled.hideError()
                    self?.usernameTextFiled.showError(message: msg)
                }
            }
        }
    }
    
    // MARK: - Helpers
    @objc func singleTapHandler(_ sender: Any?) {
        self.view.endEditing(true)
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
