//
//  PendingEscalationadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class PendingEscalationadapter {
    
    var name: String?
    var type: String?
    var escalatedby: String?
    var date: String?
    
    init(name: String?,type: String?,escalatedby:String?,date: String?) {
        self.name = name
        self.type = type
        self.escalatedby = escalatedby
        self.date = date
    }
}
