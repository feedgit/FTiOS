//
//  FTArticelComposerViewController.swift
//  FeedTrue
//
//  Created by Quoc Le on 11/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import RichEditorView

class FTArticelComposerViewController: UIViewController {
    
    var coreService: FTCoreService!
    var editorView: RichEditorView!
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backBarBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back(_:)))
        backBarBtn.tintColor = .white
        self.navigationItem.leftBarButtonItem = backBarBtn
        navigationItem.title = NSLocalizedString("Write Blog", comment: "")
        
        let nextBarBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(next(_:)))
        nextBarBtn.tintColor = .white
        self.navigationItem.rightBarButtonItem = nextBarBtn
        
        editorView = RichEditorView(frame: self.view.bounds)
        self.view.addSubview(editorView)
        //editorView.delegate = self
        editorView.inputAccessoryView = toolbar
        editorView.placeholder = NSLocalizedString("Write something...", comment: "")
        
        //toolbar.delegate = self
        toolbar.editor = editorView
        
        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar.editor?.html = ""
        }
        
        var options = toolbar.options
        options.append(item)
        toolbar.options = options
    }
    
    init(coreService service: FTCoreService) {
        self.coreService = service
        super.init(nibName: "FTArticelComposerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: Any) {
        let photoPicker = FTPhotoPickerViewController(coreService: coreService)
        photoPicker.maxSelectableCount = 1
        photoPicker.type = .article
        photoPicker.content = editorView.html
        self.navigationController?.pushViewController(photoPicker, animated: true)
    }

}
