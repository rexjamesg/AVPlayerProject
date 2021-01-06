//
//  GlobalParameters.swift
//  AVPlayer
//
//  Created by Rex Lin on 2021/1/6.
//  Copyright © 2021 Yu Li Lin. All rights reserved.
//

import UIKit

var window:UIWindow? {
    return UIApplication.shared.delegate?.window ?? nil
}

let TOP_PADDING:CGFloat = window?.safeAreaInsets.top ?? 0
let BOTTOM_PADDING:CGFloat = window?.safeAreaInsets.bottom ?? 0
