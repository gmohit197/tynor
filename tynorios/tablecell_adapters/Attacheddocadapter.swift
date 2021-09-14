//
//  Attacheddocadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 24/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
class Attacheddocadapter {
    var mobilenum, docname, docid: String?
    init(mobilenum: String?, docname: String?, docid: String?) {
        self.docid = docid
        self.docname = docname
        self.mobilenum = mobilenum
    }
}
