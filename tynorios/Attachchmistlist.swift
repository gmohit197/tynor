//
//  Attachchmistlist.swift
//  tynorios
//
//  Created by Acxiom Consulting on 07/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class Attachchmistlist: Executeapi, UITableViewDelegate, UITableViewDataSource {
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
    
    @IBOutlet weak var chemistlisttable: UITableView!
    
    var source = ""
    var custcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Attach Chemist")
        chemistlisttable.tableFooterView = UIView()
        setlist(query: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
         SwiftEventBus.onMainThread(self, name: "LinkingDone") { Result in
            self.setlist(query: "")
       }
    }
    
    func setlist(query: String?)
    {
        chemistadapter.removeAll()
        var stmt1: OpaquePointer?
        
        let querystr = "select distinct 1 as _id,customercode, customername,mobileno,emailid  from RetailerMaster where customercode in (select customercode from userDRCustLinking where drcode= '\(AppDelegate.doccode)' and isblocked='false') and (customercode like '%\(query!)%' or customername like '%\(query!)%' or mobileno like '%\(query!)%')"
       
        print("setListAttachchemist==\(querystr)")
        
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
        chemistlisttable.reloadData()
        
        print("Attachchmistlist"+querystr)
    }
  
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        
        self.navigationController?.pushViewController(home, animated: true)
    }
   
    @IBAction func addlistbtn(_ sender: Any) {
        self.performSegue(withIdentifier: "attachchemist", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let attachdoc = segue.destination as?  UINavigationController,
            let vc = attachdoc.topViewController as? Attachdocvc {
            if (segue.identifier == "attachchemist"){
                    vc.custcode = self.custcode
                    vc.titletext = self.source
                    AppDelegate.source = self.source
                    vc.origin = "doc"
            }
        }
    }
}
