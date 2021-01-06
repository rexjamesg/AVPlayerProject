//
//  PlayerControlView.swift
//  AVPlayerProject
//
//  Created by Yu Li Lin on 2019/8/29.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

protocol PlayerControlViewDelegate:class {
    
    /**
     滑桿變更影片目前時間
     - Parameter value:變更的時間
     */
    func playerControlView(_ controlView:PlayerControlView, timeSliderValueChange value:Float)
    /**
     播放器控制列狀態
     - Parameter isDisplayContolView: 顯示/隱藏
     */
    func playerControlView(isDisplayContolView:Bool)
    /**
     - Parameter controlView: 播放控制器
     - Parameter status: 變更的狀態
     */
    func playerControlViewDidChange(_ controlView:PlayerControlView, status:PlayerControlView.PlayrControlStatus)
}

@IBDesignable
class PlayerControlView: UIView {
    
    enum PlayrControlStatus {
        ///播放
        case play
        ///暫停
        case pause
        ///快轉
        case fastforward
        ///倒轉
        case rewind
        ///重播
        case replay
        ///橫式/直式
        case OrientationAction
        ///調整滑桿進度
        case playerControlViewEndChangeSliderValue
    }
    
    enum ControlViewImage: String {
        case pause = "baseline_pause_white"
        case play = "baseline_play_arrow_white"
        case replay = "round_replay_white"
        case fullScreen = "baseline_fullscreen_white"
        case fullScreenExit = "baseline_fullscreen_exit_white"
    }

    weak var delegate:PlayerControlViewDelegate?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var currentimLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var orientationButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var playerProgressView: UIProgressView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var controlStackView: UIStackView!
    
    private var displayTimer:Timer?
    private var shouldReplay:Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetUp()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        xibSetUp()
    }
    
    func xibSetUp() {
        
        do {
            let view = try loadNib(nibName: "PlayerControlView")
            addSubview(view)
            
            if let thumbImage:UIImage = UIImage(named: "sliderThumb") {
                durationSlider.setThumbImage(thumbImage, for: .normal )
            }
            
            setDisplayTimer()
            
        } catch {
            print("error:\(error)")
        }
    }
    
    private func imageGenerator(controlViewImage:ControlViewImage) -> UIImage? {
        return UIImage.init(named: controlViewImage.rawValue)
    }
    
    /**
     更新影片目前時間
     - Parameter time: 影片目前時間
     */
    func updateCurrentTime(time:Float64) {
        currentimLabel.text = Widget.formatConversion(time: time)        
        durationSlider.value = Float(time)
    }
    
    /**
     設定影片長度滑桿最大值
     - Parameter time: 影片總長度
     */
    func setTotalTime(time:Float64) {
                
        totalTimeLabel.text = Widget.formatConversion(time: time)
        durationSlider.minimumValue = 0
        durationSlider.maximumValue = Float(time)
        durationSlider.value = 0
        durationSlider.isContinuous = true
        
        print("durationSlider.maximumValue",durationSlider.maximumValue)
    }
    
    /**
     設定緩衝進度條
     - Parameter current:目前進度
     - Parameter total:總進度
     */
    func setProcessViewValue(current:Float64, total:Float64) {
     
        let progress:Float = Float(current/total)
        playerProgressView.setProgress(progress, animated: false)
    }
    
    /**
     設定直式橫式按鈕圖示
     - Parameter isLandscape: 是否為橫式
     */
    func setOrientationButtonImage(isLandscape:Bool) {
        
        var image = imageGenerator(controlViewImage: .fullScreen)
        
        if isLandscape {
            image = imageGenerator(controlViewImage: .fullScreenExit)
        }
        
        orientationButton.setImage(image, for: .normal)
        setDisplayTimer()
    }
    
    /**
     設定播放鈕圖示
     - Parameter isPlaying:是否正在播放影片
     */
    func setPlayButton(isPlaying:Bool) {
        
        var title = "播放"
        var image = imageGenerator(controlViewImage: .play)
        
        if isPlaying {
            title = "暫停"
            image = imageGenerator(controlViewImage: .pause)
            
            setDisplayTimer()
        }
        
        playButton.setTitle(title, for: .normal)
        playButton.setImage(image, for: .normal)
        
    }
    
    func setReplayButton() {
        shouldReplay = true
        playButton.setTitle("重播", for: .normal)
        playButton.setImage(imageGenerator(controlViewImage: .replay), for: .normal)
    }
    
    ///隱藏播放控制view
    func hide() {
        delegate?.playerControlView(isDisplayContolView: false)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    ///顯示播放view
    func show() {
        delegate?.playerControlView(isDisplayContolView: true)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    ///設定自動隱藏播放UI
    private func setDisplayTimer() {
        
        displayTimer?.invalidate()
        displayTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.hide()
            self.displayTimer?.invalidate()
        })
    }
    
    func setIndicator(isLoading:Bool) {
        
        if isLoading {            
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    ///選擇影片目前時間
    @IBAction func currentTimeSliderAction(_ sender: Any) {
        
        if let slider = sender as? UISlider {
            displayTimer?.invalidate()
            delegate?.playerControlView(self, timeSliderValueChange: slider.value)
        }
    }
    
    ///直式橫式切換
    @IBAction func orientationAction(_ sender: Any) {
                
        delegate?.playerControlViewDidChange(self, status: .OrientationAction)
    }
    
    @IBAction func sliderEndChangeInside(_ sender: Any) {
        
        print("end")
        setDisplayTimer()
        delegate?.playerControlViewDidChange(self, status: .playerControlViewEndChangeSliderValue)
    }
    
    @IBAction func sliderEndChangeOutside(_ sender: Any) {
        
        print("end")
        setDisplayTimer()
        delegate?.playerControlViewDidChange(self, status: .playerControlViewEndChangeSliderValue)
    }
    
    ///播放
    @IBAction func playAction(_ sender: Any) {
        
        print("playAction")
        
        if shouldReplay {
            delegate?.playerControlViewDidChange(self, status: .replay)
        } else {
            delegate?.playerControlViewDidChange(self, status: .play)
        }
    }
    
    ///快轉
    @IBAction func fastForwardAction(_ sender: Any) {
        
        print("fastForwardAction")        
        setDisplayTimer()
        delegate?.playerControlViewDidChange(self, status: .fastforward)
    }
    
    ///回放
    @IBAction func rewindAction(_ sender: Any) {
        
        print("rewindAction")
        setDisplayTimer()
        delegate?.playerControlViewDidChange(self, status: .rewind)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
