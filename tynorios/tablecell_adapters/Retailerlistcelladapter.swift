//
//  Retailerlistcelladapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 25/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Retailerlistadapter {
    
   
    var customername: String?
    var lastvisit: String?
    var cityname: String?
    var sitename: String?
    var currmonth: String?
    var complain: String?
    var mi: String?
    var customercode: String?
    
    init(customername: String?, lastvisit: String?, cityname: String?, sitename: String?, currmonth: String?, complain: String?, mi: String?, customercode: String?) {
        
        self.cityname = cityname
        self.complain = complain
        self.currmonth = currmonth
        self.customername = customername
        self.lastvisit = lastvisit
        self.sitename = sitename
        self.mi = mi
        self.customercode = customercode
        
        
    }
}

