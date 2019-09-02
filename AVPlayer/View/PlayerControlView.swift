//
//  PlayerControlView.swift
//  AVPlayerProject
//
//  Created by Yu Li Lin on 2019/8/29.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

protocol PlayerControlViewDelegate:class {
    
    func didChangeCurrentTime(value:Float)
    func playAction()
    func playerControlForward()
    func playerControlRewind()
    func orientationAction()
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

            setDisplayTimer()
            
        } catch {
            
            print("error:\(error)")
        }
        
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
    
    /**
     更新影片目前時間
     - Parameter time: 影片目前時間
     */
    func updateCurrentTime(time:Float64) {
        
        currentimLabel.text = Widget.formatConversion(time: time)
        
        //print("time",time)
        
        durationSlider.value = Float(time)/100
        
    }
    
    /**
     設定影片長度
     
     - Parameter time: 影片總長度
     
     */
    func setTotalTime(time:Float64) {
                
        totalTimeLabel.text = Widget.formatConversion(time: time)
        
        //durationSlider.minimumValue = 0
        
        //durationSlider.maximumValue = Float(time)
        
        durationSlider.value = 0
        
        durationSlider.isContinuous = true
        
    }
    
    ///選擇影片目前時間
    @IBAction func currentTimeSliderAction(_ sender: Any) {
        
        if let slider = sender as? UISlider {
            
            delegate?.didChangeCurrentTime(value: slider.value*100)
            
        }
    }
    
    ///直式橫式切換
    @IBAction func orientationAction(_ sender: Any) {
     
        delegate?.orientationAction()
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
     
     - Parameter isPlaying:是諷正在播放影片
     
     */
    func setPlayButton(isPlaying:Bool) {
        
        if isPlaying {
            
            playButton.setImage(pauseImage, for: .normal)
            
            setDisplayTimer()
            
        } else {
            
            playButton.setImage(playImage, for: .normal)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let _ = touches.first?.location(in: baseView) {
            
            hide()
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
