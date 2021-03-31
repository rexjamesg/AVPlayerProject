//
//  MovieListViewController.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/4.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit

class MovieListViewController: BaseViewController {
    
    @IBOutlet weak var listCollectionView: UICollectionView!    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var identifierName:String = "MovieListCell"
    
    var data:Categories?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initListCollectionView()

        data = VideoSource().getVideos()

        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    private func initListCollectionView() {
        let cellNib = UINib.init(nibName: identifierName, bundle: nil)
        listCollectionView.register(cellNib, forCellWithReuseIdentifier: identifierName)
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        let width:CGFloat = view.frame.size.width*0.951690821
        let height:CGFloat = width*0.76142132
        
        flowLayout.estimatedItemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
    }
    
    func reloadData() {
        listCollectionView.reloadData()
    }
    
    private func presentPlayerController(video:Video) {
        
        let stroyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if let playerVC = stroyboard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController {
            playerVC.video = video
            playerVC.modalPresentationStyle = .overFullScreen
            self.present(playerVC, animated: true, completion: nil)
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

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    //MARK: ----- UICollectionViewDelegate & UICollectionViewDataSource -----
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = data?.count {
            return count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierName, for: indexPath)
        
        if let cell = cell as? MovieListCell {
            
            if let video = data?.getVideo(index: indexPath.row) {
                cell.setUp(video: video)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? MovieListCell
        
        cell?.selectedAnimation { [self] in
            if let video = self.data?.getVideo(index: indexPath.row) {
                presentPlayerController(video: video)
            }
        }
    }
}
