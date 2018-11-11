//
//  FilterImage.swift
//  ImageFilterBaseOnCoreGraphics
//
//  Created by 周伟克 on 2018/11/11.
//  Copyright © 2018 周伟克. All rights reserved.
//

import UIKit

class FilterImage: UIImage {

    var rawData: UnsafeMutableRawPointer? {
        didSet {
            if let old = oldValue {
                free(old)
            }
        }
    }
    
    deinit {
        if let rawData = rawData {
            free(rawData)
        }
    }
}
