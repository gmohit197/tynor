//
//  Teamtrainingadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 23/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Teamtrainingadapter {
    
    var empname: String?
    var trainingid: String?
    var status: String?
    var usercode: String?
    
    init(empname: String?,trainingid: String?,status: String?,usercode: String?) {
        self.empname = empname
        self.trainingid = trainingid
        self.status = status
        self.usercode = usercode
    }
}
