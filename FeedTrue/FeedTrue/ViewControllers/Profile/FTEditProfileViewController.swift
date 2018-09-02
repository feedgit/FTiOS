//
//  FTEditProfileViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTEditProfileViewController: UIViewController {

    var coreService: FTCoreService!
    var profile: FTUserProfileResponse!
    var titles:[String] = ["First Name", "Last Name", "Gender", "Introduction", "About"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "EditTextTableViewCell", bundle: nil), forCellReuseIdentifier: "editTextTableViewCell")
        tableView.tableFooterView = UIView()
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

extension FTEditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTextTableViewCell") as! EditTextTableViewCell
        
        cell.label.text = titles[indexPath.row]
        cell.textFiled.text = "Edit \(indexPath.row.description)"
        if indexPath.row == 0 {
            // first name
            cell.textFiled.text = profile.first_name
        } else if indexPath.row == 1 {
            // last name
            cell.textFiled.text = profile.last_name
        } else if indexPath.row == 2 {
            // gender
            cell.textFiled.text = profile.gender
        } else if indexPath.row == 3 {
            // introduction
            cell.textFiled.text = "introduction"
        } else if indexPath.row == 4 {
            // about
            cell.textFiled.text = "about"
        } else {
            cell.textFiled.text = "Unknow DATA"
        }
        
        return cell
    }
}
