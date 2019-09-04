//
//  UICollectionViewCellExtension.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/4.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

extension MovieListCell {
    
    func selectedAnimation(finished:@escaping ()->Void) {
        
        self.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }) { (bool) in
            
            finished()
        }
    }
}
