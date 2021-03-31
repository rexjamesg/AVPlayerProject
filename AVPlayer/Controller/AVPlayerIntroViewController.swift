//
//  AVPlayerIntroViewController.swift
//  AVPlayer
//
//  Created by Rex Lin on 2021/3/31.
//  Copyright © 2021 Yu Li Lin. All rights reserved.
//

import UIKit

class AVPlayerIntroViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitAction(_ sender: Any) {        
        UserDefaultData.setHasOpened(isFirst: true)
        
        dismiss(animated: true, completion: nil)
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
