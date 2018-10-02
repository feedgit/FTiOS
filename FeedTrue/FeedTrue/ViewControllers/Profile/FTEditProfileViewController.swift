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
    var about: FTAboutReponse?
    var profile: FTUserProfileResponse?
    var titles:[String] = ["User Name", "First Name", "Last Name", "Gender", "Introduction", "About"]
    var editInfo: FTEditUserInfo!
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
        tableView.separatorInset = UIEdgeInsetsMake(0, 125, 0, 0)
        
        let cancelBarBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        cancelBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = cancelBarBtn
        doneBarBtn = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(done(_:)))
        doneBarBtn.tintColor = .white
        doneBarBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = doneBarBtn
        
        // load user intro
        loadUserInfo()
        editInfo = FTEditUserInfo()
    }
    
    private func loadUserInfo() {
        // init user intro
        //        userInfo = FTEditUserInfo()
        //        userInfo.username = about.username
        //        userInfo.fistname = about.first_name
        //        userInfo.lastname = about.last_name
        //        userInfo.gender = about.gender
        //        userInfo.intro = about.intro
        //        userInfo.about = about.about
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else { return }
        guard let username = coreService.registrationService?.authenticationProfile?.profile?.username else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        coreService.webService?.getUserAbout(token: token, username: username, completion: {[weak self] (success, response) in
            if success {
                self?.about = response
                self?.editInfo.username = self?.about?.username
                self?.editInfo.fistname = self?.about?.first_name
                self?.editInfo.lastname = self?.about?.last_name
                self?.editInfo.gender = self?.about?.gender
                self?.editInfo.intro = self?.about?.intro
                self?.editInfo.about = self?.about?.about
                DispatchQueue.main.async {
                    guard let v = self?.view else { return }
                    MBProgressHUD.hide(for: v, animated: true)
                    self?.tableView.reloadData()
                }
            } else {
                NSLog("\(#function) FAILURE")
                guard let v = self?.view else { return }
                MBProgressHUD.hide(for: v, animated: true)
            }
            
        })
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTextTableViewCell") as! EditTextTableViewCell
        cell.cellType = EditProfileCellType(rawValue: indexPath.row)
        cell.label.text = titles[indexPath.row]
        cell.textFiled.text = "Edit \(indexPath.row.description)"
        cell.delegate = self
        
        if let type = cell.cellType {
            switch type {
            case .username:
                cell.textFiled.text = about?.username
            case .firstname:
                cell.textFiled.text = about?.first_name
            case .lastname:
                cell.textFiled.text = about?.last_name
            case .gender:
                //cell.textFiled.text = about?.gender
                if let gender = about?.gender {
                    switch gender {
                    case 1:
                        cell.textFiled.text = NSLocalizedString("Male", comment: "")
                    case 2:
                        cell.textFiled.text = NSLocalizedString("Female", comment: "")
                    default:
                        cell.textFiled.text = NSLocalizedString("UnIdentified", comment: "")
                    }
                } else {
                    cell.textFiled.text = NSLocalizedString("UnIdentified", comment: "")
                }
            case .intro:
                cell.textFiled.text = about?.intro
            case .about:
                cell.textFiled.text = about?.about
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
        self.doneBarBtn.isEnabled = false
        
        coreService.webService?.editUserInfo(token: token, editInfo: editInfo, completion: {[weak self] (success, response) in
            if success {
                if let info = response {
                    self?.about?.username = info.username
                    self?.about?.first_name = info.first_name
                    self?.about?.last_name = info.last_name
                    self?.about?.gender = info.gender
                    self?.about?.intro = info.intro
                    self?.about?.about = info.about
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
                        self?.tableView.reloadData()
                        self?.delegate?.didSaveFailure()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.progressHub?.detailsLabel.text = NSLocalizedString("Failure", comment: "")
                    self?.progressHub?.hide(animated: true, afterDelay: 1)
                    // reset edit data
                    self?.tableView.reloadData()
                    self?.delegate?.didSaveFailure()
                }
            }
        })
    }
    
    private func checkAndSaveUsername() {
        if editInfo.username != about?.username {
            // TODO: save user name
        }
    }
}

extension FTEditProfileViewController: EditTextDelegate {
    
    func usernameDidChange(username: String?) {
        editInfo.username = username
    }
    
    func firstnameDidChange(firstname: String?) {
        editInfo.fistname = firstname
    }
    
    func lastnameDidChange(lastname: String?) {
        editInfo.lastname = lastname
    }
    
    func genderDidChange(gender: String?) {
        //editInfo.gender = gender
    }
    
    func introDidChange(intro: String?) {
        editInfo.intro = intro
    }
    
    func aboutDidChange(about: String?) {
        editInfo.about = about
    }
    
    func textDidChange() {
        doneBarBtn.isEnabled = true
    }
}
