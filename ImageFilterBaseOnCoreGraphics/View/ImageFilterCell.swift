//
//  ImageFilterCell.swift
//  ImageFilterBaseOnCoreGraphics
//
//  Created by 周伟克 on 2018/11/8.
//  Copyright © 2018 周伟克. All rights reserved.
//

import UIKit

class ImageFilterCell: UICollectionViewCell {
    
    
    private weak var previewImageView: UIImageView!
    private weak var filterNameLabel: UILabel!
    
    var filterName: String! {
        didSet {
            filterNameLabel.text = filterName
            filterNameLabel.sizeToFit()
            setNeedsLayout()
        }
    }
    
    var filteredImage: UIImage! {
        didSet {
            previewImageView.image = filteredImage
        }
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        
        let previewImageView = UIImageView()
        previewImageView.contentMode = .scaleAspectFit
        contentView.addSubview(previewImageView)
        self.previewImageView = previewImageView
        
        
        let filterNameLabel = UILabel()
        filterNameLabel.text = ""
        filterNameLabel.font = UIFont.systemFont(ofSize: 14)
        filterNameLabel.sizeToFit()
        contentView.addSubview(filterNameLabel)
        self.filterNameLabel = filterNameLabel
                
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previewImageView.frame = CGRect(x: 0, y: 0, width: width,
                                        height:  height - filterNameLabel.height)
        filterNameLabel.centerX = width * 0.5
        filterNameLabel.maxY = height
    }
}
