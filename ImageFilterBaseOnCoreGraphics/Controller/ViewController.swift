//
//  ViewController.swift
//  ImageFilterBaseOnCoreGraphics
//
//  Created by 周伟克 on 2018/11/8.
//  Copyright © 2018 周伟克. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let filterVC = ImageFilterViewController()
        present(filterVC, animated: true, completion: nil)
    }
}

