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

protocol AVPlayerViewDelegate {
    
    /**
     播放器讀取狀態
     */
    func playerLoadStatus(_ player:AVPlayerView, status:AVPlayerView.PlayeLoadStatus)
    
    /**
     更新影片目前時間
     - Parameter time: 目前的時間
     */
    func didUpdatePlayerCurrentTime(_ player:AVPlayerView, time:Float64)
    
    /**
     接收到影片長度
     - Parameter time: 影片長度
     */
    func didReceiveTotalDuration(_ player:AVPlayerView, time:Float64)
        
    /**
     影片緩衝進度
     - Parameter currentTime: 緩衝目前進度
     - Parameter totalTime: 影片總長度
     */
    func playerBufferProgress(_ player:AVPlayerView, currentTime:Float64, totalTime:Float64)
    
    /**
    播放器可以繼續播放
     */
    func playbackLikelyToKeepUp(_ player:AVPlayerView, keepUp:Bool)
    
    /**
    播放器播放狀態有變更
     */
    func playerPlayStatusDidChange(_ player:AVPlayerView, status:AVPlayerView.PlayerPlayStatus)
}

class AVPlayerView: UIView {
    
    enum PlayeLoadStatus {
        case ready
        case fail
    }

    ///播放器裝態監聽的列舉
    enum PlayerObserverKey:String {
        case status
        case loadedTimeRanges
        ///播放器沒有緩衝
        case playbackBufferEmpty
        ///緩衝足夠
        case playbackLikelyToKeepUp
    }
    
    enum PlayerPlayStatus {
        ///播放
        case play
        ///暫停
        case pause
        ///重播
        case replay
        ///播放結束
        case finish
        ///倒轉
        case rewind
        ///快轉
        case fastForward
    }
    
    ///代理
    var delegate:AVPlayerViewDelegate?
    
    ///播放器
    var player : AVPlayer?
    
    ///播放影片時所需定義的畫面介面
    var avPlayerLayer : AVPlayerLayer!
    
    ///影片播放的元素（可以更深入取得影片細部資訊）
    var playerItem:AVPlayerItem?
    
    ///是否正在播放
    var isPlaying:Bool = false
    
    ///定期時間觀察者
    var timeObserverToken: Any?
    
    ///目前播放的時間
    var currentSecond:Float64? {
        if let time = player?.currentItem?.currentTime() {
            return CMTimeGetSeconds(time)
        }
        
        return nil
    }
    /*
    var videoSize:CGSize {
        if let item = player?.currentItem {
            return item.presentationSize
        } else {
            return .zero
        }
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
    }
    
    /**
     初始化播放器
     - Parameter urlString: 影片路徑、網址
     */
    func setPlayer(urlSting:String) {
        //AVPlayerItem設定影片路徑->AVPlayerItem影片播放元素給AVPlayer初始化->交給AVPLayerLayer設定播放畫面
        
        if let videoURL =  URL(string: urlSting) {
            playerItem = AVPlayerItem(url: videoURL)
            
            player = AVPlayer(playerItem: playerItem)
            
            avPlayerLayer = AVPlayerLayer(player: player)
            avPlayerLayer.frame = self.bounds
            self.layer.addSublayer(avPlayerLayer)
            
            addVideoObserver()
            updatePlayerUI()
            
            //監聽播放結束
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            
            //以下為監聽播放器狀態
            player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.status.rawValue, options: .new, context: nil)
            //緩衝，可用來獲取快取存了多少
            player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.loadedTimeRanges.rawValue, options: .new, context: nil)
            //緩衝不夠，停止播放
            player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.playbackBufferEmpty.rawValue, options: .new, context: nil)
            //緩衝足夠，手動播放
            player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey.playbackLikelyToKeepUp.rawValue, options: .new, context: nil)
        }
                
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == PlayerObserverKey.status.rawValue {
            if let item:AVPlayerItem = object as? AVPlayerItem {
                if item.status == .readyToPlay {
                    delegate?.playerLoadStatus(self, status: .ready)
                } else if item.status == .failed {
                    delegate?.playerLoadStatus(self, status: .fail)
                    print("AVPlayerStatusFailed")
                } else {
                    delegate?.playerLoadStatus(self, status: .fail)
                    print("AVPlayerStatusUnknown")
                }
            }
        
        } else if keyPath == PlayerObserverKey.loadedTimeRanges.rawValue {
            setPlayerBuffer()
            
        } else if keyPath == PlayerObserverKey.playbackBufferEmpty.rawValue {
            
        } else if keyPath == PlayerObserverKey.playbackLikelyToKeepUp.rawValue {
                        
            if let keepUp = playerItem?.isPlaybackLikelyToKeepUp {
                delegate?.playbackLikelyToKeepUp(self, keepUp: keepUp)
            }
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
            let loadTimeArray = item.loadedTimeRanges
            if let newTimeRange : CMTimeRange = loadTimeArray.first as? CMTimeRange {
                let startSeconds = CMTimeGetSeconds(newTimeRange.start)
                let durationSeconds = CMTimeGetSeconds(newTimeRange.duration)
                let totalBuffer = startSeconds + durationSeconds//緩衝長度
                
                delegate?.playerBufferProgress(self, currentTime: totalBuffer, totalTime: CMTimeGetSeconds(item.asset.duration))
            }
        }
    }
    
    ///直式橫式切換時，更新UI
    func resizeSubViews() {
        avPlayerLayer.frame = self.bounds
    }
    
    ///增加播放進度監聽
    func addVideoObserver() {
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main, using: { (CMTime) in

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
        delegate?.playerPlayStatusDidChange(self, status: .finish)
    }
    
    /**
     變更影片播放進度
     - Parameter time: 變更的進度
     */
    func changeCurrentTime(time: Float) {
        
        let seconds = Int64(time)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        // 將當前設置時間設為播放時間
        player?.seek(to: targetTime)
        pause()
    }
    
    ///快轉
    func fastForward(shiftTime:Int) {
        if let time = currentSecond {
            changeCurrentTime(time: Float(time)+Float(shiftTime))
            delegate?.playerPlayStatusDidChange(self, status: .fastForward)
        }
    }
    
    ///回放
    func rewind(shiftTime:Int) {
        if let time = currentSecond {
            changeCurrentTime(time: Float(time)-Float(shiftTime))
            delegate?.playerPlayStatusDidChange(self, status: .rewind)
        }
    }
    
    ///播放
    func play() {
        isPlaying = true
        player?.play()
        delegate?.playerPlayStatusDidChange(self, status: .play)
        print("play")
    }
    
    ///暫停
    func pause() {
        
        isPlaying = false
        player?.pause()
        delegate?.playerPlayStatusDidChange(self, status: .pause)
        print("pause")
    }
    
    func replay() {
        isPlaying = true
        changeCurrentTime(time: 0)
        player?.play()
        delegate?.playerPlayStatusDidChange(self, status: .replay)
        print("replay")
    }
    
    func removeObserver() {               
        
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        player = nil
        
        if avPlayerLayer != nil {
            avPlayerLayer.removeFromSuperlayer()
            avPlayerLayer = nil
        }
    }
    
    deinit {
        removeObserver()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
