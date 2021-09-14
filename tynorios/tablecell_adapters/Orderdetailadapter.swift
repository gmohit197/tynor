//
//  Orderdetailadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 29/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Ordercelladapter
{
    var productname: String?
    var size: String?
    var qty: String?
    var amount: String?

    init(productname: String?,size: String?,qty: String?,amount: String?) {
        self.productname = productname
        self.size = size
        self.qty = qty
        self.amount = amount
    }
   
}
