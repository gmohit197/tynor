//
//  MiDoctorvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 02/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.

import UIKit
import SQLite3
import SwiftEventBus

class MiDoctorvc: Executeapi, UITableViewDelegate, UITableViewDataSource {

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
    @IBOutlet var nodoctorView: UIView!
    @IBOutlet var doctorHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attachdoctable.delegate = self
        self.attachdoctable.dataSource = self
        settable(query: "")
        self.attachdoctable.tableFooterView = UIView()
        self.updateprog()
    }
    
    func updateprog(){
 //       let t = getcusttype(customercode: AppDelegate.customercode)
        if (AppDelegate.isChemist && !AppDelegate.isDocScreen){
            self.doctorHeader.text = "Attached Doctors" + "(\(Int(getcustdoctor(query: "", customercode: AppDelegate.chemcustcode)))%)"
        }
            
        else  if (!(AppDelegate.titletxt == "Hospital")){
            self.doctorHeader.text = "Attached Doctors" + "(\(Int(getcustdoctor(query: "", customercode: AppDelegate.customercode)))%)"
        }
        else{
            self.doctorHeader.text = "Attached Doctors" + "(\(Int(gethosdoctors(query: "",refcode: AppDelegate.hoscode)))%)"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "LinkingDone") { Result in
           self.settable(query: "")
            self.updateprog()
        }
    }
    
    func settable(query: String)
    {   self.celladapter.removeAll()
        var stmt:OpaquePointer?
        var querystr = ""
        
        if(AppDelegate.isChemist && !AppDelegate.isDocScreen){
            querystr = "select distinct 1 as _id,drcode, drname,mobileno,emailid  from DRMASTER where drcode in (select drcode from userDRCustLinking where customercode= '\(AppDelegate.chemcustcode)' and isblocked = 'false') and (drcode like '%\(query)%' or drname like '%\(query)%' or mobileno like '%\(query)%')"
        }
        else if (!(AppDelegate.titletxt == "Hospital"))
        {
            querystr = "select distinct 1 as _id,drcode, drname,mobileno,emailid  from DRMASTER where drcode in (select drcode from userDRCustLinking where customercode= '\(AppDelegate.customercode)' and isblocked = 'false') and (drcode like '%\(query)%' or drname like '%\(query)%' or mobileno like '%\(query)%')"
        }
        else if AppDelegate.titletxt == "Hospital" {
            querystr  = "select distinct 1 as _id,drcode, drname,mobileno,emailid  from DRMASTER where drcode in (select drcode from HospitalDRLinking where hospitalcode= '\(AppDelegate.hoscode)' and isblocked = 'false') and (drcode like '%" + query + "%' or drname like '%" + query + "%' or mobileno like '%" + query + "%' )"
        }
        if(AppDelegate.isDebug){
        print("settableMiDoctorvcQuery=="+querystr)
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var docid=""
        var docname=""
        var mobilenum=""
        while(sqlite3_step(stmt) == SQLITE_ROW){
            docid = String(cString: sqlite3_column_text(stmt, 1))
            docname = String(cString: sqlite3_column_text(stmt, 2))
            mobilenum = String(cString: sqlite3_column_text(stmt, 3))
            self.celladapter.append(Attacheddocadapter(mobilenum: mobilenum, docname: docname, docid: docid))
        }
        self.attachdoctable.reloadData()
        if celladapter.count == 0 {
            view.bringSubview(toFront: nodoctorView)
        }
        else{
            view.sendSubview(toBack: nodoctorView)
        }
    }
    
    @IBAction func attachbtn(_ sender: UIButton) {
      //  self.pushnext(identifier: "attachdoctor", controller: self)
        //
    //    self.pushnext(identifier: "teamtraining", controller: self)
//        if let attachdoc = segue.destination as?  UINavigationController,
//                  let vc = attachdoc.topViewController as? Attachdocvc {
//                  if (segue.identifier == "attachdoc"){
//                      vc.titletext = self.titletext
//                      vc.origin = "doc"
//                      AppDelegate.source = self.navigationItem.title!
//                  }
//              }
//
        self.performSegue(withIdentifier: "attachdoc", sender: (Any).self)
        
//        let vc: Attachdocvc = self.storyboard?.instantiateViewController(withIdentifier: "attachdoc") as! Attachdocvc
//
////         vc.titletext = self.titletext
////                vc.origin = "doc"
////                AppDelegate.source = self.navigationItem.title!
//                 self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nextbtn(_ sender: Any) {
         SwiftEventBus.unregister(self)
        if AppDelegate.titletxt == "Hospital"
        {
            if(AppDelegate.isChemist && !AppDelegate.isDocScreen){
                SwiftEventBus.post("gotostock")
            }
            else{
                SwiftEventBus.post("gotochemist")
            }
        }
        else{
            SwiftEventBus.post("gotostock")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let attachdoc = segue.destination as?  UINavigationController,
            let vc = attachdoc.topViewController as? Attachdocvc {
            if (segue.identifier == "attachdoc"){
                vc.titletext = self.titletext
                vc.origin = "doc"
                vc.modalPresentationStyle = .fullScreen
                AppDelegate.source = self.navigationItem.title!
            }
        }
    }
}
