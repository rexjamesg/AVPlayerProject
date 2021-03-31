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

class PlayerViewController: BaseViewController {

    var player:AVPlayerView = AVPlayerView()    //播放器影片圖層
    var playerControlView:PlayerControlView = PlayerControlView()   //播放器控制圖層
    var playerCoverView:UIView = UIView()       //播放器的遮罩
    let totalPadding:CGFloat = TOP_PADDING+BOTTOM_PADDING
    var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
    var timeShift:Int = 5
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var isLandscape:Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    var video:Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     
        AppDelegate.AppUtility.lockOrientation(.allButUpsideDown)
        
        indicatorView.startAnimating()
        indicatorView.center = view.center
        view.addSubview(indicatorView)                
        
        DispatchQueue.main.async {
            self.setplayer()
            self.setTapGestures()
            self.displayControlIntro()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    private func setplayer() {
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
        
        initPlayerCoverView()
        
        playerControlView.delegate = self
        player.addSubview(playerControlView)
        player.bringSubviewToFront(playerControlView)
    }
    
    private func initPlayerCoverView() {
        playerCoverView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: player.frame.size.width, height: player.frame.size.height))
        playerCoverView.backgroundColor = .black
        playerCoverView.alpha = 0.3
        player.addSubview(playerCoverView)
    }
    
    private func setTapGestures() {
        
        //player
        let playerSingleTap = UITapGestureRecognizer(target: self, action: #selector(playerSingleTapAction))
        playerSingleTap.numberOfTapsRequired = 1
        player.addGestureRecognizer(playerSingleTap)
        
        let playerDoubleTap = UITapGestureRecognizer(target: self, action: #selector(playerDoubleTapAction(sender:)))
        playerDoubleTap.numberOfTapsRequired = 2
        player.addGestureRecognizer(playerDoubleTap)
        
        playerSingleTap.require(toFail: playerDoubleTap)
        
        //player Control
        let playerControlSingleTap = UITapGestureRecognizer(target: self, action: #selector(playerControlSingleTapAction))
        playerControlSingleTap.numberOfTapsRequired = 1
        playerControlView.addGestureRecognizer(playerControlSingleTap)
        
        let playerControlDoubleTap = UITapGestureRecognizer(target: self, action: #selector(playerControlDoubleTapAction(sender:)))
        playerControlDoubleTap.numberOfTapsRequired = 2
        playerControlView.addGestureRecognizer(playerControlDoubleTap)
        
        playerControlSingleTap.require(toFail: playerControlDoubleTap)
    }

    private func displayControlIntro(force:Bool=false) {
                
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        
        if let avPlayerIntroViewController = main.instantiateViewController(withIdentifier: "AVPlayerIntroViewController") as? AVPlayerIntroViewController  {
            
            avPlayerIntroViewController.modalPresentationStyle = .fullScreen
            
            let hasOpened = UserDefaultData.getHasOpened() ?? false
            
            if force {
                player.pause()
                present(avPlayerIntroViewController, animated: true, completion: nil)
            } else {
                if !hasOpened {
                    player.pause()
                    present(avPlayerIntroViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func playerSingleTapAction () {
        playerControlView.show()
    }
    
    @objc private func playerDoubleTapAction (sender:UITapGestureRecognizer) {
        doubleTapAction(sender: sender)
    }
    
    @objc private func playerControlSingleTapAction () {
        playerControlView.hide()
    }
    
    @objc private func playerControlDoubleTapAction (sender:UITapGestureRecognizer) {
        doubleTapAction(sender: sender)
    }
    
    private func doubleTapAction(sender:UITapGestureRecognizer) {
        let point = sender.location(in: view)
        if point.x > view.frame.size.width/2 {
            WaveView.waveAnimate(view: player, position: CGPoint.init(x: player.frame.size.width/4*3, y: player.frame.size.height/2))
            player.fastForward(shiftTime: timeShift)
        } else {
            WaveView.waveAnimate(view: player, position: CGPoint.init(x: player.frame.size.width/4, y: player.frame.size.height/2))
            player.rewind(shiftTime: timeShift)
        }
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
            playerCoverView.frame = CGRect.init(x: 0, y: 0, width: height, height: width)
            playerControlView.frame = CGRect.init(x: 0, y: 0, width: height-TOP_PADDING, height: width-BOTTOM_PADDING)
            playerControlView.center = player.center
        } else {
            print("Portrait")
            let playerHeight = width/16*9
            player.frame = CGRect.init(x: 0, y: height/2-playerHeight/2, width: width, height: playerHeight)
            playerCoverView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
            playerControlView.frame = CGRect.init(x: 0, y: 0, width: player.frame.size.width, height: player.frame.size.height)
        }
    }
    
    ///偵測螢幕自動轉向
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        setResizedFrame()
        player.resizeSubViews()
        playerControlView.setOrientationButtonImage(isLandscape: isLandscape)
    }
    
    @IBAction func backAction(_ sender: Any) {
        player.removeObserver()
        dismiss(animated: true, completion: nil)
    }
    
    private func setPlayControlView(isPlaying: Bool) {
        print("isPlaying",isPlaying)
        playerControlView.setPlayButton(isPlaying: isPlaying)
        playerControlView.setIndicator(isLoading: false)
    }
    
    @IBAction func infoAction(_ sender: Any) {
        displayControlIntro(force: true)
    }
    
    deinit {
        print("deinit")
        player.removeFromSuperview()
    }
}

//MARK: ----- AVPlayerViewDelegate -----
extension PlayerViewController: AVPlayerViewDelegate {
    
    func playerLoadStatus(_ player: AVPlayerView, status: AVPlayerView.PlayeLoadStatus) {
        switch status {
        case .ready:
            player.play()
            break
            
        case .fail:
            player.pause()
            presentAlert(title: "讀取失敗", message: nil, alertType: .normal, handler: nil)
            break
        
        }
    }

    func didUpdatePlayerCurrentTime(_ player:AVPlayerView, time: Float64) {
        playerControlView.updateCurrentTime(time: time)
    }

    func playerBufferProgress(_ player:AVPlayerView, currentTime: Float64, totalTime: Float64) {
        playerControlView.setProcessViewValue(current: currentTime, total: totalTime)
    }

    
    func playbackLikelyToKeepUp(_ player: AVPlayerView, keepUp: Bool) {
        playerControlView.setIndicator(isLoading: !keepUp)
    }
    
    func playerPlayStatusDidChange(_ player: AVPlayerView, status: AVPlayerView.PlayerPlayStatus) {
        switch status {
        case .play:
            setPlayControlView(isPlaying: true)
            break
            
        case .pause:
            setPlayControlView(isPlaying: false)
            break
            
        case .replay:
            break
            
        case .finish:
            playerControlView.show()
            playerControlView.setReplayButton()
            print("finish")
            break
            
        case .rewind:
            player.play()
            break
            
        case .fastForward:
            player.play()
            break
        }
    }
    /*
    func playerDidFinishPlaying(_ player:AVPlayerView) {
        playerControlView.show()
        playerControlView.setReplayButton()
        print("finish")
    }
    */
    
    /*
    func playerPlaybackBufferEmpty(_ player: AVPlayerView) {
        playerControlView.setIndicator(isLoading: true)
    }
     */
    
    /*
    func playerPlaybackLikelyToKeepUp(_ player: AVPlayerView) {
        playerControlView.setIndicator(isLoading: false)
    }
     */
    
    /*
    func playerPlayAndPause(_ player:AVPlayerView, isPlaying: Bool) {
        print("isPlaying",isPlaying)
        playerControlView.setPlayButton(isPlaying: isPlaying)
        playerControlView.setIndicator(isLoading: false)
    }
     */
    
    func didReceiveTotalDuration(_ player:AVPlayerView, time: Float64) {
        print("didReceiveTotalDuration",time)
        playerControlView.setTotalTime(time: time)
    }

    /*
    func didTouchPlayer(_ player:AVPlayerView) {
        playerControlView.show()
    }
    */
    
    /*
    func didRewindOrFastforward(_ player:AVPlayerView) {
        player.play()
    }
    */
}

//MARK: - PlayerControlViewDelegate
extension PlayerViewController: PlayerControlViewDelegate {

    func playerControlViewDidChange(_ controlView:PlayerControlView, status: PlayerControlView.PlayrControlStatus) {
        switch status {
        case .play:
            controlView.setPlayButton(isPlaying: player.isPlaying)
            
            if player.isPlaying {
                player.pause()
            } else {
                player.play()
            }
            break
            
        case .pause:
            break
            
        case .fastforward:
            player.fastForward(shiftTime: timeShift)
            break
            
        case .rewind:
            player.rewind(shiftTime: timeShift)
            break
            
        case .playerControlViewEndChangeSliderValue:
            player.play()
            break
            
        case .OrientationAction:
            var value:Int = UIInterfaceOrientation.landscapeLeft.rawValue
            
            if UIApplication.shared.statusBarOrientation == .landscapeLeft ||  UIApplication.shared.statusBarOrientation == .landscapeRight {
                
                value = UIInterfaceOrientation.portrait.rawValue
            }
            
            UIDevice.current.setValue(value, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
            break
            
        case .replay:
            player.replay()
            break
        }
    }
    
    
    func playerControlView(isDisplayContolView: Bool) {
         
        var viewAlpha:CGFloat = 0
        if isDisplayContolView {
            viewAlpha = 0.3
        }
        
        UIView.animate(withDuration: 0.3) {
            self.playerCoverView.alpha = viewAlpha
        }
    }
    
    func playerControlView(_ controlView:PlayerControlView, timeSliderValueChange value: Float) {
        print("didChangeCurrentTime")
        player.changeCurrentTime(time: value)
    }
}

