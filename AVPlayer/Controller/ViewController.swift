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

class ViewController: UIViewController, AVPlayerViewDelegate, PlayerControlViewDelegate {
    
    var player:AVPlayerView = AVPlayerView()
    
    var playerControlView:PlayerControlView = PlayerControlView()
    
    var isLandscape:Bool {
        
        return UIDevice.current.orientation.isLandscape
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        player = AVPlayerView.init(frame: getResizedFrame())
        
        player.center = view.center
        
        player.delegate = self
        
        view.addSubview(player)
        
        player.setPlayer(urlSting: "https://bit.ly/2kmfAKC")
        
        
        playerControlView = PlayerControlView.init(frame: getResizedFrame())
        
        playerControlView.delegate = self
        
        player.addSubview(playerControlView)
        
        player.bringSubviewToFront(playerControlView)
        
    }
    
    private func getResizedFrame() -> CGRect {
        
        var width = view.frame.size.width
        
        var height = view.frame.size.height
        
        if view.frame.size.width > view.frame.size.height {
            
            width = view.frame.size.height
            
            height = view.frame.size.width
            
        }
        
        if isLandscape {
            
            print("Landscape")
            
            return CGRect.init(x: 0, y: 0, width: height, height: width)
            
        } else {
            
            print("Portrait")
            
            return CGRect.init(x: 0, y: 0, width: width, height: width/16*9)
        }
        
    }
    
    ///偵測螢幕自動轉向
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        player.frame = getResizedFrame()
        
        player.resizeSubViews()
        
        playerControlView.frame = getResizedFrame()
        
        playerControlView.setOrientationButtonImage(isLandscape: isLandscape)
        
    }
    
    //MARK: ----- AVPlayerViewDelegate -----
    func didUpdatePlayerCurrentTime(time: Float64) {
        
        playerControlView.updateCurrentTime(time: time)
        
    }
    
    ///播放完畢
    func playerDidFinishPlaying() {
        
        print("finish")
        
    }
    
    /**
     開始與結束播放
     - Parameter isPlaying: 是否正在播放
     */
    func playerPlayAndPause(isPlaying: Bool) {
                
        print("isPlaying",isPlaying)
        
        playerControlView.setPlayButton(isPlaying: isPlaying)
    }
    
    /**
     接收到影片長度
     - Parameter time: 影片長度
     */
    func didReceiveTotalDuration(time: Float64) {
    
        print("didReceiveTotalDuration",time)
        
        playerControlView.setTotalTime(time: time)
    
    }
    
    ///觸摸播放器圖層
    func didTouchPlayer() {
        
        playerControlView.show()
    }
    
    //MARK: ----- PlayerControlViewDelegate -----
    /**
     變更播放進度
     - Parameter value: 播放進度
     */
    func didChangeCurrentTime(value: Float) {
        
        player.changeCurrentTime(time: value)
        
    }
    
    ///播放
    func playAction() {
        
        playerControlView.setPlayButton(isPlaying: player.isPlaying)
        
        if player.isPlaying {
            
            player.pause()
            
        } else {
            
            player.play()
        }
        
        
        
    }
    
    ///快轉
    func playerControlForward() {
        
        player.fastForward()
        
    }
    
    ///回放
    func playerControlRewind() {
        
        player.rewind()
    }
    
    ///手動螢幕轉向
    func orientationAction() {

        var value:Int = UIInterfaceOrientation.landscapeLeft.rawValue
        
        if UIApplication.shared.statusBarOrientation == .landscapeLeft ||  UIApplication.shared.statusBarOrientation == .landscapeRight {
            
            value = UIInterfaceOrientation.portrait.rawValue
        }
        
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
    
}

