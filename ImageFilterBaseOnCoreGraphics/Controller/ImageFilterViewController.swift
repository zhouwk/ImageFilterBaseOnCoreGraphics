//
//  ImageFilterViewController.swift
//  ImageFilterBaseOnCoreGraphics
//
//  Created by 周伟克 on 2018/11/8.
//  Copyright © 2018 周伟克. All rights reserved.
//

import UIKit

class ImageFilterViewController: UIViewController {

    weak var filteredImageView: UIImageView!
    weak var filterCollectionView: ImageFilterCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()

    }
    
    private func initUI() {
        
        view.backgroundColor = UIColor.groupTableViewBackground

        let origionalImage = UIImage(named: "girl.jpg")
        let filteredImageView = UIImageView()
        filteredImageView.contentMode = .scaleAspectFit
        filteredImageView.image = origionalImage
        view.addSubview(filteredImageView)
        self.filteredImageView = filteredImageView
        
        let filterCollectionView = ImageFilterCollectionView()
        filterCollectionView.origionalImage = origionalImage
        filterCollectionView.pickColormatrixClosure = { [weak self] colormatrix in
            
            if let colormatrix = colormatrix {
                
                self?.filteredImageView.image = origionalImage?.filter(colorMatrix: colormatrix)
            } else {
                self?.filteredImageView.image = origionalImage
            }
        }
        view.addSubview(filterCollectionView)
        self.filterCollectionView = filterCollectionView

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
        
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        
        filterCollectionView.size = CGSize(width: view.width, height: 200)
        filterCollectionView.maxY = view.height
        
        
        filteredImageView.size = CGSize(width: view.width - 50,
                                        height: view.height - filterCollectionView.height - 40)
        filteredImageView.centerX = view.centerX
        filteredImageView.centerY = view.centerY - 80

    }
}
