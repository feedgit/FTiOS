//
//  BMCustomPlayer.swift
//  FeedTrue
//
//  Created by Quoc Le on 12/5/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit

class BMCustomPlayer: BMPlayer {
    override func storyBoardCustomControl() -> BMPlayerControlView? {
        return BMPlayerCustomControlView()
    }
}
