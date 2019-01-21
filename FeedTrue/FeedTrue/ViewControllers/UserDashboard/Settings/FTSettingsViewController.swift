//
//  FTSettingsViewController.swift
//  FeedTrue
//
//  Created by Le Cong Toan on 1/21/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTSettingsViewController: UIViewController {
    var dataSource: [[BECellDataSource]] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FTSettingViewModel.register(tableView: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        generateDatasource()
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Settings", comment: "")
    }

    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func generateDatasource() {
        let exploreVM = FTSettingViewModel(imageName: "feed_selected", title: "Explore")
        let travelVM = FTSettingViewModel(imageName: "ic_travel", title: "Travel")
        dataSource.append([travelVM, exploreVM])
        dataSource.append([travelVM])
    }

}

extension FTSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        if let renderCell = cell as? BECellRender {
            renderCell.renderCell(data: content)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = dataSource[indexPath.section][indexPath.row]
        return content.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(#function) atIndex \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("System", comment: "")
        case 1:
            return NSLocalizedString("More", comment: "")
        default:
            return nil
        }
    }
    
}
