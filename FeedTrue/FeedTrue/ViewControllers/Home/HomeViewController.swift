//
//  HomeViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/28/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var signInData: SignInResponse!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = "username: \(signInData.username ?? "") \n fullname: \(signInData.full_name ?? "")"
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

}
