//
//  UserDefaultData.swift
//  AVPlayer
//
//  Created by Rex Lin on 2021/3/31.
//  Copyright © 2021 Yu Li Lin. All rights reserved.
//

import UIKit

class UserDefaultData: NSObject {
    class func setHasOpened(isFirst:Bool) {
        UserDefaults.standard.set(isFirst, forKey: "hasOpened")
        UserDefaults.standard.synchronize()
    }
    
    class func getHasOpened() -> Bool? {
        if let savedData = UserDefaults.standard.object(forKey: "hasOpened") as? Bool {
            return savedData
        }
        return nil
    }
}
