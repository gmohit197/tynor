//
//  ViewController.swift
//  tynorios
//
//  Created by Acxiom on 18/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isHidden  = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
