//
//  Subdealercelladapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 15/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
class Subdealercelladapter {
    var retailername: String?
    var conversionstatus: String?
    var rejectreason:String?
    
    init(retailername: String?, conversionstatus: String?,rejectreason:String?) {
        self.conversionstatus = conversionstatus
        self.retailername = retailername
        self.rejectreason=rejectreason
    }
}
