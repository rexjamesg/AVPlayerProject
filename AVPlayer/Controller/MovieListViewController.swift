//
//  MovieListViewController.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/4.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

class MovieListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //,UIPopoverPresentationControllerDelegate
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var data:Categories?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let cellNib = UINib.init(nibName: "MovieListCell", bundle: nil)
        listCollectionView.register(cellNib, forCellWithReuseIdentifier: "MovieListCell")
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        data = JSONData.getVideos()

    }
    
    //MARK: ----- UICollectionViewDelegate & UICollectionViewDataSource -----
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = data?.count {
            
            return count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath)
        
        if let cell = cell as? MovieListCell {
            
            if let video = data?.getVideo(index: indexPath.row) {
             
                cell.setUp(video: video)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let stroyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if let playerVC = stroyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController {
            
            let cell = collectionView.cellForItem(at: indexPath) as? MovieListCell
            
            cell?.selectedAnimation {
                
                if let video = self.data?.getVideo(index: indexPath.row) {
                    
                    playerVC.video = video

                    self.present(playerVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
 
    }
    
    /*
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
    }
    */

}
