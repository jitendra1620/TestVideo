//
//  PlayerTableViewCell.swift
//  TestVideo
//
//  Created by Jitendra Singh on 27/07/19.
//  Copyright © 2019 Jitendra Singh. All rights reserved.
//

import UIKit
import AVKit
class PlayerTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PlayerTableViewCell"
    
    @IBOutlet weak var lblRow: UILabel!
    @IBOutlet weak var imgvThumbNail: UIImageView!
    @IBOutlet weak var viewPlayer: UIView!
    var parentVC:ViewController!
    let playerViewController = AVPlayerViewController()
    var row:Int = 0{
        didSet{
            self.lblRow.text = String(format: "%d", row)
        }
    }
    var viewExtraPlayer:UIView?
    var player:AVPlayer?
    var playerLayer: AVPlayerLayer?
    var thumbNailImage:UIImage!{
        didSet{
            self.imgvThumbNail.image = thumbNailImage
            self.stopPlayer()
        }
    }
    var strURL:String = ""{
        didSet{
            initPlayer()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension PlayerTableViewCell{
    func initPlayer()  {
        if let play = player {
            play.play()
        } else {
            let videoURL = URL(string: strURL)
            player = AVPlayer(url: videoURL!)
//            playerLayer = AVPlayerLayer(player: player)
//            playerLayer?.frame = self.viewPlayer.bounds
            self.viewExtraPlayer = UIView.init(frame: self.viewPlayer.bounds)
//            self.viewExtraPlayer?.layer.addSublayer(playerLayer!)
            self.viewPlayer.addSubview(viewExtraPlayer!)
//            player?.play()
            playerViewController.view.frame = self.viewPlayer.bounds
            playerViewController.player = player
            
            parentVC.addChild(playerViewController)
            self.viewExtraPlayer?.addSubview(playerViewController.view)
            playerViewController.didMove(toParent: parentVC)
            playerViewController.addObserver(self, forKeyPath: #keyPath(AVPlayerViewController.videoBounds), options: [.old, .new], context: nil)
            player?.play()
        }
    }
    
    func stopPlayer() {
        if let play = player {
            play.pause()
            self.playerLayer?.removeFromSuperlayer()
            player = nil
        } else {
        }
        if let v = viewExtraPlayer{
            v.removeFromSuperview()
        }
    }
}
