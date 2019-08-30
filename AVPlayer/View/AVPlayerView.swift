//
//  AVPlayerView.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/8/30.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol AVPlayerViewDelegate:class {
    
    func didUpdatePlayerCurrentTime(time:Float64)
    func playerDidFinishPlaying()
    func playerPlayAndPause(isPlaying:Bool)
    func receiveTotalDuration(time:Float64)
}

class AVPlayerView: UIView {

    weak var delegate:AVPlayerViewDelegate?
    
    var player : AVPlayer?
    var avPlayerLayer : AVPlayerLayer!
    var playerItem:AVPlayerItem?
    var asset:AVURLAsset!
    var isPlaying:Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setPlayer(urlSting:String) {
        
        let videoURL =  URL(string: urlSting)!
        
        playerItem = AVPlayerItem(url: videoURL)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        
        self.layer.addSublayer(playerLayer)
        
        player?.play()
        
        print("play")
        
        addVideoObserver()
        
        updatePlayerUI()
        
    }
    
    func addVideoObserver() {
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
            
            if self.player!.currentItem?.status == .readyToPlay {
                
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                
                self.delegate?.didUpdatePlayerCurrentTime(time: currentTime)
                
                //self.formatConversion(time: currentTime)
                
                //self.timeSlider.value = Float(currentTime)
                
                //self.currentTimeLabel.text = self.formatConversion(time: currentTime)
                
            }
        })
        
    }
    
    func updatePlayerUI() {
        
        // 抓取 playItem 的 duration
        let duration = playerItem!.asset.duration
        // 把 duration 轉為我們歌曲的總時間（秒數）。
        let seconds = CMTimeGetSeconds(duration)
        
        //print("seconds",seconds)
        
        //print("total",formatConversion(time: seconds))
        
        delegate?.receiveTotalDuration(time:seconds)
        
        
        
        // 把我們的歌曲總時長顯示到我們的 Label 上。
        //songLengthLabel.text = formatConversion(time: seconds)
        //timeSlider.minimumValue = 0
        // 更新 Slider 的 maximumValue。
        //timeSlider!.maximumValue = Float(seconds)
        // 這裡看個人需求，如果想要拖動後才更新進度，那就設為 false；如果想要直接更新就設為 true，預設為 true。
        //timeSlider!.isContinuous = true
        
    }
    
    func formatConversion(time:Float64) -> String {
        
        let length = Int(time)
        
        let minutes = Int(length / 60) // 求 songLength 的商，為分鐘數
        
        let seconds = Int(length % 60) // 求 songLength 的餘數，為秒數
        
        var time = ""
        
        if minutes < 10 {
            
            time = "0\(minutes):"
        } else {
            time = "\(minutes)"
        }
        if seconds < 10 {
            time += "0\(seconds)"
        } else {
            time += "\(seconds)"
        }
        return time
    }
    
    @objc func playerDidFinishPlaying() {
        
        print("Finished")
    }
    
    func playAndPause() {
        
        if isPlaying == false {
            
            //playButton.setImage(UIImage(named: "icons8-pause"), for:   UIControlState.normal)
            
            isPlaying = true
            
            player?.play()
            
            print("play")
            
        } else {
            
            //playButton.setImage(UIImage(named: "icons8-play"), for: UIControlState.normal)
            
            isPlaying = false
            
            player?.pause()
            
            print("pause")
        }
        
        delegate?.playerPlayAndPause(isPlaying: isPlaying)
    }
    
    @IBAction func changeCurrentTime(_ sender: UISlider) {
        
        //let seconds = Int64(timeSlider.value)
        //let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        // 將當前設置時間設為播放時間
        //player?.seek(to: targetTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        playAndPause()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
