//
//  ViewController.swift
//  AVPlayerProject
//
//  Created by Yu Li Lin on 2019/8/29.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var playerControlView: PlayerControlView!
    
    var player : AVPlayer?
    var avPlayerLayer : AVPlayerLayer!
    var playerItem:AVPlayerItem?
    var asset:AVURLAsset!
    var isPlaying:Bool = false
    
    @IBOutlet weak var timeSlider: UISlider!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setPlayer(urlSting: "https://bit.ly/2Zsq1uE")
    }
    
    func setPlayer(urlSting:String) {
        
        let videoURL =  URL(string: urlSting)!
        
        
        //定义一个视频文件路径
        //let filePath = Bundle.main.path(forResource: "hangge", ofType: "mp4")
        //let videoURL = URL(fileURLWithPath: filePath!)
        //定义一个playerItem，并监听相关的通知
        playerItem = AVPlayerItem(url: videoURL)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        //定义一个视频播放器，通过playerItem径初始化
        player = AVPlayer(playerItem: playerItem)
        //設定大小和位置（全螢幕）
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        //加到介面
        self.view.layer.addSublayer(playerLayer)
        //開始播放
        player?.play()
        
        print("play")
        
        addVideoObserver()
        
        updatePlayerUI()
        
        
        view.bringSubviewToFront(playerControlView)
    }
    
    func addVideoObserver() {
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
            
            if self.player!.currentItem?.status == .readyToPlay {
                
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                
                print("currentTime",self.formatConversion(time: currentTime))
                
                self.timeSlider.value = Float(currentTime)
                
                //self.currentTimeLabel.text = self.formatConversion(time: currentTime)
                
            }
        })
        
    }
    
    func updatePlayerUI() {
        // 抓取 playItem 的 duration
        let duration = playerItem!.asset.duration
        // 把 duration 轉為我們歌曲的總時間（秒數）。
        let seconds = CMTimeGetSeconds(duration)
        
        print("seconds",seconds)
        
        print("total",formatConversion(time: seconds))
        
        
        // 把我們的歌曲總時長顯示到我們的 Label 上。
        //songLengthLabel.text = formatConversion(time: seconds)
        timeSlider.minimumValue = 0
        // 更新 Slider 的 maximumValue。
        timeSlider!.maximumValue = Float(seconds)
        // 這裡看個人需求，如果想要拖動後才更新進度，那就設為 false；如果想要直接更新就設為 true，預設為 true。
        timeSlider!.isContinuous = true
        
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
    }
    
    @IBAction func changeCurrentTime(_ sender: UISlider) {
        
        let seconds = Int64(timeSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        // 將當前設置時間設為播放時間
        player?.seek(to: targetTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        playAndPause()
    }
    
}

