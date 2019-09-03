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

class ViewController: BaseViewController, AVPlayerViewDelegate, PlayerControlViewDelegate {

    var player:AVPlayerView = AVPlayerView()
    
    var playerControlView:PlayerControlView = PlayerControlView()
    
    var isLandscape:Bool {
        
        return UIDevice.current.orientation.isLandscape
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        player = AVPlayerView.init(frame: getResizedFrame())
        
        //在影片讀取之前就要把控制UI實作
        playerControlView = PlayerControlView.init(frame: getResizedFrame())
        
        //player.center = view.center
        
        player.delegate = self
        
        view.addSubview(player)
        
        player.setPlayer(urlSting: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        
        
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
    func playerDidReceiveFail() {
    
        presentAlert(title: "讀取失敗", message: nil, alertType: .Normal, handler: nil)
    }
    
    func didUpdatePlayerCurrentTime(time: Float64) {
        
        playerControlView.updateCurrentTime(time: time)
        
    }
    
    func playerBufferProgress(currentTime: Float64, totalTime: Float64) {
        
        playerControlView.setProcessViewValue(current: currentTime, total: totalTime)
        
    }
    
    func playerDidFinishPlaying() {
        
        print("finish")
        
    }
    
    func playerPlayAndPause(isPlaying: Bool) {
                
        print("isPlaying",isPlaying)
        
        playerControlView.setPlayButton(isPlaying: isPlaying)
    }
    
    func didReceiveTotalDuration(time: Float64) {
    
        print("didReceiveTotalDuration",time)
        
        playerControlView.setTotalTime(time: time)
    
    }
    
    
    func didTouchPlayer() {
        
        playerControlView.show()
    }
    
    //MARK: ----- PlayerControlViewDelegate -----
    func didChangeCurrentTime(value: Float) {
        
        print("didChangeCurrentTime")
        
        player.changeCurrentTime(time: value)
        
    }
    
    func playAction() {
        
        playerControlView.setPlayButton(isPlaying: player.isPlaying)
        
        if player.isPlaying {
            
            player.pause()
            
        } else {
            
            player.play()
        }
    }
    
    func playerControlForward() {
        
        player.fastForward()
        
    }

    func playerControlRewind() {
        
        player.rewind()
    }
    
    func didEndChangeSliderValue() {
        
        player.play()
    }
    
    func orientationAction() {

        var value:Int = UIInterfaceOrientation.landscapeLeft.rawValue
        
        if UIApplication.shared.statusBarOrientation == .landscapeLeft ||  UIApplication.shared.statusBarOrientation == .landscapeRight {
            
            value = UIInterfaceOrientation.portrait.rawValue
        }
        
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
    
}

