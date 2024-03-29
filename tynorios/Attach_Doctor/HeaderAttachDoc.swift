//  HeaderAttachDoc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 11/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.

import UIKit
import UICircularProgressRing
import SwiftEventBus
import SQLite3

class HeaderAttachDoc: Executeapi {
    var customername = ""
    var titletext: String?
    var siteid: String?
    @IBOutlet weak var progressRing: UICircularProgressRing!
    var rper: Float = 0;
    @IBOutlet weak var mipercentage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        progressRing.maxValue = 100
        progressRing.style = .ontop
        progressRing.innerRingColor=UIColor(red: 138/255, green: 17/255, blue: 84/255, alpha: 1.0)
        progressRing.shouldShowValueText=false
        self.updateprog()
    }
    func getdoccust(doccode: String?)->String{
        var stmt1:OpaquePointer?
        var Vatage: Float = 0;
        var cust = ""
        let query = "select custrefcode from DRMASTER where drcode = '\(doccode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            cust = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return cust
    }
    
    func updateprog(){
        rper = 0
        if(AppDelegate.isDebug){
            print("HeaderViewAttachDoc=="+AppDelegate.customercode)
        }
        rper = getdoctorpecent(docid: AppDelegate.doccode)
        rper += getcompetitor(customercode: getdoccust(doccode: AppDelegate.doccode))
        rper += gethospitallist(docid: AppDelegate.doccode)
        mipercentage.text=String(Int64(rper))
        progressRing.startProgress(to: CGFloat(rper), duration: 2.0) {
            if(AppDelegate.isDebug){
                print("Done animating!")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateprog()
        SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
            self.updateprog()
        }
    }
}
