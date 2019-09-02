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
    func didReceiveTotalDuration(time:Float64)
    func didTouchPlayer()
}

class AVPlayerView: UIView {

    weak var delegate:AVPlayerViewDelegate?
    
    var player : AVPlayer?
    var avPlayerLayer : AVPlayerLayer!
    var playerItem:AVPlayerItem?
    var asset:AVURLAsset!
    var isPlaying:Bool = false

    var currentSecond:Float64? {
        
        if let time = player?.currentItem?.currentTime() {
            
            return CMTimeGetSeconds(time)
        }
        
        return nil
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    /**
     初始化播放器
     - Parameter urlString: 影片路徑、網址
     */
    func setPlayer(urlSting:String) {
        
        let videoURL =  URL(string: urlSting)!
        
        playerItem = AVPlayerItem(url: videoURL)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)
        
        player = AVPlayer(playerItem: playerItem)
        
        avPlayerLayer = AVPlayerLayer(player: player)
        
        avPlayerLayer.frame = self.bounds
        
        self.layer.addSublayer(avPlayerLayer)
        
        play()
        
        addVideoObserver()
        
        updatePlayerUI()
        
    }
    
    ///直式橫式切換時，更新UI
    func resizeSubViews() {
        
        avPlayerLayer.frame = self.bounds

    }
    
    ///增加播放進度監聽
    func addVideoObserver() {
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
            
            if self.player!.currentItem?.status == .readyToPlay {
                
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                
                self.delegate?.didUpdatePlayerCurrentTime(time: currentTime)
                
            }
        })
    }
    
    ///取得影片長度
    private func updatePlayerUI() {
        
        // 抓取 playItem 的 duration
        let duration = playerItem!.asset.duration
        // 把 duration 轉為我們歌曲的總時間（秒數）。
        let seconds = CMTimeGetSeconds(duration)

        delegate?.didReceiveTotalDuration(time: seconds)
    }
    
    ///影片播放完畢
    @objc func playerDidFinishPlaying() {
        
        pause()
        
        print("Finished")
    }
    
    
    func playAndPause() {
        
        if isPlaying == false {
            
            play()
            
        } else {
            
            pause()
        }
        
        delegate?.playerPlayAndPause(isPlaying: isPlaying)
    }
    
    /**
     
     變更影片播放進度
     
     - Parameter time: 應變更的進度
     */
    func changeCurrentTime(time: Float) {
        
        let seconds = Int64(time)
        
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        // 將當前設置時間設為播放時間
        player?.seek(to: targetTime)
        
    }
    
    ///快轉
    func fastForward() {
     
        if let time = currentSecond {
            
            changeCurrentTime(time: Float(time+5))
        }

    }
    
    ///回放
    func rewind() {
     
        if let time = currentSecond {
            
            changeCurrentTime(time: Float(time-5))
        }
    }
    
    ///播放
    func play() {
        
        isPlaying = true
        
        player?.play()
        
        print("play")
    }
    
    ///暫停
    func pause() {
        
        isPlaying = false
        
        player?.pause()
        
        print("pause")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        delegate?.didTouchPlayer()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
