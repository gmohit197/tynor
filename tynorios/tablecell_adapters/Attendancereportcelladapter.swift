//
//  Attendancereportcelladapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 10/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class Attendancereport {
    var date: String?
    var usercode: String?
    var daystart: String?
    var dayend: String?
    var hours: String?
    init(date: String?,usercode: String?, daystart: String?, dayend: String?, hours: String?) {
        self.date = date
        self.usercode = usercode
        self.daystart = daystart
        self.dayend = dayend
        self.hours = hours
    }
}
