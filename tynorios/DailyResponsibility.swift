//  DailyResponsibility.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.

import UIKit
import SQLite3
import SwiftEventBus

class DailyResponsibility: Executeapi {
    
    @IBOutlet weak var RetailerValue: UILabel!
    @IBOutlet weak var SubDealerValue: UILabel!
    @IBOutlet weak var ComplaintValue: UILabel!
    @IBOutlet weak var EscalationValue: UILabel!
    @IBOutlet weak var DoctorValue: UILabel!
    @IBOutlet weak var HospitalValue: UILabel!
    @IBOutlet weak var SuperDealerValue: UILabel!
    
    @IBOutlet weak var teamManagment: CardView!
    @IBOutlet weak var escalationcard: CardView!
    @IBOutlet weak var complaint: CardView!
    @IBOutlet weak var doctorcard: CardView!
    @IBOutlet weak var hospitalcard: CardView!
    @IBOutlet weak var subdealer: CardView!
    @IBOutlet weak var superdealer: CardView!
    @IBOutlet weak var retailercard: CardView!
//    @IBOutlet weak var thirdstack: UIStackView!
//    @IBOutlet weak var secondstack: UIStackView!
//    @IBOutlet weak var firststack: UIStackView!
//    @IBOutlet weak var fourthstack: UIStackView!

    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.backscreenDel = ""
        self.checknet()
        if(AppDelegate.ntwrk > 0){
         DispatchQueue.global(qos: .userInitiated).async {
            self.showSyncloader(title: "Syncing")
           self.URL_GETUSERCUSTOMEROTHINFOAsync(customercode: "-1")
         }
      }
        SwiftEventBus.onMainThread(self, name: "gotusercust") { (Result) in
            self.countSet()
            self.hideSyncloader()
        }
        
        SwiftEventBus.onMainThread(self, name: "errorusercust") { (Result) in
           // self.countSet()
            self.hideSyncloader()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countSet()
        self.setnav(controller: self, title: "Daily Responsibility")
        
        if UserDefaults.standard.string(forKey: "usertype") == "12"
        {
            teamManagment.alpha=0
//            fourthstack.spacing = CGFloat(20)
        }
      
        retailercard.isUserInteractionEnabled = true
        let tapretailer = UITapGestureRecognizer(target: self, action: #selector(clickretailer))
        tapretailer.numberOfTapsRequired=1
        retailercard.addGestureRecognizer(tapretailer)
        
        subdealer.isUserInteractionEnabled = true
        let tapsubdealer = UITapGestureRecognizer(target: self, action: #selector(clickdealer))
        tapsubdealer.numberOfTapsRequired=1
        subdealer.addGestureRecognizer(tapsubdealer)
        
        doctorcard.isUserInteractionEnabled = true
        let tapdoctorcard = UITapGestureRecognizer(target: self, action: #selector(clickdoctor))
        tapdoctorcard.numberOfTapsRequired=1
        doctorcard.addGestureRecognizer(tapdoctorcard)
        
        hospitalcard.isUserInteractionEnabled = true
        let taphospitalcard = UITapGestureRecognizer(target: self, action: #selector(clickhospital))
        taphospitalcard.numberOfTapsRequired=1
        hospitalcard.addGestureRecognizer(taphospitalcard)
        
        complaint.isUserInteractionEnabled = true
        let tapcomplaintcard = UITapGestureRecognizer(target: self, action: #selector(clickcomplaint))
        tapcomplaintcard.numberOfTapsRequired=1
        complaint.addGestureRecognizer(tapcomplaintcard)
        
        escalationcard.isUserInteractionEnabled = true
        let tapescalationcard = UITapGestureRecognizer(target: self, action: #selector(clickescalation))
        tapescalationcard.numberOfTapsRequired=1
        escalationcard.addGestureRecognizer(tapescalationcard)
        
        superdealer.isUserInteractionEnabled = true
        let tapsuperdealer = UITapGestureRecognizer(target: self, action: #selector(clicksuperdealer))
        tapsuperdealer.numberOfTapsRequired=1
        superdealer.addGestureRecognizer(tapsuperdealer)
        
        teamManagment.isUserInteractionEnabled = true
        let tapteammagment = UITapGestureRecognizer(target: self, action: #selector(clickteammanagement))
        tapteammagment.numberOfTapsRequired=1
        teamManagment.addGestureRecognizer(tapteammagment)
    
   // hideviews()
    }
    
    @objc public func clickescalation(){
        //        self.performSegue(withIdentifier: "escalation", sender: (Any).self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "escalation") as! Escalationreportvc
        vc.tabbar = true
        vc.source  = "daily"
        self.navigationController?.pushViewController(vc, animated: true)
        print("escalation is clicked")
    }
    @objc public func clicksuperdealer(){
        //        self.performSegue(withIdentifier: "superdealer", sender: (Any).self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "superdealer") as! Superdealervc
        vc.titlebar = "Super Dealer"
        self.navigationController?.pushViewController(vc, animated: true)
        print("superdealer is clicked")
    }
    @objc public func clickretailer(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
        vc.titlebar = "Retailer"
        self.navigationController?.pushViewController(vc, animated: true)
        if(AppDelegate.isDebug){
            print("Retailer is clicked")
        }
    }
    @objc public func clickcomplaint(){
//        self.performSegue(withIdentifier: "complaint", sender: (Any).self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "complaint") as! Complaintreportvc
        vc.tabbar = true
        vc.source  = "daily"
        self.navigationController?.pushViewController(vc, animated: true)
        print("complaint is clicked")
    }
    @objc public func clickdealer(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
        vc.titlebar = "Sub Dealer"
        self.navigationController?.pushViewController(vc, animated: true)
        //  self.performSegue(withIdentifier: "doctor", sender: (Any).self)
        //    print("doctor is clicked")
        //   self.performSegue(withIdentifier: "subdealer", sender: (Any).self)
        print("sub-dealer is clicked")
    }
    @objc public func clickdoctor(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
        vc.titlebar = "Doctor"
         self.navigationController?.pushViewController(vc, animated: true)
      //  self.performSegue(withIdentifier: "doctor", sender: (Any).self)
        print("doctor is clicked")
    }
    @objc public func clickhospital(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
        vc.titlebar = "Hospital"
        self.navigationController?.pushViewController(vc, animated: true)
      //  self.performSegue(withIdentifier: "hospital", sender: (Any).self)
        print("hospital is clicked")
    }

    @objc func clickteammanagement(){
    var attndesc: String?
    attndesc  = self.checkattendance()
    if(attndesc=="Day Start"){
    let teammagement: TeamManegement = self.storyboard?.instantiateViewController(withIdentifier: "teammanagement") as! TeamManegement
        self.navigationController?.pushViewController(teammagement, animated: true)
    }
    else{
    self.showtoast(controller: self, message: "Attendance Marked : " + attndesc! , seconds: 2.0)
        }
      print("Team management is clicked")
    }
    
    func countSet()
    {
        var stmt:OpaquePointer? = nil
        let query = "select (select count(*) from retailermaster where customertype='CG0001' and isblocked='false') as retailercount,(select count(*) from retailermaster where customertype='CG0003' and isblocked='false') as doctorcount, (select count(*) from retailermaster where customertype='CG0004' and isblocked='false') as subdistributorcount,(select count(*) from retailermaster where customertype='CG0005' and isblocked='false') as hospitalcount,(select count(sitename) from USERDISTRIBUTOR where distributortype <> 'DT000001' and isdisplay = 'true') as superdealercount,(SELECT  ifnull(sum(ispendingcomplain),'0')  FROM USERCUSTOMEROTHINFO) as compcount,(SELECT  ifnull(sum(escalation),'0') FROM USERCUSTOMEROTHINFO) as escalationCount"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            if AppDelegate.usertype == "11"{
                self.RetailerValue.text  = String(cString: sqlite3_column_text(stmt,0 ))
                self.SubDealerValue.text = String(cString: sqlite3_column_text(stmt,2 ))
                self.ComplaintValue.text = String(cString: sqlite3_column_text(stmt,5))
                self.EscalationValue.text = String(cString: sqlite3_column_text(stmt,6))
            }
            else{
             self.RetailerValue.text  = String(cString: sqlite3_column_text(stmt,0 ))
             self.DoctorValue.text = String(cString: sqlite3_column_text(stmt,1 ))
             self.SubDealerValue.text = String(cString: sqlite3_column_text(stmt,2 ))
             self.HospitalValue.text = String(cString: sqlite3_column_text(stmt,3))
             self.SuperDealerValue.text = String(cString: sqlite3_column_text(stmt,4))
             self.ComplaintValue.text = String(cString: sqlite3_column_text(stmt,5))
             self.EscalationValue.text = String(cString: sqlite3_column_text(stmt,6))
            }
        }
    }

    @IBAction func backbtn(_ sender: UIButton) {
     let daily: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
     self.navigationController?.pushViewController(daily, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dealervc = segue.destination as?  UINavigationController,
            let vc = dealervc.topViewController as? Retailerlistvc {            
            if (segue.identifier == "retailer"){
               vc.titlebar = "Retailer"
            }
            if (segue.identifier == "subdealer"){
                vc.titlebar = "Sub Dealer"
            }
            if (segue.identifier == "hospital"){
                vc.titlebar = "Hospital"
            }            
            if (segue.identifier == "doctor"){
                vc.titlebar = "Doctor"
            }}
        if let complainvc = segue.destination as?  UINavigationController,
            let vc = complainvc.topViewController as? Complaintreportvc {
            if (segue.identifier == "complaint"){
               vc.tabbar = true
                vc.source = "daily"
            }
        }
        if let superdealervc = segue.destination as?  UINavigationController,
            let vc = superdealervc.topViewController as? Superdealervc {
            if (segue.identifier == "superdealer"){
                vc.titlebar = "Super Dealer"
            }
        }
        if let dealervc = segue.destination as?  UINavigationController,
            let vc = dealervc.topViewController as? Escalationreportvc {
            if (segue.identifier == "escalation"){
                vc.tabbar = true
                vc.source  = "daily"
            }
        }
    }
    func hideviews(){
//        if constant.onlyhidden {
//        teamManagment.isHidden = true
//        self.hideview(view: firststack)
//        self.hideview(view: secondstack)
//        self.hideview(view: thirdstack)
//        }
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
}
