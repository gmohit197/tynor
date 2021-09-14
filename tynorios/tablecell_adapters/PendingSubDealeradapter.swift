//
//  PendingSubDealeradapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class PendingSubdealeradapter {
    var customername: String?
    var city: String?
    var requestedby: String?
    
    init(customername:String?,city:String?,requestedby:String?) {
        
        self.customername = customername
        self.city = city
        self.requestedby = requestedby
    }
}
