//
//  FTArticleDetailViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 1/9/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit

class FTArticleDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var article: FTArticleContent
    var dataSource: [BECellDataSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArticelThumbnailViewModel.register(tableView: tableView)
        ArticleTitleViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        generateDataSrouce()
        loadArticelDetail()
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        setUpRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString(article.title, comment: "")
    }
    
    init(article a: FTArticleContent) {
        article = a
        super.init(nibName: "FTArticleDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func generateDataSrouce() {
        let thumbnaiVM = ArticelThumbnailViewModel(thumbnai: article.thumbnail)
        self.dataSource.append(thumbnaiVM)
        
        let titleVM = ArticleTitleViewModel(title: article.title)
        self.dataSource.append(titleVM)
    }
    
    private func loadArticelDetail() {
        
    }
    
    private func setUpRefreshControl() {
        
    }

}

extension FTArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier())!
        if let editingCell = cell as? BECellRender {
            editingCell.renderCell(data: content)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = dataSource[indexPath.row]
        return content.cellHeight()
    }
    
}
