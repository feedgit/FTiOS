//
//  FTArticlesViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class FTArticlesViewController: UIViewController {
    var datasource: [FTAriticleViewModel] = []
    var coreService: FTCoreService!
    var nextURLString: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    init(coreService c: FTCoreService) {
        coreService = c
        super.init(nibName: "FTArticlesViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FTAriticleViewModel.register(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        loadArticel()
        
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Articles", comment: "")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func loadArticel() {
        _ = self.view
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        
        coreService.webService?.getArticles(username: nil, token: token, completion: {[weak self] (success, response) in
            if success {
                NSLog("load articles success \(response?.count ?? 0)")
                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let articles = response?.results {
                        self?.datasource.removeAll()
                        self?.datasource = articles.map({FTAriticleViewModel(a: $0)})
                        self?.tableView.reloadData()
                        self?.tableView.addBotomActivityView {
                            self?.loadMore()
                        }
                    }
                }
            } else {
                NSLog("load articles failure")
            }
        })
    }
    
    func loadMore() {
        guard let nextURL = self.nextURLString else {
            self.tableView.removeBottomActivityView()
            return
        }
        guard let token = coreService.registrationService?.authenticationProfile?.accessToken else {
            return
        }
        coreService.webService?.loadMoreArticles(nextURL: nextURL, token: token, completion: { [weak self] (success, response) in
            if success {
                NSLog("load more articles successful \(response?.next ?? "")")
                self?.nextURLString = response?.next
                DispatchQueue.main.async {
                    if let articles = response?.results {
                        if articles.count > 0 {
                            self?.tableView.endBottomActivity()
                            
                            self?.datasource.append(contentsOf: articles.map({FTAriticleViewModel(a: $0)}))
                            self?.tableView.reloadData()
                        }
                        else {
                            self?.tableView.removeBottomActivityView()
                        }
                    } else {
                        self?.tableView.removeBottomActivityView()
                    }
                }
            } else {
                self?.tableView.removeBottomActivityView()
            }
        })
        
    }

}

extension FTArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = datasource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier()) as! FTAriticleTableViewCell
        cell.delegate = self
        cell.renderCell(data: content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = datasource[indexPath.row]
        return content.cellHeight()
    }
}

extension FTArticlesViewController: FTAticleCellDelegate {
    func articleCellDidChangeReaction(cell: FTAriticleTableViewCell) {
        
    }
    
    func articleCellDidRemoveReaction(cell: FTAriticleTableViewCell) {
        
    }
    
    
}
