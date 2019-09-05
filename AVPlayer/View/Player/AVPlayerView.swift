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
    
    /**
     更新影片目前時間
     - Parameter time: 目前的時間
     */
    func didUpdatePlayerCurrentTime(_ player:AVPlayerView, time:Float64)
    
    ///播放完畢
    func playerDidFinishPlaying(_ player:AVPlayerView)
    
    /**
     開始與結束播放
     - Parameter isPlaying: 是否正在播放
     */
    func playerPlayAndPause(_ player:AVPlayerView, isPlaying:Bool)
    
    /**
     接收到影片長度
     - Parameter time: 影片長度
     */
    func didReceiveTotalDuration(_ player:AVPlayerView, time:Float64)
    
    ///觸摸播放器圖層
    func didTouchPlayer(_ player:AVPlayerView)
    
    ///播放失敗
    func playerDidReceiveFail(_ player:AVPlayerView)
    
    /**
     影片緩衝進度
     - Parameter currentTime: 緩衝目前進度
     - Parameter totalTime: 影片總長度
     */
    func playerBufferProgress(_ player:AVPlayerView, currentTime:Float64, totalTime:Float64)
    
    ///快轉或倒轉
    func didRewindOrFastforward(_ player:AVPlayerView)
    
    
    ///播放器沒有緩衝
    func playerPlaybackBufferEmpty(_ player:AVPlayerView)
    
    ///緩衝足夠
    func playerPlaybackLikelyToKeepUp(_ player:AVPlayerView)
}

class AVPlayerView: UIView {

    enum PlayerObserverKey:String {
        case status
        case loadedTimeRanges
        case playbackBufferEmpty
        case playbackLikelyToKeepUp
    }
    
    weak var delegate:AVPlayerViewDelegate?
    
    var player : AVPlayer?
    var avPlayerLayer : AVPlayerLayer!
    var playerItem:AVPlayerItem?
    var asset:AVURLAsset!
    var isPlaying:Bool = false

    private var playerItemContext = 0

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
        
        
        player = AVPlayer(playerItem: playerItem)
        
        avPlayerLayer = AVPlayerLayer(player: player)
        
        avPlayerLayer.frame = self.bounds
        
        self.layer.addSublayer(avPlayerLayer)
        
        addVideoObserver()
        
        updatePlayerUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.status.rawValue, options: .new, context: nil)
        //緩衝，可用來獲取快取存了多少
        player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.loadedTimeRanges.rawValue, options: .new, context: nil)
        //緩衝不夠，停止播放
        player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.playbackBufferEmpty.rawValue, options: .new, context: nil)
        
        //緩衝足夠，手動播放
        player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.playbackLikelyToKeepUp.rawValue, options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == PlayerObserverKey.status.rawValue {
            
            if let item:AVPlayerItem = object as? AVPlayerItem {
             
                if item.status == .readyToPlay {
                    
                    play()
                    
                    print("ready")
                    
                } else if item.status == .failed {
                    
                    pause()
                    
                    delegate?.playerDidReceiveFail(self)
                    
                    print("AVPlayerStatusFailed")
                    
                } else {
                    
                    delegate?.playerDidReceiveFail(self)
                    
                    print("AVPlayerStatusUnknown")
                }
            }
        
        } else if keyPath == PlayerObserverKey.loadedTimeRanges.rawValue {
            
            setPlayerBuffer()
            
        } else if keyPath == PlayerObserverKey.playbackBufferEmpty.rawValue {
            
            print("playbackBufferEmpty")
            
            delegate?.playerPlaybackBufferEmpty(self)
            
        } else if keyPath == PlayerObserverKey.playbackLikelyToKeepUp.rawValue {
            
            print("playbackLikelyToKeepUp")
            
            delegate?.playerPlaybackLikelyToKeepUp(self)
            
        }
    }
    
    private func availableDuration() -> CMTime {
        
        if let range = self.player?.currentItem?.loadedTimeRanges.first {
            return CMTimeRangeGetEnd(range.timeRangeValue)
        }
        return .zero
    }
    
    private func setPlayerBuffer() {
        
        if let item = playerItem {
         
            //print("xxxx",CMTimeShow(availableDuration()))
            
            let loadTimeArray = item.loadedTimeRanges
            
            //取得緩衝區間
            if let newTimeRange : CMTimeRange = loadTimeArray.first as? CMTimeRange {
                
                let startSeconds = CMTimeGetSeconds(newTimeRange.start)
                let durationSeconds = CMTimeGetSeconds(newTimeRange.duration)
                let totalBuffer = startSeconds + durationSeconds//緩衝長度
                
                delegate?.playerBufferProgress(self, currentTime: totalBuffer, totalTime: CMTimeGetSeconds(item.asset.duration))
                
                //print("當前緩衝時間",totalBuffer)
            }
        }
    }
    
    ///直式橫式切換時，更新UI
    func resizeSubViews() {
        
        avPlayerLayer.frame = self.bounds

    }
    
    ///增加播放進度監聽
    func addVideoObserver() {
        
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main, using: { (CMTime) in

            if self.player!.currentItem?.status == .readyToPlay {
                
                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                
                self.delegate?.didUpdatePlayerCurrentTime(self, time: currentTime)
            }
        })
    }
    
    ///取得影片長度
    private func updatePlayerUI() {
        
        //抓取 playItem 的 duration
        let duration = playerItem!.asset.duration
        //把 duration 轉為影片的總時間（秒數）。
        let seconds = CMTimeGetSeconds(duration)

        delegate?.didReceiveTotalDuration(self, time: seconds)
    }
    
    ///影片播放完畢
    @objc func playerDidFinishPlaying() {
        
        pause()
        
        print("Finished")
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
        
        pause()
    }
    
    ///快轉
    func fastForward() {
     
        if let time = currentSecond {
            
            changeCurrentTime(time: Float(time+5))
            
            delegate?.didRewindOrFastforward(self)
        }
    }
    
    ///回放
    func rewind() {
     
        if let time = currentSecond {
            
            changeCurrentTime(time: Float(time-5))
            
            delegate?.didRewindOrFastforward(self)
        }
    }
    
    ///播放
    func play() {
        
        isPlaying = true
        
        player?.play()
        
        delegate?.playerPlayAndPause(self, isPlaying: isPlaying)
        
        print("play")
    }
    
    ///暫停
    func pause() {
        
        isPlaying = false
        
        player?.pause()
        
        delegate?.playerPlayAndPause(self, isPlaying: isPlaying)
        
        print("pause")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        delegate?.didTouchPlayer(self)
    }
    
    func removeObserver() {
        
        /*
        NotificationCenter.default.removeObserver(self, forKeyPath: NSNotification.Name.AVPlayerItemDidPlayToEndTime.rawValue)
        
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey.status.rawValue)
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey.loadedTimeRanges.rawValue)
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey.playbackBufferEmpty.rawValue)
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey.playbackLikelyToKeepUp.rawValue)
        
        player?.removeTimeObserver(self)
        */
        if avPlayerLayer != nil {
            
            avPlayerLayer.removeFromSuperlayer()
            avPlayerLayer = nil
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
