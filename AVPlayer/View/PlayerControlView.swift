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
    func didChangeCurrentTime(value:Float)
    
    ///播放按鈕功能
    func playAction()
    
    ///快轉
    func playerControlForward()
    
    ///回放
    func playerControlRewind()
    
    ///橫式直式切換
    func orientationAction()
    
    ///手指離開滑桿
    func didEndChangeSliderValue()
}

@IBDesignable
class PlayerControlView: UIView {

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
    
    private var pauseImage:UIImage = UIImage.init(named: "baseline_pause_white")!
    private var playImage:UIImage = UIImage.init(named: "baseline_play_arrow_white")!
    private var fullScreenImage:UIImage = UIImage.init(named: "baseline_fullscreen_white")!
    private var fullScreenExitImage:UIImage = UIImage.init(named: "baseline_fullscreen_exit_white")!
    
    private var displayTimer:Timer?
    
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
        
        if isLandscape {
            
            orientationButton.setImage(fullScreenExitImage, for: .normal)
            
        } else {
            
            orientationButton.setImage(fullScreenImage, for: .normal)
        }
        
        setDisplayTimer()
    }
    
    /**
     設定播放鈕圖示
     - Parameter isPlaying:是否正在播放影片
     */
    func setPlayButton(isPlaying:Bool) {
        
        if isPlaying {
            
            playButton.setImage(pauseImage, for: .normal)
            
            setDisplayTimer()
            
        } else {
            
            playButton.setImage(playImage, for: .normal)
        }
        
    }
    
    ///隱藏播放控制view
    private func hide() {
        
        UIView.animate(withDuration: 0.3) {
            
            self.alpha = 0
        }
    }
    
    ///顯示播放view
    func show() {
        
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
    
    ///選擇影片目前時間
    @IBAction func currentTimeSliderAction(_ sender: Any) {
        
        if let slider = sender as? UISlider {
            
            displayTimer?.invalidate()
            
            delegate?.didChangeCurrentTime(value: slider.value)
            
        }
    }
    
    ///直式橫式切換
    @IBAction func orientationAction(_ sender: Any) {
        
        delegate?.orientationAction()
    }
    
    @IBAction func sliderEndChangeInside(_ sender: Any) {
        
        print("end")
        
        setDisplayTimer()
        
        delegate?.didEndChangeSliderValue()
    }
    
    @IBAction func sliderEndChangeOutside(_ sender: Any) {
        
        print("end")
        
        setDisplayTimer()
        
        delegate?.didEndChangeSliderValue()
        
    }
    
    ///播放
    @IBAction func playAction(_ sender: Any) {
        
        print("playAction")
        
        delegate?.playAction()
    }
    
    ///快轉
    @IBAction func fastForwardAction(_ sender: Any) {
        
        print("fastForwardAction")
        
        setDisplayTimer()
        
        delegate?.playerControlForward()
    }
    
    ///回放
    @IBAction func rewindAction(_ sender: Any) {
        
        print("rewindAction")
        
        setDisplayTimer()
        
        delegate?.playerControlRewind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let _ = touches.first?.location(in: baseView) {
            
            hide()
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
