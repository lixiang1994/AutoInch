//
//  ViewController.swift
//  AutoInchDemo
//
//  Created by 李响 on 2018/11/3.
//  Copyright © 2018 swift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("this is " +
            "default"
            .i35("3.5 inches (iPhone 4, 4s)")
            .i40("4.0 inches (iPhone 5, 5s, SE)")
            .i47("4.7 inches (iPhone 6, 7, 8)")
            .i55("5.5 inches (iPhone 6, 7, 8 Plus)")
            .ifull("full screen (iPhone X, Xs, XsMax)")
            .i58full("5.8 inches (iPhone X, Xs)")
            .i61full("6.1 inches (iPhone XR)")
            .i65full("6.5 inches (iPhone XsMax)")
        )
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

