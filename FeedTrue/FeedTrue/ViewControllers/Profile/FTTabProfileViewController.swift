//
//  FTTabProfileViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTTabProfileViewController: FTTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // MARK: - IBActions

    @IBAction func edit(_ sender: Any) {
        let editVC = FTEditProfileViewController(nibName: "FTEditProfileViewController", bundle: nil)
        editVC.coreService = rootViewController.coreService
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func addFriend(_ sender: Any) {
        guard let token = rootViewController.coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        rootViewController.coreService.webService?.logOut(token: token, completion: {[weak self] (success, message) in
            if success {
                DispatchQueue.main.async {
                    self?.rootViewController.showLogin()
                    self?.rootViewController.coreService.registrationService?.reset()
                }
            } else {
                // TODO: show error message
                DispatchQueue.main.async {
                    self?.rootViewController.showLogin()
                }
            }
        })
    }
    
}
