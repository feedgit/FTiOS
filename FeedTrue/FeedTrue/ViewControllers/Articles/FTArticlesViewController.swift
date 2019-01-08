//
//  FTArticlesViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 10/19/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import STPopup

class FTArticlesViewController: UIViewController {
    var datasource: [FTAriticleViewModel] = []
    var coreService: FTCoreService!
    var nextURLString: String?
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    
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
        backBarBtn.tintColor = UIColor.navigationTitleTextColor()
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Articles", comment: "")
        setUpRefreshControl()
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        //refreshControl?.tintColor = UIColor.blue
        refreshControl?.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshControlValueChanged(_ sender: UIRefreshControl) {
        self.refreshControl?.endRefreshing()
        self.loadArticel()
    }
    
    @objc func loadArticel() {
        _ = self.view
        
        coreService.webService?.getArticles(username: nil, completion: {[weak self] (success, response) in
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
        coreService.webService?.loadMoreArticles(nextURL: nextURL, completion: { [weak self] (success, response) in
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
        let ct_id = cell.article.id
        let ct_name = cell.article.ct_name
        let react_type = cell.ftReactionType.rawValue
        coreService.webService?.react(ct_name: ct_name, ct_id: ct_id, react_type: react_type, completion: { (success, type) in
            if success {
                NSLog("did react successful \(type ?? "")")
            } else {
                NSLog("did react failed \(react_type)")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func articleCellDidRemoveReaction(cell: FTAriticleTableViewCell) {
        let ct_id = cell.article.id
        let ct_name = cell.article.ct_name
        coreService.webService?.removeReact(ct_name: ct_name, ct_id: ct_id, completion: { (success, msg) in
            if success {
                NSLog("Remove react successful")
            } else {
                NSLog("Remove react failed")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func articleCellDidTouchComment(cell: FTAriticleTableViewCell) {
        let commentVC = CommentController(c: coreService, contentID: cell.article.id, ctName: cell.article.ct_name)
        commentVC.contentSizeInPopup = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.75)
        let popupController = STPopupController(rootViewController: commentVC)
        popupController.style = .bottomSheet
        popupController.present(in: self)
    }
    
    func articleCellDidSave(cell: FTAriticleTableViewCell) {
        let ct_id = cell.article.id
        let ct_name = cell.article.ct_name
        coreService.webService?.saveFeed(ct_name: ct_name, ct_id: ct_id, completion: { (success, message) in
            if success {
                NSLog("Save Feed successful ct_name: \(ct_name) ct_id: \(ct_id)")
            } else {
                NSLog("Save Feed failed ct_name: \(ct_name) ct_id: \(ct_id)")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    cell.article.saved = false
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
    
    func articleCellDidUnSave(cell: FTAriticleTableViewCell) {
        let ct_id = cell.article.id
        let ct_name = cell.article.ct_name
        coreService.webService?.removeSaveFeed(ct_name: ct_name, ct_id: ct_id, completion: { (success, message) in
            if success {
                NSLog("Remove saved Feed successful ct_name: \(ct_name) ct_id: \(ct_id)")
            } else {
                NSLog("Remove saved Feed failed ct_name: \(ct_name) ct_id: \(ct_id)")
                DispatchQueue.main.async {
                    guard let indexPath = self.tableView.indexPath(for: cell) else { return }
                    cell.article.saved = true
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        })
    }
}
