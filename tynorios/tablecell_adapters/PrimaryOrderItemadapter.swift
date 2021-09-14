//
//  PrimaryOrderItemadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 12/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class PrimaryOrderItemadapter
{
    var size: String?
    var shipperqty: String?
    var qty: String?
    var price: String?
    var itemid: String?
    var ispcsapply: String?

    var siteid: String?
    var orderid: String?
    var itemgroupid: String?
    var plantstateid: String?
    var stateid: String?
     var index: Int!
    
    
    init(size: String?,shipperqty: String?, qty: String?, price: String?,itemid: String?,ispcsapply: String?,siteid: String?, orderid: String?,itemgroupid: String?,plantstateid: String?,stateid: String?,index: Int!) {
        
        self.size = size
        self.shipperqty = shipperqty
        self.qty = qty
        self.price = price
        self.itemid = itemid
        self.ispcsapply = ispcsapply
        self.siteid = siteid
        self.orderid = orderid
        self.itemgroupid = itemgroupid
        self.plantstateid = plantstateid
        self.stateid = stateid
         self.index = index

    }
}



