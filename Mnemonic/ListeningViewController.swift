//
//  ListeningViewController.swift
//  Mnemonic
//
//  Created by Joshua Liu on 4/1/17.
//  Copyright © 2017 Joshua Liu. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ListeningViewController: UIViewController {
    
    var activityView = NVActivityIndicatorView(frame: CGRect(x: 375 / 2.0 - 98 / 2.0, y: 423, width: 98, height: 98), type: NVActivityIndicatorType.lineScale, color: UIColor.white, padding: 25)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
    }

}
