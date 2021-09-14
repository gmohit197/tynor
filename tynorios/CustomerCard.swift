//
//  CustomerCard.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class CustomerCard: Executeapi {
    
    static var orderid: String? = ""
    var customercode: String?
    var customername: String?
    var pricegroup: String?
    static var siteid: String?
    static var stateid: String?
    var isescalated: String?
    var titletxt: String?
    var actionButton: ActionButton!
    static var plantstateid: String?
    static var plantcode: String?
    var atten: String?
    var lastactivity: String?
    var lastactivityid: String?
    var prescribe: String?
    var purchasing: String?
    var usercust: Bool = false
    var backscreen = ""
    
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var lastmonth: UILabel!
    @IBOutlet weak var reson2: UILabel!
    @IBOutlet weak var reson1: UILabel!
    @IBOutlet weak var escalation: CardView!
    @IBOutlet weak var takeorder: CardView!
    @IBOutlet weak var objection: CardView!
    @IBOutlet weak var noroder: CardView!
    @IBOutlet weak var likelyimg: UIImageView!
    @IBOutlet weak var likelylbl: UILabel!
    @IBOutlet weak var detailcard: CardView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var escalationCloseCard: CardView!
    @IBOutlet weak var reasononelbl: UILabel!
    @IBOutlet weak var reasontwolbl: UILabel!
    
    var subviews = [UIView]()
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.isDocScreen = false
        AppDelegate.isHosScreen = false
        AppDelegate.isRetScreen = false
        AppDelegate.popviewcontrolllercheck = false ;
        AppDelegate.chemistcheck = false ;
        AppDelegate.showDocList = true
        AppDelegate.showHosList = true
        AppDelegate.isFromSalesPersonList = false
        AppDelegate.isFromCustomerCardList = false
        AppDelegate.isChemist = false
        AppDelegate.isFromRetailerScreen = false
        AppDelegate.isFromDoctorScreen = false
        AppDelegate.isFromHospitalScreen = false
        
    //    AppDelegate.isFromRetailerListCustCard = false
        
        
        if(AppDelegate.backscreenDel == "TM"){
            backscreen = "TM"
        }
        else{
            backscreen = ""
        }
        
        if backscreen == "TM" {
            self.hideview(view: objection)
            self.hideview(view: noroder)
            self.titletxt = getcusttype(customercode: self.customercode!)
            Retailerlistvc.customername = self.customername
            AppDelegate.customercode = self.customercode!
            AppDelegate.titletxt = getcusttype(customercode: self.customercode!)
        }
//        AppDelegate.customercode = AppDelegate.oldcustomercodeFromRetailList
        print("CustomerCardList============"+self.customercode!)
        print("CustomerCardList============"+AppDelegate.customercode)
        self.checknet()
        if  AppDelegate.ntwrk > 0 {
          //  self.showSyncloader(title: "Syncing")
            URL_GETUSERCUSTOMEROTHINFOAsync(customercode: AppDelegate.customercode)
        }
        
        SwiftEventBus.onMainThread(self, name: "gotusercust") { (Result) in
            self.usercust = true
         //   self.hideSyncloader()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: customername!)
        print("CustomerName =====" + customername! )
      //  self.setnav(controller: self, title: "Bansal Kumar Store")

        if !constant.onlyhidden {
            setupButtons()
        }
        AppDelegate.isorderList=true
        AppDelegate.isFromCustomerCardList = false
        //hide close escalation tile by default
        self.hideview(view: escalationCloseCard)
        
        for _ in 0 ..< 5 {
            subviews.append(UIView())
        }
        if purchasing == "false"
        {
            self.hideview(view: takeorder)
        }
        
        getcarddetail(code: customercode)
        if titletxt == "Retailer" {
            self.hideview(view: objection)
        }
        if titletxt == "Escalation" {
            self.hideview(view: objection)
        }
        if titletxt == "Sub Dealer"
        {
            self.hideview(view: objection)
        }
        if backscreen == "TM" {
            self.hideview(view: objection)
            self.hideview(view: noroder)
            self.titletxt = getcusttype(customercode: self.customercode!)
        }
        if titletxt == "Super Dealer" {
            self.hideview(view: objection)
            self.likelylbl.text = "Likely to buy"
//            self.likelyimg.image = UIImage(named: "clandr1.png")
             self.likelyimg.image = UIImage(named: "likelytobuy_new.png")
            self.reasononelbl.text = "Likely to buy Reason 1"
            self.reasontwolbl.text = "Likely to buy Reason 2"
        }
        if titletxt == "Doctor"
        {
            self.getdoccode()
            if backscreen == "TM" {
                var stmt:OpaquePointer?
                let query = "select ispurchaseing from DRmaster where drcode = '\(AppDelegate.doccode)'"
                if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                    print("error preparing get: \(errmsg)")
                    return
                }
                while(sqlite3_step(stmt) == SQLITE_ROW){
                    let ispurchaseing = String(cString: sqlite3_column_text(stmt, 0))
                    if (ispurchaseing.lowercased() == "false"){
                        //show close escalation tile here
                        self.escalationCloseCard.isHidden = false
                    }
                }
            }
            self.hideview(view: noroder)
            self.reasononelbl.text = "Objection 1"
            self.reasontwolbl.text = "Objection 2"
        }
        if titletxt == "Hospital"
        {
            self.getdoccode()
            self.getHosCode()
            //            self.hideview(view: noroder)
        }
        if self.reson1.text == "" {
            self.reson1.text = "No Reason"
            self.reson1.textColor = UIColor.darkGray
        }
        if self.reson2.text == "" {
            self.reson2.text = "No Reason"
            self.reson2.textColor = UIColor.darkGray
        }
        
        escalation.isUserInteractionEnabled = true
        let tapescalation = UITapGestureRecognizer(target: self, action: #selector(clickescalation))
        tapescalation.numberOfTapsRequired=1
        escalation.addGestureRecognizer(tapescalation)
        
        noroder.isUserInteractionEnabled = true
        let tapnoroder = UITapGestureRecognizer(target: self, action: #selector(clicknoroder))
        tapnoroder.numberOfTapsRequired=1
        noroder.addGestureRecognizer(tapnoroder)
        
        objection.isUserInteractionEnabled = true
        let tapobjection = UITapGestureRecognizer(target: self, action: #selector(clickobjection))
        tapobjection.numberOfTapsRequired=1
        objection.addGestureRecognizer(tapobjection)
        
        takeorder.isUserInteractionEnabled = true
        let taptakeorder = UITapGestureRecognizer(target: self, action: #selector(clickTakeOrder))
        taptakeorder.numberOfTapsRequired=1
        takeorder.addGestureRecognizer(taptakeorder)
        
        hideviews()
       
    }
    
    @objc public func clickescalation(){
        atten = self.checkattendance()
        self.checknet()
        if  AppDelegate.ntwrk > 0 {
            if usercust {
                escalationValidation ()
            }
            else {
                self.showtoast(controller: self, message: "Data not sync...Please wait", seconds: 1.5) }
        }
        else{
            escalationValidation ()
        }
    }
    
    @objc public func clicknoroder()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            if usercust {
                noOrderReasonValidation()
            }else {
                self.showtoast(controller: self, message: "Data not sync...Please wait", seconds: 1.5)
            }
        }
        else{
            noOrderReasonValidation()
        }
    }
    @objc public func clickTakeOrder(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            if usercust{
                takeOrderValidation ()
            } else{
                self.showtoast(controller: self, message: "Data not sync...Please wait", seconds: 1.5)
            }
        }
        else{
            takeOrderValidation ()
        }
    }
    @objc public func clickobjection(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            if usercust{
                objectionValidation()
            }
            else{
                self.showtoast(controller: self, message: "Data not sync...Please wait", seconds: 1.5)
            }
        }
        else{
            objectionValidation()
        }
        
    }
    
    func getdoccode(){
        var stmt:OpaquePointer?
        let query = "select referencecode from RetailerMaster where customercode = '\(self.customercode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var doccode = ""
        while(sqlite3_step(stmt) == SQLITE_ROW){
            doccode = String(cString: sqlite3_column_text(stmt, 0))
        }
        AppDelegate.doccode = doccode
    }
    
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        if self.titletxt == "Super Dealer"{
            let superdealer: Superdealervc = self.storyboard?.instantiateViewController(withIdentifier: "superdealer") as! Superdealervc
            superdealer.titlebar = titletxt
            self.navigationController?.pushViewController(superdealer, animated: true)
        }
            
        else if backscreen == "TM" {
            let escalation: PendingEscalation = self.storyboard?.instantiateViewController(withIdentifier: "pendingescalation") as! PendingEscalation
            escalation.titlebar = self.titletxt
            self.navigationController?.pushViewController(escalation, animated: true)
        }
        else if self.titletxt == "Retailer" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            vc.titlebar = "Retailer"
            self.navigationController?.pushViewController(vc, animated: true)
            print("Retailer is clicked")
        }
        else if
            self.titletxt == "Sub Dealer" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            vc.titlebar = "Sub Dealer"
            self.navigationController?.pushViewController(vc, animated: true)
            print("sub-dealer is clicked")
        }
        else if
            self.titletxt == "Doctor" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            vc.titlebar = "Doctor"
            self.navigationController?.pushViewController(vc, animated: true)
            print("doctor is clicked")
        }
        else if
            self.titletxt == "Hospital" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            vc.titlebar = "Hospital"
            self.navigationController?.pushViewController(vc, animated: true)
            print("hospital is clicked")
        }
        else {
            self.performSegue(withIdentifier: "back", sender: (Any).self)
        }
    }
    
    func setupButtons(){
        
        let complaint = ActionButtonItem(title: "Complaint", image: #imageLiteral(resourceName: "cmpfloating"))
        
        complaint.action = { item in
            let complaintReport: ComplaintReport = self.storyboard?.instantiateViewController(withIdentifier: "complaintreport") as! ComplaintReport
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                if self.usercust {
                    if self.isescalated(customercode: self.customercode!){
                        if(self.attendanceValidation()){
                            self.atten = self.checkattendance()
                            if self.atten == "Day Start" {
                                // if self.isescalated(customercode: self.customercode!){
                                complaintReport.customercode = self.customercode
                                self.navigationController?.pushViewController(complaintReport, animated: true)
                                self.actionButton.toggleMenu()
                                //  }
                            }
                            else {
                                self.showtoast(controller: self, message: "Attendance marked \(self.atten!)", seconds: 1.5)
                            }
                        }
                    }
                }
                else{
                    self.showtoast(controller: self, message: "Data not sync...Please wait", seconds: 1.5)
                }
            }
            else {
                if self.isescalated(customercode: self.customercode!){
                    if(self.attendanceValidation()){
                        self.atten = self.checkattendance()
                        if self.atten == "Day Start" {
                            // if self.isescalated(customercode: self.customercode!){
                            complaintReport.customercode = self.customercode
                            self.navigationController?.pushViewController(complaintReport, animated: true)
                            self.actionButton.toggleMenu()
                            //  }
                        }
                        else {
                            self.showtoast(controller: self, message: "Attendance marked \(self.atten!)", seconds: 1.5)
                        }
                    }
                }
            }
        }
        
        
        let convert = ActionButtonItem(title: "Convert to Sub Dealer", image: #imageLiteral(resourceName: "subdealer_floating"))
        convert.action = { item in
            
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                if self.usercust{
                    if self.isescalated(customercode: self.customercode!){
                        if(self.attendanceValidation()){
                            self.atten = self.checkattendance()
                            if self.atten == "Day Start" {
                                //  if self.isescalated(customercode: self.customercode!)
                                //   {
                                self.clickconvertdealer()
                                //   }
                            }
                            else {
                                self.showtoast(controller: self, message: "Attendance marked \(self.atten!)", seconds: 1.5)
                            }
                        }
                    }
                }
                else{
                    self.showtoast(controller: self, message: "Data not sync...Please wait", seconds: 1.5)
                }
            }
            else{
                if self.isescalated(customercode: self.customercode!)
                {
                    if(self.attendanceValidation()){
                        if self.atten == "Day Start" {
                            //  if self.isescalated(customercode: self.customercode!)
                            //   {
                            self.clickconvertdealer()
                            //   }
                        }
                        else {
                            self.showtoast(controller: self, message: "Attendance marked \(self.atten!)", seconds: 1.5)
                        }
                    }
                    
                }
            }
        }
        
        let market = ActionButtonItem(title: "Market Intelligence", image: #imageLiteral(resourceName: "intelligencefloating"))
        market.action = { item in
            AppDelegate.isFromCustomerCardList = true
            AppDelegate.titletxt = self.titletxt!
          //   AppDelegate.isFromRetailerListCustCard = false
            if self.titletxt == "Doctor" {
                //open new mi form with counter's = 3
                //replace the below mi form with new one
                let market: AttachDoctorvc =  self.storyboard?.instantiateViewController(withIdentifier: "Attachdoc") as! AttachDoctorvc
                market.titletext = self.titletxt
                
                self.navigationController?.pushViewController(market, animated: true)
                self.actionButton.toggleMenu()
                AppDelegate.isFromDoctorScreen = true
            }
                
            else if self.titletxt == "Retailer"  {
                let market: MarketIntelligence =  self.storyboard?.instantiateViewController(withIdentifier: "mivc") as! MarketIntelligence
                
                market.custcode = self.customercode
                market.titletext = self.titletxt
                market.customername = self.customername!
                market.siteid = CustomerCard.siteid
                market.source = "customer"
             //   AppDelegate.isFromRetailerListCustCard = true
                self.navigationController?.pushViewController(market, animated: true)
                self.actionButton.toggleMenu()
                AppDelegate.isFromRetailerScreen = true
                
            }
            else if self.titletxt == "Hospital"{
                
                let market: AttachHospitalvc =  self.storyboard?.instantiateViewController(withIdentifier: "attachhos") as! AttachHospitalvc
                market.titletext = self.titletxt
                self.navigationController?.pushViewController(market, animated: true)
                self.actionButton.toggleMenu()
                AppDelegate.isFromHospitalScreen = true
                
            }
                
            else if self.titletxt == "Sub Dealer"{
                let market: MarketIntelligence =  self.storyboard?.instantiateViewController(withIdentifier: "mivc") as! MarketIntelligence
                
                market.custcode = self.customercode
                market.titletext = self.titletxt
                market.customername = self.customername!
                market.siteid = CustomerCard.siteid
                market.source = "customer"
                
                self.navigationController?.pushViewController(market, animated: true)
                self.actionButton.toggleMenu()
                
            }
        }
        
        let attachchemist = ActionButtonItem(title: "Attach Chemist", image: #imageLiteral(resourceName: "chemistfloating"))
        attachchemist.action = { item in
            
            let attachchemist: Attachchmistlist = self.storyboard?.instantiateViewController(withIdentifier: "attachchemist") as! Attachchmistlist
            attachchemist.source = "Doctor"
            attachchemist.custcode = self.customercode!
            if self.isescalated(customercode: self.customercode!){
                self.navigationController?.pushViewController(attachchemist, animated: true)
                self.actionButton.toggleMenu()
            }
        }
        
        if titletxt == "Retailer" || backscreen == "TM"
        {
            actionButton = ActionButton(attachedToView: self.view, items: [complaint, convert, market])
        }
        else if titletxt == "Super Dealer"
        {
            actionButton = ActionButton(attachedToView: self.view, items: [complaint])
        }
        else if titletxt == "Doctor"
        {
            actionButton = ActionButton(attachedToView: self.view, items: [complaint, attachchemist, market])
        }
        else
        {
            actionButton = ActionButton(attachedToView: self.view, items: [complaint,market])
        }
        
        actionButton.setTitle("+", forState: UIControlState())
        
        actionButton.backgroundColor = UIColor(red: 138.0 / 255.0, green: 17.0 / 255.0,
                                               blue: 84.0 / 255.0, alpha: 1.0)
        actionButton.action = {
            button in button.toggleMenu()
        }
    }
    @objc func clickconvertdealer() {
        
        var temp: Bool! = true
        var stmt1: OpaquePointer?
        //   var query = "select * from Subdealers where customercode ='\(customercode!)' and status= 0"
        
        var query = "select * from USERCUSTOMEROTHINFO where customercode ='\(customercode!)' and ispendingsubconv = '1'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            temp = false
            self.showtoast(controller: self, message: "The Retailer is under approval for conversion", seconds: 2.0)
            //  self.showtoast(controller: self, message: "Request Already Submitted", seconds: 2.0)
            break
        }
        if temp
        {
            let convertdealer: DealerConversion = self.storyboard?.instantiateViewController(withIdentifier: "dealerconvert") as! DealerConversion
            convertdealer.custcode = self.customercode
            convertdealer.siteid = CustomerCard.siteid
            convertdealer.titletext = self.titletxt
            self.navigationController?.pushViewController(convertdealer, animated: true)
            self.actionButton.toggleMenu()
        }
    }
    
    //    @objc func clickconvertdealer() {
    //
    //        var temp: Bool! = true
    //        var stmt1: OpaquePointer?
    //        var query = "select * from Subdealers where customercode ='\(customercode!)' and status= 0"
    //
    //        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
    //            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
    //            print("error preparing get: \(errmsg)")
    //            return
    //        }
    //
    //        while(sqlite3_step(stmt1) == SQLITE_ROW){
    //            temp = false
    //            self.showtoast(controller: self, message: "Request Already Submitted", seconds: 2.0)
    //            break
    //        }
    //        if temp
    //        {
    //            let convertdealer: DealerConversion = self.storyboard?.instantiateViewController(withIdentifier: "dealerconvert") as! DealerConversion
    //            convertdealer.custcode = self.customercode
    //            convertdealer.siteid = CustomerCard.siteid
    //            convertdealer.titletext = self.titletxt
    //            self.navigationController?.pushViewController(convertdealer, animated: true)
    //            self.actionButton.toggleMenu()
    //        }
    //    }
    
    public func getcarddetail(code: String?){
        var stmt:OpaquePointer?
        
        let query = "SELECT A.lms,A.avgsale,A.reasoN1 as reasoN1,A.reasoN2 as reasoN2 FROM 'USERCUSTOMEROTHINFO' A where customercode='" + code! + "'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            self.lastmonth.text = "   " +  String(cString: sqlite3_column_text(stmt, 0))
            self.month.text = "   " + String(cString: sqlite3_column_text(stmt, 1))
            self.reson1.text = String(cString: sqlite3_column_text(stmt, 2))
            self.reson2.text = String(cString: sqlite3_column_text(stmt, 3))
        }
    }
    
    func escalateIntent(){
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "marketescalation") as! Marketescalationvc
        vc.titlebar = "Escalation Marking"
        vc.ccardtitle = self.titletxt
        vc.customercode = self.customercode
        vc.customername = self.customername
        vc.siteid = CustomerCard.siteid
        vc.purchasing = self.purchasing
        self.navigationController?.pushViewController(vc, animated: true)
        print("escalation is clicked")
    }
    
    func noOrderIntent(){
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let vc = storyboard.instantiateViewController(withIdentifier: "marketescalation") as! Marketescalationvc
        if titletxt == "Super Dealer"{
            vc.titlebar = "Likely to buy"
        }
        else {
            vc.titlebar = "Reason For No Order"
        }
        vc.ccardtitle = self.titletxt
        vc.customercode = self.customercode
        vc.customername = self.customername
        vc.siteid = CustomerCard.siteid
        self.navigationController?.pushViewController(vc, animated: true)
        print("No Order is clicked")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "back"){
            if let dealervc = segue.destination as?  UINavigationController,
                let vc = dealervc.topViewController as? Retailerlistvc {
                vc.titlebar = self.titletxt!
            }
        }
        
        if (segue.identifier == "escalate") {
            if let dealervc = segue.destination as?  UINavigationController,
                let vc = dealervc.topViewController as? Marketescalationvc {
                vc.titlebar = "Escalation Marking"
                vc.ccardtitle = self.titletxt
                vc.customercode = self.customercode
                vc.customername = self.customername
                vc.siteid = CustomerCard.siteid
                vc.purchasing = self.purchasing
            }
        }
        
        if (segue.identifier == "noorder") {
            if let dealervc = segue.destination as?  UINavigationController,
                let vc = dealervc.topViewController as? Marketescalationvc {
                if titletxt == "Super Dealer"{
                    vc.titlebar = "Likely to buy"
                }
                else {
                    vc.titlebar = "Reason For No Order"
                }
                vc.ccardtitle = self.titletxt
                vc.customercode = self.customercode
                vc.customername = self.customername
                vc.siteid = CustomerCard.siteid
            }
        }
    }
    
    func hideviews(){
        if constant.onlyhidden {
            hideview(view: escalation)
            hideview(view: objection)
            hideview(view: noroder)
        }
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    func objectionValidation(){
        if isescalated(customercode: customercode!)
        {
            if(self.attendanceValidation()){
                atten = self.checkattendance()
                if atten == "Day Start" {
                    //            if isescalated(customercode: customercode!)
                    //            {
                    lastactivityid = self.checkvalidation(customercode: customercode!)
                    if lastactivityid == "0" || lastactivityid == "-1" {
                        let market: Marketescalationvc = self.storyboard?.instantiateViewController(withIdentifier: "marketescalation") as! Marketescalationvc
                        market.customercode = self.customercode
                        market.titlebar = "Objection Report"
                        market.ccardtitle = titletxt
                        market.customername = self.customername
                        market.customercode = self.customercode
                        market.siteid = CustomerCard.siteid
                        market.purchasing = self.purchasing
                        self.navigationController?.pushViewController(market, animated: true)
                        print("objection is clicked")
                    }
                    else  {
                        self.showtoast(controller: self, message: "Call counted for today", seconds: 1.5)
                    }
                    //    }
                }
                else {
                    self.showtoast(controller: self, message: "Attendance marked \(atten!)", seconds: 1.5)
                }
                
            }
        }
    }
    func noOrderReasonValidation () {
        if self.isescalated(customercode: customercode!) {
            if(self.attendanceValidation()){
                atten = self.checkattendance()
                if atten == "Day Start" {
                    // if self.isescalated(customercode: customercode!) {
                    lastactivityid = self.checkvalidation(customercode: customercode!)
                    if lastactivityid == "0" || lastactivityid == "-1"{
                        self.noOrderIntent()
//                        self.performSegue(withIdentifier: "noorder", sender: (Any).self)
                    }
                    else{
                        self.showtoast(controller: self, message: "Call counted for today", seconds: 1.5)
                    }
                    //   }
                }
                else {
                    self.showtoast(controller: self, message: "Attendance marked \(atten!)", seconds: 1.5)
                }
            }
        }
    }
    
    func takeOrderValidation () {
        if isescalated(customercode: customercode!)
        {
            if(self.attendanceValidation()){
                lastactivityid = self.checkvalidation(customercode: customercode!)
                if lastactivityid == "0" || lastactivityid == "1" || lastactivityid == "-1" || lastactivityid == "3"{
                    if (self.titletxt == "Super Dealer" || self.titletxt == "" ) {
                        let primaryorderlist: Primaryorderlist = self.storyboard?.instantiateViewController(withIdentifier: "primaryorderlist") as! Primaryorderlist
                        
                        primaryorderlist.customercode = self.customercode
                        primaryorderlist.customername = self.customername
                        primaryorderlist.siteid = CustomerCard.siteid
                        primaryorderlist.pricegroup = self.pricegroup
                        primaryorderlist.stateid = CustomerCard.stateid
                        primaryorderlist.plantcode = CustomerCard.plantcode
                        primaryorderlist.plantstateid = CustomerCard.plantstateid
                        primaryorderlist.titletext = self.titletxt
                        self.navigationController?.pushViewController(primaryorderlist, animated: true)
                    }
                    else{
                        let orderlist: OrderListViewController = self.storyboard?.instantiateViewController(withIdentifier: "orderlist") as! OrderListViewController
                        
                        orderlist.customercode = self.customercode
                        orderlist.customername = self.customername
                        orderlist.siteid = CustomerCard.siteid
                        orderlist.pricegroup = self.pricegroup
                        orderlist.stateid = CustomerCard.stateid
                        orderlist.titletext = self.titletxt
                        self.navigationController?.pushViewController(orderlist, animated: true)
                    }
                    Retailerlistvc.pricegroup = self.pricegroup
                    print("Take Order is clicked")
                }
                else{
                    self.showtoast(controller: self, message: "Call counted for today", seconds: 1.5)
                }
            }
        }
    }
    func escalationValidation () {
        if self.isescalated(customercode: customercode!) {
            if(self.attendanceValidation()){
                if atten == "Day Start" {
                    //    if self.isescalated(customercode: customercode!) {
                    lastactivityid = self.checkvalidation(customercode: customercode!)
                    if lastactivityid == "0" || lastactivityid == "-1" || lastactivityid == "3" {
                        self.escalateIntent()
                    //    self.performSegue(withIdentifier: "escalate", sender: (Any).self)
                    }
                    else{
                        self.showtoast(controller: self, message: "Call counted for today", seconds: 1.5)
                    }
                    //  }
                }
                else {
                    self.showtoast(controller: self, message: "Attendance marked \(atten!)", seconds: 1.5)
                }
            }
        }
    }
    
    
    
    func getHosCode(){
        var stmt:OpaquePointer?
        let query = "select HOSCODE from HospitalMaster where  custrefcode='\(self.customercode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var hoscode = ""
        while(sqlite3_step(stmt) == SQLITE_ROW){
            hoscode = String(cString: sqlite3_column_text(stmt, 0))
        }
        AppDelegate.hoscode = hoscode
    }
}


