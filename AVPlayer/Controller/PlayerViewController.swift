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

class PlayerViewController: BaseViewController, AVPlayerViewDelegate, PlayerControlViewDelegate{

    var player:AVPlayerView = AVPlayerView()
    
    var playerControlView:PlayerControlView = PlayerControlView()
    
    @IBOutlet weak var backButton: UIButton!
    
    var isLandscape:Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    var video:Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
        let width = view.frame.size.width
        let height = width/16*9
        
        player = AVPlayerView.init(frame: CGRect.init(x: 0, y: view.frame.size.height/2-height/2, width: width, height: height))
        
        //在影片讀取之前就要把控制UI實作
        playerControlView = PlayerControlView.init(frame: player.bounds)
        
        player.delegate = self
        
        view.addSubview(player)
        
        if let path = video?.sources {
            
            player.setPlayer(urlSting: path)
        }
        
        
        playerControlView.delegate = self
        
        player.addSubview(playerControlView)
        
        player.bringSubviewToFront(playerControlView)
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let width = view.frame.size.width
        let height = width/16*9
        
        player = AVPlayerView.init(frame: CGRect.init(x: 0, y: view.frame.size.height/2-height/2, width: width, height: height))
        
        //在影片讀取之前就要把控制UI實作
        playerControlView = PlayerControlView.init(frame: player.bounds)
        
        player.delegate = self
        
        view.addSubview(player)
        
        if let path = video?.sources {
            
            player.setPlayer(urlSting: path)
        }
        
        
        playerControlView.delegate = self
        
        player.addSubview(playerControlView)
        
        player.bringSubviewToFront(playerControlView)
    }
    
    private func setResizedFrame() {
        
        var width = view.frame.size.width
        
        var height = view.frame.size.height
        
        if view.frame.size.width > view.frame.size.height {
            
            width = view.frame.size.height
            
            height = view.frame.size.width
            
        }
        
        if isLandscape {
            
            print("Landscape")
            
            player.frame = CGRect.init(x: 0, y: 0, width: height, height: width)
            
        } else {
            
            print("Portrait")
            
            let playerHeight = width/16*9
            
            player.frame = CGRect.init(x: 0, y: height/2-playerHeight/2, width: width, height: playerHeight)
        }
        
        playerControlView.frame = player.bounds
    }
    
    ///偵測螢幕自動轉向
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        setResizedFrame()
        
        player.resizeSubViews()
        
        playerControlView.setOrientationButtonImage(isLandscape: isLandscape)
    }
    
    //MARK: ----- AVPlayerViewDelegate -----
    func playerDidReceiveFail(_ player:AVPlayerView) {
    
        presentAlert(title: "讀取失敗", message: nil, alertType: .normal, handler: nil)
    }
    
    func didUpdatePlayerCurrentTime(_ player:AVPlayerView, time: Float64) {
        
        playerControlView.updateCurrentTime(time: time)
        
    }
    
    func playerBufferProgress(_ player:AVPlayerView, currentTime: Float64, totalTime: Float64) {
        
        playerControlView.setProcessViewValue(current: currentTime, total: totalTime)
        
    }
    
    func playerDidFinishPlaying(_ player:AVPlayerView) {
        
        print("finish")
        
    }
    
    func playerPlaybackBufferEmpty(_ player: AVPlayerView) {
        
        playerControlView.setIndicator(isLoading: true)
    }
    
    func playerPlaybackLikelyToKeepUp(_ player: AVPlayerView) {
        
        playerControlView.setIndicator(isLoading: false)
    }
    
    func playerPlayAndPause(_ player:AVPlayerView, isPlaying: Bool) {
                
        print("isPlaying",isPlaying)
        
        playerControlView.setPlayButton(isPlaying: isPlaying)
        
        playerControlView.setIndicator(isLoading: false)
    }
    
    func didReceiveTotalDuration(_ player:AVPlayerView, time: Float64) {
    
        print("didReceiveTotalDuration",time)
        
        playerControlView.setTotalTime(time: time)
    
    }
    
    func didTouchPlayer(_ player:AVPlayerView) {
        
        playerControlView.show()
    }
    
    func didRewindOrFastforward(_ player:AVPlayerView) {
        
        player.play()
    }
    
    //MARK: ----- PlayerControlViewDelegate -----
    func playerControlView(_ controlView:PlayerControlView, timeSliderValueChange value: Float) {
        
        print("didChangeCurrentTime")
        
        player.changeCurrentTime(time: value)
    }
    
    func playerControlViewPlayAction(_ controlView: PlayerControlView) {
        
        controlView.setPlayButton(isPlaying: player.isPlaying)
        
        if player.isPlaying {
            
            player.pause()
            
        } else {
            
            player.play()
        }
    }
    
    func playerControlViewFastforward(_ controlView:PlayerControlView) {
        player.fastForward()
    }
    
    
    func playerControlViewRewind(_ controlView:PlayerControlView) {
        player.rewind()
    }
    
    func playerControlViewEndChangeSliderValue(_ controlView:PlayerControlView) {
        player.play()
    }
    
    func playerControlViewOrientationAction(_ controlView:PlayerControlView) {
        
        var value:Int = UIInterfaceOrientation.landscapeLeft.rawValue
        
        if UIApplication.shared.statusBarOrientation == .landscapeLeft ||  UIApplication.shared.statusBarOrientation == .landscapeRight {
            
            value = UIInterfaceOrientation.portrait.rawValue
        }
        
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        player.removeObserver()
        
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        
        print("deinit")
        
    }
}

