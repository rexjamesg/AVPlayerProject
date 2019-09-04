//
//  UIViewExtension.swift
//  CatNovel
//
//  Created by Yu Li Lin on 2019/8/13.
//  Copyright © 2019 CatNovel. All rights reserved.
//

import UIKit

extension UIView {
    
    
    func setRadius() {
        
        layer.borderWidth = 1.0
        
        layer.borderColor = UIColor.clear.cgColor
        
        layer.cornerRadius = 5.0
        
    }
    
    func setCornerRadius(value:CGFloat) {
        
        layer.cornerRadius = value
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        
    }
    
    //MARK: ----- 設定圓角 -----
    func setRoundRect(conrers:UIRectCorner, cornerRadius:CGFloat) {
        
        /*
         let rectShape = CAShapeLayer()
         
         bounds = frame
         rectShape.position = center
         rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: conrers, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
         layer.mask = rectShape
         */
        
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: conrers, cornerRadii:CGSize.init(width:cornerRadius, height:cornerRadius))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = maskPath.cgPath
        
        layer.mask = maskLayer //設定圓角
    }
    
    func setViewShadow() {
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        
    }

    //讀取xib
    func loadNib(nibName:String) throws -> UIView {
        
        enum LoadNibError:Error {
            
            case unknowError
            
        }
        
        guard let view = UINib(nibName: nibName, bundle: Bundle.init(for: type(of:self))).instantiate(withOwner: self, options: nil).first as? UIView else {
            
            print("load nib with error")
            
            throw LoadNibError.unknowError
        }
        
        view.frame = bounds
        
        view.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        
        return view
    }
    
    
    func zoomOut(completion: @escaping (Bool) -> Void) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.transform = CGAffineTransform(scaleX: 0.1,y: 0.1);
            
        }) { (finished) in
            
            self.transform = CGAffineTransform(scaleX: 0.0,y: 0.0)
            
            completion(finished)
        }
    }
    
    func zoomIn(completion: @escaping (Bool) -> Void) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
            
        }) { (finished) in
            
            completion(finished)
        }
    }
}


/*
class UIViewExtension: NSObject {

}
*/
