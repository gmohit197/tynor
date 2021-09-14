//
//  Escalationcelladapter].swift
//  tynorios
//
//  Created by Acxiom Consulting on 13/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
class Escalationcelladapter {
    var escalationno: String?
    var customername: String?
    var status: String?
    var reason: String?
    var custtype: String?
    var createdby: String?
    
    init(escalationno: String? , customername: String?, status: String?, reason: String?,custtype: String?,createdby: String?) {
        self.customername = customername
        self.escalationno = escalationno
        self.reason = reason
        self.status = status
        self.custtype = custtype
        self.createdby = createdby
    }
}
