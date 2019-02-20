//
//  FTCategoryPickerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 2/20/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit


@objc protocol CategoryPickerDelegate {
    func didSelectCategory(vc: FTCategoryPickerViewController)
}

class FTCategoryPickerViewController: UIViewController {
    weak var delegate: CategoryPickerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    var datasource: [FTFeedCategory] = []
    var selectedCategory: FTFeedCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generateDatasource()
        FTFeedCategory.register(tableView: tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Choose Category", comment: "")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func generateDatasource() {
        let something = FTFeedCategory(key: 0, label: "Something", iconName: "explore-app", background: String.somethingBackground(), description: "Something about your life")
        
        let travelCheckIn = FTFeedCategory(key: 1, label: "Travel Checkin", iconName: "checkin-app", background: String.travelCheckinBackground(), description: "Photos of your trip, your travel experience")
        
        let foodReview = FTFeedCategory(key: 2, label: "Food Review", iconName: "food-app", background: String.foodReviewBackground(), description: "Photos of your food, your food experience")
        self.datasource = [something, travelCheckIn, foodReview]
    }

}

extension FTCategoryPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier()) as! FTCategoryTableViewCell
        cell.renderCell(data: content)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = datasource[indexPath.row]
        self.delegate?.didSelectCategory(vc: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = datasource[indexPath.row]
        return content.cellHeight()
    }
}
