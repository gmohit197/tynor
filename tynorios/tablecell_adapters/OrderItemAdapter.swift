//
//  OrderItemAdapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 05/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
class OrderItemAdapter {
    var size: String?
    var qty: String?
    var price: String?
    
    var itemid: String?
    var sono: String?
    var siteid: String?
    var custstate: String?
    var customercode: String?
    var index: Int!
    
    init(size: String?, qty: String?,price: String?,itemid: String?,sono: String?,siteid: String?,custstate: String?,customercode: String?,index: Int!) {
        self.size = size
        self.qty = qty
        self.price = price
        self.itemid = itemid
        
        self.sono = sono
        self.siteid = siteid
        self.custstate = custstate
        self.customercode = customercode
        self.index = index
    }
}
