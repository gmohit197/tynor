//
//  MyCustomer.swift
//  tynorios
//
//  Created by Acxiom Consulting on 03/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Foundation

class MyCustomer: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.string(forKey: "usertype")! == "11"
        {
            self.viewControllers![2].removeFromParentViewController()
            self.viewControllers![2].removeFromParentViewController()
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "ArialHebrew", size: 12)!], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "ArialHebrew", size: 12)!], for: .selected)
        
    }
}
