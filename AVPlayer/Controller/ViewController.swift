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

class ViewController: UIViewController, AVPlayerViewDelegate {

    var player:AVPlayerView = AVPlayerView()
    
    var playerControl:PlayerControlView = PlayerControlView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let width:CGFloat = view.frame.size.width
        let height:CGFloat = view.frame.size.height/16*9
        
        player = AVPlayerView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        
        player.center = view.center
        
        player.delegate = self
        
        view.addSubview(player)
        
        player.setPlayer(urlSting: "https://r7---sn-ipoxu-umb6.googlevideo.com/videoplayback?expire=1567159061&ei=tZ5oXYKdGcuG1wLDjrvgAg&ip=178.162.205.105&id=o-AOUFiwf6_Y9WEMVxSnra5B9XxwgnRynVSRXoPPVOonGC&itag=18&source=youtube&requiressl=yes&mime=video%2Fmp4&gir=yes&clen=19038954&ratebypass=yes&dur=323.268&lmt=1543876827640707&fvip=5&c=WEB&txp=5531432&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=ALgxI2wwRQIhAPtHwSKMb8b5zivIvBFcjnN6iFv4KckdXYF5twrFXcIhAiBgDG4YY01nNbXCUK8J53jr1hLa8bMQz54zmQDqrEjZjA==&title=Eminem_-_Lose_Yourself_[HD]&cms_redirect=yes&mip=36.232.51.66&mm=31&mn=sn-ipoxu-umb6&ms=au&mt=1567137336&mv=m&mvi=6&pl=21&lsparams=mip,mm,mn,ms,mv,mvi,pl&lsig=AHylml4wRQIgT2bs_zglVaf_2OVjVm1W2sSSpP5seK8aLMjDpijt0t8CIQDMGimCJaq9x9VsHBDOGQ4TZkypcFDGGiH6HphWLsqP6w==")
        
        
        let playerControlView:PlayerControlView = PlayerControlView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        
        
        player.addSubview(playerControlView)
        
        player.bringSubviewToFront(playerControlView)
        
    }
    
    func formatConversion(time:Float64) -> String {
        
        let songLength = Int(time)
        let minutes = Int(songLength / 60) // 求 songLength 的商，為分鐘數
        let seconds = Int(songLength % 60) // 求 songLength 的餘數，為秒數
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
    
    //MARK: ----- AVPlayerViewDelegate -----
    func didUpdatePlayerCurrentTime(time: Float64) {
        
        let timeStr = self.formatConversion(time: time)
        
        playerControl.updateCurrentTime(time: timeStr)
        
        print("timeStr",timeStr)
        
        //self.timeSlider.value = Float(currentTime)
        
        //self.currentTimeLabel.text = self.formatConversion(time: currentTime)
    }
    
    func playerDidFinishPlaying() {
        
        print("finish")
    }
    
    func playerPlayAndPause(isPlaying: Bool) {
                
        print("isPlaying",isPlaying)
    }
    
    func receiveTotalDuration(time: Float64) {
        
        let timeStr = self.formatConversion(time: time)
        
        playerControl.setTotalTime(time: timeStr)
        
        //把我們的歌曲總時長顯示到我們的 Label 上。
        //songLengthLabel.text = formatConversion(time: seconds)
        //timeSlider.minimumValue = 0
        // 更新 Slider 的 maximumValue。
        //timeSlider!.maximumValue = Float(seconds)
        // 這裡看個人需求，如果想要拖動後才更新進度，那就設為 false；如果想要直接更新就設為 true，預設為 true。
        //timeSlider!.isContinuous = true
    }
}

