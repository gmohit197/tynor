
//  Attach_chemistvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 25/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.


import UIKit
import SwiftEventBus
import SQLite3

class Attach_chemistvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chemistadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AttachChemistcell
        
        let list: AttachChemistAdapter
        list = chemistadapter[indexPath.row]
        
        cell.chemistid.text = list.chemistid
        cell.chemistname.text = list.chemistname
        cell.mobileno.text = list.mobileno
        
        return cell
    }
    
    
    var chemistadapter = [AttachChemistAdapter]()
    
    @IBOutlet weak var chemisttable: UITableView!
    @IBOutlet var attachChemistPer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateprog()
        self.chemisttable.tableFooterView = UIView()
         self.setlist(query: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "LinkingDone") { Result in
            self.updateprog()
            self.setlist(query: "")
        }
    }
    
    func updateprog(){
         self.attachChemistPer.text = "Attach Chemist" + "(\(Int(gethoschemist(query: "",refcode: AppDelegate.hoscode)))%)"
    }
    
    func setlist(query: String?)
    {
        chemistadapter.removeAll()
        var stmt1: OpaquePointer?
        let querystr = "select distinct 1 as _id,customercode, customername,mobileno,emailid  from RetailerMaster where customercode in (select customercode from CUSTHOSPITALLINKING where hospitalcode= '\(AppDelegate.hoscode)' and   hospitalcode <> '' and  isblocked = 'false') and (customercode like '%" + query! + "%' or customername like '%" + query! + "%' or mobileno like '%" + query! + "%')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let customercode = String (cString: sqlite3_column_text(stmt1, 1))
            let customername = String (cString: sqlite3_column_text(stmt1, 2))
            let mobileno = String (cString: sqlite3_column_text(stmt1, 3))
            self.chemistadapter.append(AttachChemistAdapter(chemistid: customercode, chemistname: customername, mobileno: mobileno))
        }
        chemisttable.reloadData()
    }
    
    @IBAction func addlist(_ sender: Any) {
        self.performSegue(withIdentifier: "Attach_chemistvc", sender: (Any).self)
    }
    
    @IBAction func nextbtn(_ sender: Any) {
        SwiftEventBus.unregister(self)
        SwiftEventBus.post("gotopro")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Attach_chemistvc"){
            if let dealervc = segue.destination as?  UINavigationController,
                let vc = dealervc.topViewController as? Attachdocvc {
                vc.titletext = "Doctor"
                vc.origin = "hos"
            }}
    }
}

