//
//  Primarycelladapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 27/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Primarycelladapter
{
    var createdby: String?
    var orderno: String?
    var date: String?
    var status: String?
    var value: String?
    var customername: String?
    var logicSono: String?
    
    init(createdby: String?,orderno: String?,date: String?,status: String?,value:String?,customername: String?,logicSono: String?) {
        self.createdby = createdby
        self.orderno = orderno
        self.date = date
        self.status = status
        self.value = value
        self.customername = customername
        self.logicSono = logicSono
    }
}
