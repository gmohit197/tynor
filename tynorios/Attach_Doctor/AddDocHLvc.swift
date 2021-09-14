//
//  AddDocHLvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.

import UIKit
import SQLite3
import SwiftEventBus

class AddDocHLvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celladapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Adddoccell
        let list: Adddocadapter
        list = celladapter[indexPath.row]
        cell.address.text = list.address
        cell.hostype.text = list.hostype
        cell.hosname.text = list.hosname
        cell.city.text = list.city
        
        return cell
    }
    
    var celladapter = [Adddocadapter]()
    @IBOutlet weak var addhochl: UITableView!
    @IBOutlet var hospitalListPer: UILabel!
    var doctorcode: String!
    
    override func viewDidLoad() {
        print("DocCodeHospitalList==" + AppDelegate.customercode)
        super.viewDidLoad()
        self.addhochl.tableFooterView  = UIView()
        self.updateprog()
        self.settable()
    }
    
    func updateprog(){
         self.hospitalListPer.text = "Hospital List" + "(\(Int(gethospitallist(docid: AppDelegate.doccode)))%)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
         SwiftEventBus.onMainThread(self, name: "HospitalLinkingDone") { Result in
             self.settable()
             self.updateprog()
     }
    }
    
    func settable() {
        
        var stmt:OpaquePointer?
        celladapter.removeAll()
        let querystr = "select distinct 1 as _id,A.HOSNAME,A.ADDRESS,B.CityName,C.typedesc  from HospitalMaster A left outer join CityMaster B on A.CityID = B.CityID left outer join HospitalType C on A.type = C.typeid where A.hoscode in (select hospitalcode from HospitalDRLinking where drcode= '\(AppDelegate.doccode)')"
        

        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        print("AddDocHLvc=="+querystr)
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let hosname = String (cString: sqlite3_column_text(stmt, 1))
            let address = String (cString: sqlite3_column_text(stmt, 2))
            let city = String (cString: sqlite3_column_text(stmt, 3))
            let type = " " + String (cString: sqlite3_column_text(stmt, 4))
            
            self.celladapter.append(Adddocadapter(hosname: hosname, address: address, city: city, hostype: type))
            
        }
        self.addhochl.reloadData()
    }

    @IBAction func addbtn(_ sender: UIButton) {
    //    self.pushnext(identifier: "hl", controller: self)
        self.performSegue(withIdentifier: "hospitallist", sender: (Any).self)
    }
    
    @IBAction func nextbtn(_ sender: Any) {
         SwiftEventBus.unregister(self)
        SwiftEventBus.post("gotoproduct")
    }
}
