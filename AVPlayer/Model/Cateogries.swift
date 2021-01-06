//
//  Cateogries.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/4.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

struct Categories:Codable {
    
    var name:String?
    var videos:[Video] = []
    var count:Int {
        return videos.count
    }
}

extension Categories {
    
    func getVideo(index:Int) -> Video? {
        
        if index < count {
            return videos[index]
        }
        return nil
    }
}


struct Video:Codable {
    
    var description:String?
    var sources:String?
    var subtitle:String?
    var thumb:String?
    var title:String?
}

