//
//  ForgotPasswordViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var getNewPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions
    
    @IBAction func resetPassword(_ sender: Any) {
        // TODO: call reset password API with email
    }
    
    @IBAction func goLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    @objc func singleTapHandler(_ sender: Any?) {
        self.view.endEditing(true)
    }
    
}
