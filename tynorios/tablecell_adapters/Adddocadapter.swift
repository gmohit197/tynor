//
//  Adddocadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 27/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
class Adddocadapter {
    var hosname,address, city, hostype: String?
    init(hosname: String?, address: String?, city: String?, hostype: String?) {
        self.address = address
        self.city = city
        self.hosname = hosname
        self.hostype = hostype
        
    }
}
