//
//  AttachChemistAdapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 07/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class AttachChemistAdapter {
    var chemistid: String?
    var chemistname: String?
    var mobileno: String?
    
    init(chemistid: String?, chemistname: String?, mobileno: String?) {
        self.chemistid = chemistid
        self.chemistname  = chemistname
        self.mobileno = mobileno
    }
}
