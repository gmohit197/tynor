//
//  DownloadSyncadapter.swift
//  tynorios
//
//  Created by Acxiom Consulting on 16/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation

class DownloadSyncadapter  {
    
    var key: String?
    var datetime: String?
    var status: String?
    var pending: String?
    
    init(key: String?,datetime: String?,status: String?,pending: String?) {
        
        self.key = key
        self.datetime = datetime
        self.status = status
        self.pending = pending
    }
    
}
