//
//  Attachdoctorsvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus
class Attachdoctorsvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celladapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Attachdoccelll
        let list: Attacheddocadapter
        list = celladapter[indexPath.row]
        
        cell.docid.text = list.docid
        cell.docname.text = list.docname
        cell.mobilenum.text = list.mobilenum
        
        return cell
    }
    var celladapter = [Attacheddocadapter]()
    var query = ""
    var titletext = ""
    @IBAction func searchtxt(_ sender: UITextField) {
        self.query = sender.text!
        settable(query: query)
    }
    @IBOutlet weak var attachdoctable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settable(query: "")
        
    }
    override func viewWillAppear(_ animated: Bool) {
//         SwiftEventBus.onMainThread(self, name: "LinkingDone") { Result in
//
//                    }
       self.settable(query: "")
    }
    func settable(query: String)
    {   self.celladapter.removeAll()
        var stmt:OpaquePointer?
        
        let querystr = "select distinct 1 as _id,drcode, drname,mobileno,emailid  from DRMASTER where drcode in (select drcode from userDRCustLinking where customercode= '\(AppDelegate.customercode)') and (drcode like '%\(query)%' or drname like '%\(query)%' or mobileno like '%\(query)%' )"
        
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let docid = String(cString: sqlite3_column_text(stmt, 1))
            let docname = String(cString: sqlite3_column_text(stmt, 2))
            let mobilenum = String(cString: sqlite3_column_text(stmt, 3))
            
            self.celladapter.append(Attacheddocadapter(mobilenum: mobilenum, docname: docname, docid: docid))
            
        }
        self.attachdoctable.reloadData()
    }
    @IBAction func attachbtn(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "attachdoc", sender: (Any).self)
    }
    
    @IBAction func nextbtn(_ sender: Any) {
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let attachdoc = segue.destination as?  UINavigationController,
            let vc = attachdoc.topViewController as? Attachdocvc {
            if (segue.identifier == "attachdoc"){
                vc.titletext = self.titletext
            }
        }
    }
}
