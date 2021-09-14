//
//  MyCartAdapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 11/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class MyCartAdapter {
    
    var productname: String? //2
    var size: String?//4
    var qty: String?//3
    var amount: String?//6
    var discount: String?//8
    var paybleamt: String?//5
    var itemid: String?
    
    init(productname: String?,size: String?,qty: String?,amount: String?,discount: String?,paybleamt: String?,itemid: String?) {
        self.productname = productname
        self.size = size
        self.qty = qty
        self.amount = amount
        self.discount = discount
        self.paybleamt = paybleamt
        self.itemid = itemid
    }
    
}
