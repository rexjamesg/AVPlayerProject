//
//  MovieListCell.swift
//  AVPlayer
//
//  Created by Yu Li Lin on 2019/9/4.
//  Copyright © 2019 Yu Li Lin. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCell: UICollectionViewCell {

    @IBOutlet weak var imageBase: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setCornerRadius(value: 5.0)
        
    }
    
    func setUp(video:Video) {
        
        if let url = video.getImageUrl() {
            
            imageView.kf.setImage(with: url)
        }

        movieTitle.text = video.title
        
        movieSubtitle.text = video.subtitle
        
    }

}
