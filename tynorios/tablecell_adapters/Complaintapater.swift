//
//  Complaintapater.swift
//  tynorios
//
//  Created by Acxiom Consulting on 02/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Complaintapater {
    
    var cno: String?
    var type: String?
    var date: String?
    var status: String?
    var cretedBy: String?
    var statusImage: String?

    init(cno: String?, type: String?, date: String?, status: String?,cetedBy: String?,statusImage: String?) {
        self.cno = cno
        self.type = type
        self.date = date
        self.status = status
        self.cretedBy = cetedBy
        self.statusImage = statusImage
    }
}
