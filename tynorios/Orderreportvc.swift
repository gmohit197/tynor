//
//  Orderreportvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import UIKit

class Orderreportvc : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "ArialHebrew", size: 16)!], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "ArialHebrew", size: 16)!], for: .selected)
        if UserDefaults.standard.string(forKey: "usertype") == "11"
        {
         self.viewControllers![0].removeFromParentViewController()
        }
        if  constant.onlyhidden
        {
            self.viewControllers![1].removeFromParentViewController()
        }
        
    }
    
}
