//
//  Takeorderadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 03/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
class Takeorderadapter {
    var orderno: String?
    var date: String?
    var amount: String?
    var payableamt: String?
    var qty: String?
    var status: String?
    
    
    init(orderno: String?, date: String?,amount: String?, payableamt: String?, qty: String?, status: String?) {
        self.amount = amount
        self.date = date
        self.orderno = orderno
        self.payableamt = payableamt
        self.qty = qty
        self.status = status
    }
}
