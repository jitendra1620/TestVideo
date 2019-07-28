//
//  SecondViewController.swift
//  TestVideo
//
//  Created by Jitendra Singh on 28/07/19.
//  Copyright © 2019 Jitendra Singh. All rights reserved.
//

import UIKit
import AVKit
class SecondViewController: UIViewController {
    var player:AVPlayer?
    @IBOutlet weak var viewForPlayer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let play = player {
            let playerViewController = AVPlayerViewController()
            playerViewController.view.frame = self.viewForPlayer.bounds
            playerViewController.player = player
            
            self.addChild(playerViewController)
            self.viewForPlayer?.addSubview(playerViewController.view)
            self.didMove(toParent: self)
        }
        
    }

}
