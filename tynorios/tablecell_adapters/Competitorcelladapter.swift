//
//  Competitorcelladapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 23/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class competitorcelladapter {
    var sno, qty,ispreffered , product, brand: String?
    var preindex: String?
    
    init(sno: String?, qty: String?, product: String?, brand: String?,ispreffered: String?,preindex: String?) {
        self.sno = sno
        self.qty = qty
        self.brand = brand
        self.product = product
        self.ispreffered = ispreffered
        self.preindex = preindex
    }
}
