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
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var titleBase: UIView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        // Specify you want _full width_
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: layoutAttributes.size.height)
        
        // Calculate the size (height) using Auto Layout
        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)
        
        // Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }
    
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
        
        movieDescription.text = video.description
        
    }

}
