//
//  PlayerControlView.swift
//  AVPlayerProject
//
//  Created by Yu Li Lin on 2019/8/29.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

@IBDesignable
class PlayerControlView: UIView {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var currentimLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!

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
            
        } catch {
            
            print("error:\(error)")
        }
        
    }
    
    @IBAction func playAction(_ sender: Any) {
        print("playAction")
    }
    
    @IBAction func fastForwardAction(_ sender: Any) {
        
        print("fastForwardAction")
    }
    
    @IBAction func rewindAction(_ sender: Any) {
        print("rewindAction")
    }
    
    func updateCurrentTime(time:String) {
        
        currentimLabel.text = time
    }
    
    func setTotalTime(time:String) {
        
        totalTimeLabel.text = time
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
