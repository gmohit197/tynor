//
//  Hospitallistvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 29/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class Hospitallistvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celladapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Attachdoccell
        let list: Attachdocadapter
        list = celladapter[indexPath.row]
        
        cell.docname.text = list.docname
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
    @IBOutlet weak var attachdoctable: UITableView!
    var drcode: [String]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drcode = []
        flags = []
        flags.removeAll()
        selected = []
        self.setnav(controller: self, title: "Hospital List")
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
            self.settable(query: "",flag: 0)
        }
        
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.attachdoctable)
            if let indexPath = attachdoctable.indexPathForRow(at: touchPoint) {
                let index = indexPath.row
                AppDelegate.doccode = drcode[index]
                print("\(drcode[index])  \(AppDelegate.doccode)")
                self.performSegue(withIdentifier: "newhospital", sender: (Any).self)
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
    func settable(query: String, flag: Int?){
        var stmt:OpaquePointer?
        drcode.removeAll()
        celladapter.removeAll()
        
        let querystr = "select 1 _id,A.HOSCODE,A.HOSNAME,A.mobileno,A.address,B.typedesc,C.CityName as city from HOSPITALMASTER A left join CityMaster C on A.CityID= C.CityID inner join HospitalType B on A.type = B.typeid  where (A.HOSNAME like '%\(query)%' or A.ADDRESS like '%\(query)%' or A.MOBILENO like '%\(query)%') and A.HOSCODE not in ( select distinct hospitalcode from HospitalDRLinking where drcode = '\(AppDelegate.doccode)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let hoscode = String (cString: sqlite3_column_text(stmt, 1))
            let hosname = String (cString: sqlite3_column_text(stmt, 2))
            drcode.append(hoscode)
            self.celladapter.append(Attachdocadapter(docname: hosname,doccode: hoscode, cityname: "" ))
            if flag == 0 {
                self.selected.append("")
                self.flags.append(false)
            }
        }
        self.attachdoctable.reloadData()
        print("\(flags!)\n")
        print("\(selected!)\n")
    }
    
    @IBAction func addnewdoc(_ sender: UIButton) {
        if(AppDelegate.isDebug){
            print("HospitalListVC===\(AppDelegate.titletxt)")
            print("HospitalListVC===\(AppDelegate.source)")
            print("HospitalListVC===\(AppDelegate.hoscode)")
        }
        
        AppDelegate.hoscode = "HOS" + self.getIDNew()
    //    AppDelegate.doccode = "DOC" + self.getID()
        if(AppDelegate.isFromHospitalScreen){
            AppDelegate.source = "Hospital"
        }
        else{
              AppDelegate.source = "Retailer"
        }
    //     self.pushnext(identifier: "addhospital", controller: self)
        self.performSegue(withIdentifier: "newhospital", sender: (Any).self)
    }
    
    func showalertmsg(){
        let alert = UIAlertController(title: "Are you sure you want to attach", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            
            for i in 0..<self.celladapter.count {
                if self.flags[i]{
                    self.insertHospitalDRLinking(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), drcode: AppDelegate.doccode, hospitalcode:  self.celladapter[i].doccode, isblocked: "false", RECID: "", CREATEDBY: UserDefaults.standard.string(forKey: "usercode"), post: "0", CREATEDTRANSACTIONID: "", ModifiedTransactionId: "")
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
//            self.checknet()
//            if AppDelegate.ntwrk > 0 {
//            self.posthospitalMaster()
//             }
                       
          //  DispatchQueue.main.asyncAfter(deadline: .now()+1.00) {
             SwiftEventBus.post("updateprogress")
             SwiftEventBus.post("HospitalLinkingDone")
        //    }
            
            UIView.animate(withDuration: 0.3, animations: { ()->Void in
                self.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (finished) in
                self.view.removeFromSuperview()
//                SwiftEventBus.post("updateprogress")
//                SwiftEventBus.post("HospitalLinkingDone")
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
        
        if temp > 0
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
    
    @IBAction func backbtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}

