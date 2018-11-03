//
//  FTComposerPopupViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/23/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

@objc protocol ComposerDelegate {
    func composerDidSelectedItemAt(_ index: Int)
}

class FTComposerPopupViewController: UIViewController {
    weak var delegate: ComposerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var dataSource: Array<Any> = []
    var countRow: Int!
    var countCol: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generateDatasource()
        tableView.register(FTMenuTableViewCell.self, forCellReuseIdentifier: "FTMenuTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        countCol = 3
        countRow = 3
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Composer", comment: "")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func generateDatasource() {
        // section 2: menu
        let photo = ["title": "Photos", "image": "ic_photo"]
        let video = ["title": "Videos", "image": "ic_video"]
        let blog = ["title": "Blogs", "image": "ic_blog"]
        let wishlist = ["title": "Wishlist", "image": "ic_wishlist"]
        let travel = ["title": "Travel", "image": "ic_travel"]
        let miab = ["title": "MIAB", "image": "ic_miab"]
        let store = ["title": "My Store", "image": "ic_my_store"]
        dataSource = [photo, video, blog, wishlist, travel, miab, store]
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FTComposerPopupViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FTMenuTableViewCell", for: indexPath) as! FTMenuTableViewCell
        cell.pgCtrlShouldHidden = true
        cell.pgCtrlNormalColor = .gray
        cell.pgCtrlSelectedColor = .black
        cell.countRow = countRow
        cell.countCol = countCol
        cell.arrMenu = dataSource
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return ((UIScreen.main.bounds.size.width - 32) / CGFloat(countCol)) * CGFloat(countRow) + 12
        }
        return 50.0
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let label = UILabel()
//        label.text = NSLocalizedString("Choose type you want create", comment: "")
//        label.font = UIFont.systemFont(ofSize: 17)
//        label.textAlignment = .center
//        return label
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 128
//    }
}

extension FTComposerPopupViewController: FTMenuTableViewCellDelegate {
    func menuTableViewCell(_ menuCell: FTMenuTableViewCell, didSelectedItemAt index: Int) {
        //self.navigationController?.popViewController(animated: false)
        self.delegate?.composerDidSelectedItemAt(index)
    }
}
