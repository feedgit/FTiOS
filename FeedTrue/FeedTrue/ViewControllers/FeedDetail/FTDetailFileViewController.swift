//
//  FTDetailFileViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/3/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTDetailFileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = [FTDetailFileViewModel]()
    var feedInfo: FTFeedInfo!
    private var extraMargin: CGFloat = SKMesurement.isPhoneX ? 40 : 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource = []
        FTDetailFileViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        generateDataSource()
    }

    
    init(feedInfo feed: FTFeedInfo) {
        feedInfo = feed
        super.init(nibName: "FTDetailFileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  generateDataSource() {
        let model = FTDetailFileViewModel(f: feedInfo)
        dataSource.append(model)
    }
    
    func updateFrame(frame: CGRect) {
        self.view.frame = CGRect(x: 0, y: frame.height - 44 - extraMargin, width: frame.width, height: 44)
    }
    
    func setControlsHidden(hidden: Bool) {
        let alpha: CGFloat = hidden ? 0.0 : 1.0
        
        UIView.animate(withDuration: 0.35,
                       animations: { () -> Void in self.view.alpha = alpha },
                       completion: nil)
    }
    

}

extension FTDetailFileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier()) as! FTDetailFileTableViewCell
        //cell.delegate = self
        cell.renderCell(data: content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = dataSource[indexPath.row]
        return content.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    
}
