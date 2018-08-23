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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backButton = UIBarButtonItem(title: NSLocalizedString("Sign Up", comment: "Sign Up"), style: .plain, target: self, action: #selector(back))
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
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
    }
    

}
