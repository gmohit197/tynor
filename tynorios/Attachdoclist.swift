//
//  Attachdoclist.swift
//  tynorios
//
//  Created by Acxiom Consulting on 07/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class Attachdoclist: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Doclistcell
        let list: Doclistadapter
        list = adapter[indexPath.row]
        if(self.titletext=="Doctor" || self.titletext=="Hospital"){
            cell.doclbl.text = list.doclbl! + " - MI \(list.docmiper!)%"
        }
        else {
            cell.doclbl.text = list.doclbl!
        }
        return cell
    }
    
    var docid: [String]!
    var adapter = [Doclistadapter]()
    var custcode = ""
    var titletext = ""
    var stateid = ""
    var usercode = ""
    var flag = ""
    var isfrom = ""
    
    @IBOutlet weak var doclist: UITableView!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var searchbar: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docid = []
        self.doclist.tableFooterView = UIView()
        if titletext == "Doctor"{
            self.setnav(controller: self, title: "Attach Doctor")
            print("AttachDocList=" + AppDelegate.customercode)
            setlist(query: "")
        }
            
        else if titletext == "Hospital"{
            self.setnav(controller: self, title: "Hospital List")
            setlist(query: "")
        }
            
        else if titletext == "City"{
            self.setnav(controller: self, title: "Search City")
            self.addbtn.isHidden = true
            self.setcityspinr(stateid: self.stateid,usercode: self.usercode,isfrom: self.isfrom,flag: self.flag, queryStr: "")
        }
        
        self.searchbar.placeholder = "Search \(titletext)"
        self.addbtn.setTitle("Add New \(titletext)", for: .normal)
        
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(showmi))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.doclist.addGestureRecognizer(tapeno)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       AppDelegate.isFromSalesPersonList = false
        
        SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
            self.setlist(query: "")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //    SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
        SwiftEventBus.unregister(self)
        // }
    }
    
    func setcityspinr(stateid: String?,usercode:String?,isfrom : String?,flag : String?,queryStr : String)
    {
        
        var stmt1: OpaquePointer?
        var query = ""
        if(isfrom=="Market"){
            query = "select  ' '  as CITYID, 'Select ' as CITYNAME UNION select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and SE.stateid = '\(stateid!)' and SE.isblocked <> 'true' and  cityname like '%\(queryStr)%' order by cm.cityid"
        }
        else if (isfrom=="Doctor" || isfrom == "Hospital"){
            if(self.flag=="true"){
                query = "select  ' ' as CITYID, 'Select ' as CITYNAME UNION select A.cityid,B.CityName from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' and  stateid= '\(stateid!)' and  cityname like '%\(queryStr)%' order by CITYID"
            }
            else {
                query = "select  ' '  as CITYID, 'Select ' as CITYNAME UNION select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and SE.stateid = '\(stateid!)' and SE.isblocked <> 'true' and  cityname like '%\(queryStr)%' order by cm.cityid"
            }
           }
        
        print("setcitySpinrDocList=="+query)
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        docid.removeAll()
        adapter.removeAll()
        var docmiper: String? = ""
        var docname=""
        var docid=""
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            docname = String(cString: sqlite3_column_text(stmt1, 1))
            docid = String(cString: sqlite3_column_text(stmt1, 0))
            self.docid.append(docid)
            adapter.append(Doclistadapter(doclbl: docname,docmiper: docmiper!))
        }
    }

    
    @objc func showmi(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.doclist)
        if let indexPath = doclist.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            
            if titletext == "Doctor"{
                AppDelegate.isFromSalesPersonList = true
                AppDelegate.doccode = self.docid[index]
                print("\n \(self.docid[index])")
                let addnewdoc: AttachDoctorvc = self.storyboard?.instantiateViewController(withIdentifier: "Attachdoc") as! AttachDoctorvc
                self.navigationController?.pushViewController(addnewdoc, animated: true)
            }
                
            else if titletext == "Hospital"{
                AppDelegate.isFromSalesPersonList = true
                AppDelegate.hoscode = self.docid[index]
                let addnewdoc: AttachHospitalvc = self.storyboard?.instantiateViewController(withIdentifier: "attachhos") as! AttachHospitalvc
                self.navigationController?.pushViewController(addnewdoc, animated: true)
            }
            else if titletext == "City"{
                if(self.docid[index] == " "){
                    AppDelegate.cityidSpinner = ""
                    AppDelegate.cityNameSpinner = "Select"
                }
                else {
                    AppDelegate.cityidSpinner = self.docid[index]
                    AppDelegate.cityNameSpinner = self.getcityNamefromID(docid: AppDelegate.cityidSpinner)
                }
                SwiftEventBus.post("setcity")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func getcityNamefromID(docid : String?) -> String {
        var stmt1: OpaquePointer?
        let query = "SELECT cityname from CityMaster where cityid ='\(docid!)'"
        print("getcityNamefromID==="+query)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
      //  print("CityNameSelected=="+String(cString: sqlite3_column_text(stmt1, 0)))
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return String(cString: sqlite3_column_text(stmt1, 0))
        }
        return ""
    }
    
    func setlist(query: String){
        var querystr = ""
        var stmt1:OpaquePointer?
        if titletext == "Doctor" {
            querystr = "select 1 _id,A.drcode,A.drname,A.mobileno,A.emailid,A.address,A.city from DRMASTER A where (A.drname like '%\(query)%' or A.address like '%\(query)%' or A.city like '%\(query)%' or mobileno like '%\(query)%') and (drcode not in ( select CASE WHEN referencecode IS NULL THEN '' ELSE referencecode END  as drcode from RetailerMaster))"
            
        }
        else if titletext == "Hospital" {
            querystr = "select 1 _id,A.HOSCODE,A.HOSNAME,A.mobileno,A.address,B.typedesc from HOSPITALMASTER A inner join HospitalType B on A.type = B.typeid  where (A.HOSNAME like '%\(query)%' or A.ADDRESS like '%\(query)%' or A.MOBILENO like '%\(query)%') and  (A.HOSCODE not in( select CASE WHEN referencecode IS NULL THEN '' ELSE referencecode END  as HOSCODE from RetailerMaster))"
        }
        print("AttachDocList=="+titletext+"==>"+querystr)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        docid.removeAll()
        adapter.removeAll()
        var docmiper: String? = ""
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let docname = String(cString: sqlite3_column_text(stmt1, 2))
            let docid = String(cString: sqlite3_column_text(stmt1, 1))
            if titletext == "Doctor" {
               docmiper = self.getdoctorpercent(docid: docid)
            }else if titletext == "Hospital"{
                docmiper = self.gethospitalpercent(hosid: docid)
            }
            self.docid.append(docid)
            adapter.append(Doclistadapter(doclbl: docname,docmiper: docmiper!))
        }
    }
    
    
    
    func gethospitalpercent(hosid: String)-> String{
        var rper: Float = 0
        let ccode = self.getcustcodehospital(hosid: hosid)
        rper = gethospitalpercent(hosid: hosid)
        rper += gethosdoctors(query: "",refcode: hosid)
        rper += gethoschemist(query: "",refcode: hosid)
        rper += getcompetitor(customercode: ccode)
        
        return String(Int64(rper))
    }
    func getdoctorpercent(docid: String)-> String{
        var rper: Float = 0
        let ccode = self.getcustcodedoctor(docid: docid)
        rper = getdoctorpecent(docid: docid)
        rper += getcompetitor(customercode: ccode)
        rper += gethospitallist(docid: docid)
        return String(Int64(rper))
    }
    
    @IBAction func searchdoc(_ sender: UITextField) {
        if(self.titletext == "City"){
            setcityspinr(stateid: self.stateid, usercode: self.usercode, isfrom: self.isfrom, flag: self.flag,queryStr: sender.text!)
        }
        else{
            setlist(query: sender.text!)
        }
         doclist.reloadData()
    }

    func getcustcodehospital(hosid: String?)-> String{
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(custrefcode,'') from HospitalMaster where hoscode = '"+hosid!+"'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return String(cString: sqlite3_column_text(stmt1, 0))
        }else{
            return ""
        }
    }
    func getcustcodedoctor(docid: String?)-> String{
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(custrefcode,'') from DRMASTER where drcode = '"+docid!+"'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return String(cString: sqlite3_column_text(stmt1, 0))
        }else{
            return ""
        }
    }
    
    @IBAction func addbtn(_ sender: UIButton) {
        
        print("AttachDocList=" + AppDelegate.customercode)
        AppDelegate.isFromSalesPersonList = false
        if titletext == "Doctor" {
            let addnewdoc: AttachDoctorvc = self.storyboard?.instantiateViewController(withIdentifier: "Attachdoc") as! AttachDoctorvc
            AppDelegate.doccode = "DOC" + self.getIDNew()
            addnewdoc.titletext = self.titletext
            AppDelegate.source = self.navigationItem.title!
            self.navigationController?.pushViewController(addnewdoc, animated: true)
        }
            
        else if titletext == "Hospital" {
            let addnewdoc: AttachHospitalvc = self.storyboard?.instantiateViewController(withIdentifier: "attachhos") as! AttachHospitalvc
            AppDelegate.hoscode = "HOS" + self.getIDNew()
            addnewdoc.titletext = self.titletext
            AppDelegate.source = self.navigationItem.title!
            self.navigationController?.pushViewController(addnewdoc, animated: true)
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeBtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}
