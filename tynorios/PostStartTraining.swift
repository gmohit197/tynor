//
//  PostTrainingvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 23/08/19.
//  Copyright © 2019 Acxiom. All rights reserved.
//

import Foundation
import Alamofire
import SQLite3
import UIKit
import SwiftEventBus

class PostStartTraining: Baseactivity {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateStartTraining(trainingid: String?)
    {
        let query = "update TrainingDetail set post='1', status = '0' where TRAININGID ='\(trainingid!)' and post = '0'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table TrainingDetail ")
            return
        }
        print("TrainingDetail table Updated")
    }
}
