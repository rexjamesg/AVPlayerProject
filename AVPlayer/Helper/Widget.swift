//
//  Widget.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/2.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit


class Widget: NSObject {
    
    /**
     影片時間轉為分:秒
     - Parameter time: 要轉換的時間
     */
    class func formatConversion(time:Float64) -> String {
        
        let length = Int(time)
        let minutes = Int(length / 60) // 求 length 的商，為分鐘數
        let seconds = Int(length % 60) // 求 length 的餘數，為秒數
        
        var time = ""
        
        if minutes < 10 {
            time = "0\(minutes):"
        } else {
            time = "\(minutes):"
        }
        
        if seconds < 10 {
            time += "0\(seconds)"
        } else {
            time += "\(seconds)"
        }
        
        return time
    }

}
