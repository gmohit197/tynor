//
//  Attachdocvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class Attachdocvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celladapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Attachdoccell
        let list: Attachdocadapter
        list = celladapter[indexPath.row]
        
        cell.docname.text = "\(list.docname!)\(list.cityname!)"
        if flags[indexPath.row] {
            cell.checkbox.image = UIImage(named:"selected")
        }
        else {
            cell.checkbox.image = UIImage(named:"unselected")
        }
        return cell
    }
    
    var flags: [Bool]!
    var selected: [String]!
    var celladapter = [Attachdocadapter]()
    var query = ""
    var titletext = ""
    var custcode = ""
    var source = ""
    var origin: String?
    
    @IBOutlet weak var addnewdoc: UIButton!
    @IBOutlet weak var attachdoctable: UITableView!
    var drcode: [String]!
    @IBOutlet weak var searchbox: UITextField!

    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homebtn(_ sender: Any) {
           self.getToHome(controller: self)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if titletext == "Doctor"{
            self.setnav(controller: self, title: "Customer List")
            self.searchbox.placeholder = "Search Chemist"
        }
        else{
            self.setnav(controller: self, title: "Attach Doctor")
        }
        drcode = []
        flags = []
        flags.removeAll()
        selected = []
        self.attachdoctable.tableFooterView = UIView()
        settable(query: "",flag: 0)
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getdoccode))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.attachdoctable.addGestureRecognizer(tapeno)

//        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
//        longPressGesture.minimumPressDuration = 0.4 // 1 second press
//        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
//        self.attachdoctable.addGestureRecognizer(longPressGesture)

        if AppDelegate.source == "Retailer" {
            self.navigationItem.title = "Attach Doctor"
            if(AppDelegate.isDebug){
                print("AttachDocvc=" + AppDelegate.customercode)
            }
        }
        else if AppDelegate.source == "Doctor"
        {
            self.navigationItem.title = "Attach Chemist"
        }
        if titletext == "Doctor"
        {
            addnewdoc.setTitle("Add New Chemist", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.popviewcontrolllercheck = false
        DispatchQueue.main.asyncAfter(deadline: .now()+1.00) {
            self.settable(query: "", flag: 0)
        }
//        SwiftEventBus.onMainThread(self, name: "attachdocvcval") { Result in
//            self.titletext = "Doctor"
//            self.settable(query: "", flag: 0)
//        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.attachdoctable)
            if let indexPath = attachdoctable.indexPathForRow(at: touchPoint) {
                let index = indexPath.row
                AppDelegate.doccode = drcode[index]
                print("\(drcode[index]) \(AppDelegate.doccode)")
                let adddoc: AttachDoctorvc = self.storyboard?.instantiateViewController(withIdentifier: "Attachdoc") as! AttachDoctorvc
                self.navigationController?.pushViewController(adddoc, animated: true)
            }
        }
    }
    
    @objc func getdoccode(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.attachdoctable)
        if let indexPath = attachdoctable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            print("\n \(self.drcode[index])")
            
            if flags[index]{
                selected[index] = ""
                print("\(selected!)\n")
                flags[index] = false
                print("\(index)    \(flags!)\n")
                //cell.animatebtn()
                //cell.checkbox.setImage(UIImage(named:"unselected"), for: .normal)
            }
            else {
                //cell.animatebtn()
                
                flags[index] = true
                //cell.checkbox.setImage(UIImage(named:"selected"), for: .selected)
                selected[index] = self.drcode![index]
                print("\(selected!)\n")
                print("\(index)    \(flags!)\n")
            }
            
        }
        self.settable(query: query,flag: 1)
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
          //  AppDelegate.customercode = cust
        }
        return cust
    }
    func gethoscust(hoscode: String?)->String{
        var stmt1:OpaquePointer?
        var Vatage: Float = 0;
        var cust = ""
        let query = "select custrefcode from HospitalMaster where hoscode = '\(hoscode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            cust = String(cString: sqlite3_column_text(stmt1, 0))
         //   AppDelegate.customercode = cust
        }
        return cust
    }
    
    func settable(query: String, flag: Int?){
        var stmt:OpaquePointer?
        drcode.removeAll()
        celladapter.removeAll()
        var querystr = ""
        if(AppDelegate.isDebug){
        print("AttachDocvcTitle="+titletext)
        }
        if self.titletext == "Doctor"
        {
            querystr = "select A.customercode ,A.customername ,C.CityName from RetailerMaster A left join CityMaster C on A.city=C.CityID where (A.customercode like '%\(query)%' or A.customername like '%\(query)%' or A.address like '%\(query)%') and A.customercode not in ( select distinct customercode from userDRCustLinking where drcode = '\(AppDelegate.doccode)') and (A.customertype='CG0001' or A.customertype='CG0004')"
        }
        else {
             querystr = "select A.drcode,A.drname,C.CityName, A.mobileno,A.emailid,A.address as city from DRMASTER A left join CityMaster C on A.city = C.CityID where (A.drname like '%\(query)%' or A.address like '%\(query)%' or A.city like '%\(query)%' or mobileno like '%\(query)%') and A.drcode not in (select distinct drcode from userDRCustLinking where customercode = '\(AppDelegate.customercode)')"
            
        }
        if(AppDelegate.isDebug){
            print("AttachDocvc==="+querystr)
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var city = ""
        while(sqlite3_step(stmt) == SQLITE_ROW){
            city = " - " + String (cString: sqlite3_column_text(stmt, 2))
            let doccode = String (cString: sqlite3_column_text(stmt, 0))
            let docname = String (cString: sqlite3_column_text(stmt, 1))
            drcode.append(doccode)
            self.celladapter.append(Attachdocadapter(docname: docname,doccode: doccode,cityname: city))
            if flag == 0 {
                self.selected.append("")
                self.flags.append(false)
            }
        }
        self.attachdoctable.reloadData()
        if(AppDelegate.isDebug){
        print("\(flags!)\n")
        print("\(selected!)\n")
        }
    }
    
    @IBAction func addnewdoc(_ sender: UIButton) {
        if titletext == "Doctor" {
            let market: MarketIntelligence =  self.storyboard?.instantiateViewController(withIdentifier: "mivc") as! MarketIntelligence
            AppDelegate.chemistcheck = true
            AppDelegate.isChemist  = true
            market.titletext =  self.titletext
            Retailerlistvc.customername = ""
            market.siteid = AppDelegate.siteid
            market.source =  self.titletext
            AppDelegate.chemcustcode = ""
            self.navigationController?.pushViewController(market, animated: true)
        }
        else {
            let adddoc: AttachDoctorvc = self.storyboard?.instantiateViewController(withIdentifier: "Attachdoc") as! AttachDoctorvc
            AppDelegate.popviewcontrolllercheck = true
            AppDelegate.isDocScreen = true
            AppDelegate.doccode = "DOC" + self.getIDNew()
            AppDelegate.titletxt = "Doctor"
             print("AttachDocVC=" + AppDelegate.customercode)
            self.navigationController?.pushViewController(adddoc, animated: true)
        }
    }
    
    func showalertmsg(){
        if(AppDelegate.isDebug){
            print("AttachDocvc=" + AppDelegate.customercode)
            print("AttachDocvc=" + AppDelegate.doccode)
            print("AttachDocvc=" + AppDelegate.hoscode)
            print("AttachDocVcSource==" + AppDelegate.source)
        }
        let alert = UIAlertController(title: "Are you sure you want to attach", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            if self.origin == "doc"
            {
                for i in 0..<self.celladapter.count {
                    if self.flags[i]
                    {
                        if(AppDelegate.source == "Doctor"){
                            print("CustomerCodeUDRDoc="+AppDelegate.customercode)
                         self.updateUserDrcustlinking(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), siteid: AppDelegate.siteid, customercode: self.celladapter[i].doccode, drcode: AppDelegate.doccode , isblocked: "false", ispurchaseing: "", ispriscription: "", createdtransactionid: "0", modifiedtransactionid: "0", post: "0")
                        }
                        else{
                            if(AppDelegate.source == "3" || AppDelegate.source == "MarketIntelligence"  || AppDelegate.source == "Retailer") {
                                 print("CustomerCodeUDR3="+AppDelegate.customercode)
                                if(AppDelegate.isChemist){
                                    self.updateUserDrcustlinking(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), siteid: AppDelegate.siteid, customercode: AppDelegate.chemcustcode, drcode: self.celladapter[i].doccode, isblocked: "false", ispurchaseing: "", ispriscription: "", createdtransactionid: "0", modifiedtransactionid: "0", post: "0")
                                }
                                else {
                                    self.updateUserDrcustlinking(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), siteid: AppDelegate.siteid, customercode: AppDelegate.customercode, drcode: self.celladapter[i].doccode, isblocked: "false", ispurchaseing: "", ispriscription: "", createdtransactionid: "0", modifiedtransactionid: "0", post: "0")
                                }
                            }
                            else{
                                print("CustomerCodeHDR="+AppDelegate.customercode)
                            self.insertHospitalDRLinking(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), drcode: self.celladapter[i].doccode, hospitalcode:  AppDelegate.hoscode, isblocked: "false", RECID: "", CREATEDBY: UserDefaults.standard.string(forKey: "usercode"), post: "0", CREATEDTRANSACTIONID: "0", ModifiedTransactionId: "0")
                            }
                        }
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
            }
            else if self.origin ==  "hos" {
                for i in 0..<self.celladapter.count {
                    if self.flags[i]
                    {
                     self.updateCustHospitalLinkingData(dataareaid: UserDefaults.standard.string(forKey: "dataareaid")!, siteid: AppDelegate.siteid, customercode:  self.celladapter[i].doccode!, hospitalcode: AppDelegate.hoscode, isblocked: "false", createdtransactionid: "0", modifiedtransactionid: "0", post: "0")
                    }
                    self.dismiss(animated: true, completion: nil)
                }
                if(AppDelegate.isFromHospitalScreen){
                    SwiftEventBus.post("gotochemist")
                }
            }
            
            SwiftEventBus.post("LinkingDone")
            SwiftEventBus.post("updateprogress")
            
            UIView.animate(withDuration: 0.3, animations: { ()->Void in
                self.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (finished) in
                self.view.removeFromSuperview()
                
            }
        }))
        present(alert, animated: true)
    }
    
    @IBAction func attachbtn(_ sender: UIButton) {
        var temp = 0
        for i in 0..<flags.count {
            if flags[i]{
                temp = 1;
            }
        }
        if temp > 0  // no selected item write condition here
        {
            self.showalertmsg()
        }
            
        else
        {
            self.showtoast(controller: self, message: "No Record Selected", seconds: 1.5)
        }
        
    }
    
    @IBAction func searchdoc(_ sender: UITextField) {
        query = sender.text!
        flags.removeAll()
        settable(query: query,flag: 0)
    }
}
