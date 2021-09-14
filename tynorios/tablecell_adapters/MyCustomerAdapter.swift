//
//  MyCustomerAdapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class MyCustomerAdapter {
    
    var customername: String?
    var city: String?
    var status: String?
    
    init(customername: String?, city: String?, status: String? ) {
        self.customername = customername
        self.city = city
        self.status = status
    }
}
