//
//  SignUpUsernameViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class SignUpUsernameViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextFiled: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem(title: NSLocalizedString("Sign Up", comment: "Sign Up"), style: .plain, target: self, action: #selector(back))
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        
        // default NEXT button is disable
        nextButton.isEnabled = false
        usernameTextFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }

}
