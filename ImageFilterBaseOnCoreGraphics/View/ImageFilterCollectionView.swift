//
//  ImageFilterCollectionView.swift
//  ImageFilterBaseOnCoreGraphics
//
//  Created by 周伟克 on 2018/11/8.
//  Copyright © 2018 周伟克. All rights reserved.
//

import UIKit

class ImageFilterCollectionView: UICollectionView {


    weak var layout: UICollectionViewFlowLayout!
    let cellID = "ImageFilterCell"
    var origionalImage: UIImage!
    
    var pickColormatrixClosure: (([Float]?) -> ())?
    
    lazy var previews = [UIImage]()
    
    init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.layout = layout
        super.init(frame: .zero, collectionViewLayout: layout)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initUI() {
        
        backgroundColor = UIColor.groupTableViewBackground

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        register(ImageFilterCell.self, forCellWithReuseIdentifier: cellID)

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        let itemHeight = bounds.height - 10
        layout.itemSize = CGSize(width: 130, height: itemHeight)
    }
}

extension ImageFilterCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return Filter.names.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: cellID,
                                        for: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let colormatrix = colorMatrixAt(indexPath)
        pickColormatrixClosure?(colormatrix)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let filterCell = cell as! ImageFilterCell
        if previews.count <= indexPath.row {
            if let colorMatrix = colorMatrixAt(indexPath), let origionalImage = origionalImage.filter(colorMatrix: colorMatrix) {
                previews.append(origionalImage)
            } else {
                previews.append(origionalImage)
            }
        }        
        filterCell.filterName = indexPath.row == 0 ? "原图" : Filter.names[indexPath.row]
        filterCell.filteredImage = previews[indexPath.row]
    }
    
    
    private func colorMatrixAt(_ indexPath: IndexPath) -> [Float]? {
        
        switch indexPath.row {
        case 1:
            return colormatrix_lomo
        case 2:
            return colormatrix_heibai
        case 3:
            return colormatrix_huajiu
        case 4:
            return colormatrix_gete
        case 5:
            return colormatrix_ruise
        case 6:
            return colormatrix_danya
        case 7:
            return colormatrix_jiuhong
        case 8:
            return colormatrix_qingning
        case 9:
            return colormatrix_langman
        case 10:
            return colormatrix_guangyun
        case 11:
            return colormatrix_landiao
        case 12:
            return colormatrix_menghuan
        case 13:
            return colormatrix_yese
        default:
            return nil
        }
    }
}
