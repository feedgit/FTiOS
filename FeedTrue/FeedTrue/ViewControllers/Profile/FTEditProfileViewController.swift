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

    enum FieldData {
        case firstname
        case lastname
        case nickname
        case introduction
        case gender
        case dob
        case about
        case bio
        case favourite
        case email
        case website
    }
    
    weak var delegate: FTEditProfileDelegate?
    var coreService: FTCoreService!
    var about: FTAboutReponse?
    var profile: FTUserProfileResponse?
    var titles:[String] = ["User Name", "First Name", "Last Name", "Gender", "Introduction", "About"]
    
    var genderList = ["UnIdentified", "Male", "Female"]
    var editInfo: FTEditUserInfo!
    private var progressHub: MBProgressHUD?
    fileprivate var doneBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [(FTEditProfileViewModel, FieldData)] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        FTEditProfileViewModel.register(tableView: tableView)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
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
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else { return }
        guard let username = coreService.registrationService?.authenticationProfile?.profile?.username else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        coreService.webService?.getUserAbout(token: token, username: username, completion: {[weak self] (success, response) in
            if success {
                self?.about = response
                self?.prepareDataSource()
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
    
    func prepareDataSource() {
        guard let about = self.about else { return }
        let firstNameData = FTSingleLineViewModel.init(title: NSLocalizedString("First Name", comment: ""), prefilSingleLine: about.first_name)
        let lastNameData = FTSingleLineViewModel.init(title: NSLocalizedString("Last Name", comment: ""), prefilSingleLine: about.last_name)
        let nickNameData = FTSingleLineViewModel.init(title: NSLocalizedString("Nick Name", comment: ""), prefilSingleLine: about.nickname)
        let introData = FTSingleLineViewModel.init(title: NSLocalizedString("Introduction", comment: ""), prefilSingleLine: about.intro)
        let genderData = FTGenderViewModel(title: NSLocalizedString("Gender", comment: ""), prefilGender: genderList[about.gender ?? 0])
        let dobData = FTDOBViewModel(title: NSLocalizedString("Date of Birth", comment: ""), prefilDOB: about.date_of_birth)
        let aboutData = FTMultipleLinesViewModel(title: NSLocalizedString("About you", comment: ""), prefilMultipleLines: about.about)
        let biographyDate = FTMultipleLinesViewModel(title: NSLocalizedString("Biography", comment: ""), prefilMultipleLines: about.bio)
        let favouriteQuoteData = FTMultipleLinesViewModel(title: NSLocalizedString("Favourite Quote", comment: ""), prefilMultipleLines: about.quotes)
        let emailData = FTSingleLineViewModel.init(title: NSLocalizedString("Email", comment: ""), prefilSingleLine: about.email)
        let websiteData = FTSingleLineViewModel.init(title: NSLocalizedString("Website", comment: ""), prefilSingleLine: about.website)
        
        dataSource = [(firstNameData, FieldData.firstname), (lastNameData, FieldData.lastname), (nickNameData, FieldData.nickname), (introData, FieldData.introduction), (genderData, FieldData.gender), (dobData, FieldData.dob), (aboutData, FieldData.about), (biographyDate, FieldData.bio), (favouriteQuoteData, FieldData.favourite), (emailData, FieldData.email), (websiteData, FieldData.website)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FTEditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = dataSource[indexPath.row].0
        return data.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.row].0
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        
        if let editingCell = cell as? BECellRender {
            editingCell.renderCell(data: content)
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
