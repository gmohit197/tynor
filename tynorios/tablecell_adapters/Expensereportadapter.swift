//
//  Expensereport.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Expensereportdata {
    
    var date: String?
    var TA: String?
    var DA: String?
    var misscelions: String?
    var total: String?
    var city: String?
    
    init(date: String?,TA: String?, DA: String?, misscelions: String?, total: String?,city: String?) {
        self.date = date
        self.TA = TA
        self.DA = DA
        self.misscelions = misscelions
        self.total = total
        self.city = city
    }
}
