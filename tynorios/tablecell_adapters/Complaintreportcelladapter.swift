//
//  Complaintreportcelladapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 10/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Complaintreportcelladapter{
    var cno: String?
    var category: String?
    var customername: String?
    var status: String?
    var csttype: String?
    var createdby: String?
    var colorstatus: String?
    
    init(cno: String?, category: String?, customername: String?, status: String?,csttype: String?,createdby: String?,colorstatus: String?) {
        self.cno = cno
        self.category = category
        self.customername = customername
        self.status = status
        self.csttype = csttype
        self.createdby = createdby
        self.colorstatus = colorstatus
    }
}
