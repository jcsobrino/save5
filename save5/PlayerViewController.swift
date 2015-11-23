//
//  PlayerViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: AVPlayerViewController {

    var file:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let videoURL = NSURL(fileURLWithPath: file)
        self.player = AVPlayer.playerWithURL(videoURL) as AVPlayer
        self.player.play()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
