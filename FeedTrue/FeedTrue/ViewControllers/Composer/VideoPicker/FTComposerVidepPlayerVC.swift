//
//  FTComposerVidepPlayerVC.swift
//  FeedTrue
//
//  Created by Quoc Le on 3/30/19.
//  Copyright © 2019 toanle. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FTComposerVidepPlayerVC: UIViewController {
    var videoURL: URL
    var player: AVPlayer!
    @IBOutlet weak var avPlayerView: AVPlayerView!
    init(videoURL url: URL) {
        videoURL = url
        super.init(nibName: "FTComposerVidepPlayerVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = AVPlayer(url: videoURL)
        avPlayerView.backgroundColor = .black
        let castedLayer = avPlayerView.layer as! AVPlayerLayer
        castedLayer.player = player
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapHander(_:)))
        self.avPlayerView.isUserInteractionEnabled = true
        self.avPlayerView.addGestureRecognizer(singleTap)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //playVideo()
    }
    
    private func playVideo() {
        player.play()
    }
    
    @objc func tapHander(_ sener: Any) {
        if ((player.rate != 0) && (player.error == nil)) {
            // player is playing
            player.pause()
        } else {
            player.play()
        }
    }
}

class AVPlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
