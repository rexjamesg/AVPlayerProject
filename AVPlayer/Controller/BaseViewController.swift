//
//  BaseViewController.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/3.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    enum AlertType {
        case normal
        case option
    }
    
    var topHeight:CGFloat = 0
    var bottomHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let navigationBar = navigationController?.navigationBar {
            topHeight = navigationBar.frame.size.height
        }
        
        if let tabbar = tabBarController?.tabBar {
            bottomHeight = tabbar.frame.size.height
        }
    }
    
    func presentAlert(title:String?, message:String?, alertType:AlertType, handler:((Bool) -> Void)? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "確認", style: .default, handler: { (action) in
            if (handler != nil) {
                handler!(true)
            }
        }))
        
        if alertType == .option {
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                if (handler != nil) {
                    handler!(false)
                }
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
