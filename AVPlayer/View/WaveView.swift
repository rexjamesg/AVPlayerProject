//
//  WaveView.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/6.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

class WaveView: UIView, CAAnimationDelegate {
    
    var pulseLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    class func waveAnimate(view:UIView, position:CGPoint) {
        
        let waveView = WaveView.init(frame: CGRect.init(x: position.x, y: position.y, width: view.frame.size.width, height: view.frame.size.width))
        view.addSubview(waveView)        
        waveView.createPulse()
    }
    
    private func createPulse() {
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: self.frame.size.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 2.0
        pulseLayer.fillColor = UIColor.white.cgColor
        pulseLayer.lineCap = CAShapeLayerLineCap.round
        pulseLayer.position = CGPoint(x: 0, y: 0)
        self.layer.addSublayer(pulseLayer)
        
        animatePulsatingLayerAt()
    }
    
    private func animatePulsatingLayerAt() {
        
        //設定動畫顏色
        pulseLayer.strokeColor = UIColor.darkGray.cgColor
        
        //設定動畫的縮放大小 fromValue＆toValue 介於 0.0~1.0
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        
        
        //設定動畫的不透明度 fromValue＆toValue 介於 0.0~1.0
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        
        
        //Grouping both animations and giving animation duration, animation repat count
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 0.5
        //動畫循環
        //groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        groupAnimation.delegate = self
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        
        //將 groupanimation 加入至圖層
        pulseLayer.add(groupAnimation, forKey: "groupanimation")
    }
    
    //MARK: -----  CAAnimationDelegate -----
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.removeFromSuperview()
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
