//
//  FTEditProfileViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 9/1/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import MBProgressHUD

@objc protocol FTEditProfileDelegate {
    func didSaveSuccessful()
    func didSaveFailure()
}
class FTEditProfileViewController: UIViewController {

    weak var delegate: FTEditProfileDelegate?
    var coreService: FTCoreService!
    var about: FTAboutReponse!
    var titles:[String] = ["First Name", "Last Name", "Gender", "Introduction", "About"]
    var userInfo: FTEditUserInfo!
    private var progressHub: MBProgressHUD?
    fileprivate var doneBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "EditTextTableViewCell", bundle: nil), forCellReuseIdentifier: "editTextTableViewCell")
        tableView.tableFooterView = UIView()
        
        let cancelBarBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        cancelBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = cancelBarBtn
        doneBarBtn = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(done(_:)))
        doneBarBtn.tintColor = .white
        doneBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = doneBarBtn
        
        // init user intro
        initUserInfo()
    }
    
    private func initUserInfo() {
        // init user intro
        userInfo = FTEditUserInfo()
        userInfo.fistname = about.first_name
        userInfo.lastname = about.last_name
        userInfo.gender = about.gender
        userInfo.intro = about.intro
        userInfo.about = about.about
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
        cell.cellType = EditProfileCellType(rawValue: indexPath.row)
        cell.label.text = titles[indexPath.row]
        cell.textFiled.text = "Edit \(indexPath.row.description)"
        cell.delegate = self
        
        if let type = cell.cellType {
            switch type {
            case .firstname:
                cell.textFiled.text = userInfo.fistname
            case .lastname:
                cell.textFiled.text = userInfo.lastname
            case .gender:
                cell.textFiled.text = userInfo.gender
            case .intro:
                cell.textFiled.text = userInfo.intro
            case .about:
                cell.textFiled.text = userInfo.about
            }
        } else {
            cell.textFiled.text = nil
        }
        
        
        return cell
    }
    
    // MARK: Actions
    @objc func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func done(_ sender: Any) {
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else { return }
        progressHub = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHub?.detailsLabel.text = NSLocalizedString("Saving...", comment: "")
        coreService.webService?.editUserInfo(token: token, editInfo: userInfo, completion: {[weak self] (success, response) in
            if success {
                if let info = response {
                    self?.userInfo.fistname = info.first_name
                    self?.userInfo.lastname = info.last_name
                    self?.userInfo.gender = info.gender
                    self?.userInfo.intro = info.intro
                    self?.userInfo.about = info.about
                    DispatchQueue.main.async {
                        self?.progressHub?.detailsLabel.text = NSLocalizedString("Successful", comment: "")
                        self?.progressHub?.hide(animated: true, afterDelay: 1)
                        self?.tableView.reloadData()
                        self?.delegate?.didSaveSuccessful()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.progressHub?.detailsLabel.text = NSLocalizedString("Failure", comment: "")
                        self?.progressHub?.hide(animated: true, afterDelay: 1)
                        // reset edit data
                        self?.initUserInfo()
                        self?.tableView.reloadData()
                        self?.delegate?.didSaveFailure()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.progressHub?.detailsLabel.text = NSLocalizedString("Failure", comment: "")
                    self?.progressHub?.hide(animated: true, afterDelay: 1)
                    // reset edit data
                    self?.initUserInfo()
                    self?.tableView.reloadData()
                    self?.delegate?.didSaveFailure()
                }
            }
        })
    }
}

extension FTEditProfileViewController: EditTextDelegate {
    func firstnameDidChange(firstname: String?) {
        userInfo.fistname = firstname
    }
    
    func lastnameDidChange(lastname: String?) {
        userInfo.lastname = lastname
    }
    
    func genderDidChange(gender: String?) {
        userInfo.gender = gender
    }
    
    func introDidChange(intro: String?) {
        userInfo.intro = intro
    }
    
    func aboutDidChange(about: String?) {
        userInfo.about = about
    }
    
    func textDidChange() {
        doneBarBtn.isEnabled = true
    }
}
