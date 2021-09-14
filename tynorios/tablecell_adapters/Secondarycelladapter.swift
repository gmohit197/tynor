//
//  Secondarycelladapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 29/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Secondarycelladapter
{
    var orderno: String?
    var date: String?
    var status: String?
    var value: String?
    var customername: String?
    
    init(orderno: String?,date: String?,status: String?,value:String?,customername: String?) {
        
        self.orderno = orderno
        self.date = date
        self.status = status
        self.value = value
        self.customername = customername
        
    }
    
}
