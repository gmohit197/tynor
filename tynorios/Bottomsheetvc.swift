//
//  Bottomsheetvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 29/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class Bottomsheetvc:  UIViewController,UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = textView.text
        
        var numberOfChars:Int?
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 && newText!.count==0 {
                return true
            }
            if isBackSpace == -92{
                numberOfChars = newText!.count-1
            }
            else{
                numberOfChars = newText!.count + 1
            }
        }
        //        guard range.location == 0 else {
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            //                    SwiftEventBus.post("getcount")
            if numberOfChars! > 500 && isBackSpace == -92{
                //                    return true
            }
            else if numberOfChars! <= 500 {
                self.counter.text = String(500 - numberOfChars!) + "/500"
            }
            else {
                let base = Baseactivity()
                base.showtoast(controller: self, message: "Maximum Limit Reached", seconds: 1.0)
            }
        }
        //            return true
        //        }
        
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    
    public var portraitSize: CGSize = .zero
    var head: String! = ""
    var customercode: String!
    var siteid: String!
    
    @IBOutlet weak var reasonspinner: DropDownUtil!
    @IBOutlet weak var secondlbldetail: UILabel!
    @IBOutlet weak var secondlbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var firstlbl: UILabel!
    @IBOutlet weak var datetext: UILabel!
    @IBOutlet weak var typelable: UILabel!
    @IBOutlet weak var lineview: UIView!
    @IBOutlet weak var dateLikelytobuy: UIStackView!
    @IBOutlet weak var dateLikely: UITextField!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    
    public var datePicker: UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    
    @IBAction func close(_ sender: UIButton) {
        removebottomsheet()
    }
    
    var selection: String!
    var id: String!
    var idarr: [String]!
    @IBOutlet weak var counter: UILabel!
    
    @IBOutlet var desc: UITextView!
    @IBOutlet weak var secondPreviewView: UIView!
    
    enum InitialState {
        case contracted
        case expanded
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add your descripition here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reasonspinner.optionArray = []
        reasonspinner.optionIds? = []
        idarr = []
        let base = Baseactivity()
        self.datelbl.text = base.getTodaydatetime()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
         
               let toolbar = UIToolbar();
               toolbar.sizeToFit()
               let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
               let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
               let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

               toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
               
               dateLikely.inputAccessoryView = toolbar
               dateLikely.inputView = datePicker
                       
        formatter.dateFormat = "yyyy-MM-dd"
        //        let result = formatter.string(from: date)
        //        dateLikely.text = result
        self.datePicker?.todatecheck()
        
        desc.delegate = self
        secondPreviewView.layer.shadowColor = UIColor.black.cgColor
        secondPreviewView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        secondPreviewView.layer.shadowOpacity = 2.0
        if #available(iOS 11.0, *){
            secondPreviewView.clipsToBounds = false
            secondPreviewView.layer.cornerRadius = 15
            secondPreviewView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = secondPreviewView.frame
            rectShape.position = secondPreviewView.center
            rectShape.path = UIBezierPath(roundedRect: secondPreviewView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
            secondPreviewView.layer.backgroundColor = UIColor.green.cgColor
            secondPreviewView.layer.mask = rectShape
        }
        
        desc.text = "Add your descripition here..."
        desc.textColor = UIColor.lightGray
        
        //        let tapdesc = UITapGestureRecognizer(target: self, action: #selector(clickdesc))
        //        tapdesc.numberOfTapsRequired = 1
        //        desc.addGestureRecognizer(tapdesc)
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: secondPreviewView.frame.maxY)
        //        willMoveToStickyPoint = { point in
        //            print("willMoveToStickyPoint \(point)")
        //        }
        //
        //        didMoveToStickyPoint = { point in
        //            print("didMoveToStickyPoint \(point)")
        //        }
        //
        //        onDrag = { point in
        //            print("onDrag: \(point)")
        //        }
        self.firstlbl.text = "Add " + head
        
        if head == "Escalation" {
            self.secondlbl.text = "Escalation No."
            self.datelbl.text = base.getTodaydatetime()
            base.hideview(view: dateLikelytobuy)
            //base.hideview(view: descriptionlbl)
        }
        else if head == "Reason" {
            let screenSize = UIScreen.main.bounds.size
            
            self.view.frame  = CGRect(x: 0, y: 0, width: screenSize.width, height:  self.view.frame.height - 300)
            print("screen frame height====>\(self.view.frame.height)")
            
            let base =  Baseactivity()
            base.hideview(view: datelbl)
            base.hideview(view: datetext)
            base.hideview(view: secondlbl)
            base.hideview(view: secondlbldetail)
            base.hideview(view: lineview)
            base.hideview(view: dateLikelytobuy)
            
            self.firstlbl.text = "Reason for no order"
            self.secondlbl.text = "Reason No."
            self.typelable.text = "Reason Type"
        }
        else if head == "Likely"
        {
            let base =  Baseactivity()
            base.hideview(view: datelbl)
            base.hideview(view: datetext)
            base.hideview(view: secondlbl)
            base.hideview(view: secondlbldetail)
            base.hideview(view: lineview)
            
            self.firstlbl.text = "Likely To Buy"
            self.secondlbl.text = "Reason No."
            self.typelable.text = "Reason Type"
        }
        else if head == "Objection"
        {
            let base =  Baseactivity()
            self.secondlbl.text = "Objection No."
            self.typelable.text = "Objections:"
            self.datelbl.text = base.getdate()
            base.hideview(view: dateLikelytobuy)
          //  base.hideview(view: secondlbldetail)
        }
        
        self.secondlbldetail.text = base.getID()
        setescalationspinner()
        reasonspinner.didSelect { (selected, index, id) in
            print("selected============> \(selected)")
            print("ID============> \(id)")
            self.selection = selected
            self.id = String(self.idarr[index])
            
        }
        self.secondlbldetail.numberOfLines = 3
    
        SwiftEventBus.onMainThread(self, name: "getcount")
        {
            Result in
            let newText = self.desc.text
            let numberOfChars = newText!.count
            if numberOfChars <= 500{
                self.counter.text = String(500 - numberOfChars) + "/500"
            }
            else{
                let base = Baseactivity()
                base.showtoast(controller: self, message: "Maximum Limit Reached", seconds: 1.0)
            }
        }
    }
    
    @objc func donedatePicker(){
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          dateLikely.text = formatter.string(from: self.datePicker!.date)
          self.view.endEditing(true)
      }
    
      @objc func cancelDatePicker(){
          self.view.endEditing(true)
      }
    
    @objc func clickdesc () {
        desc.isEditable = true
        //       let newPosition = desc.beginningOfDocument
        //        desc.selectedTextRange = textView.textRangeFromPosition(newPosition, toPosition: newPosition)
    }
    
    @objc func fromdate(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dateLikely.text = dateFormatter.string(from: datePicker.date)
    }
    
    func removebottomsheet(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.view.frame  = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
        })
        { (finished) in
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
        AppDelegate.blureffectview.removeFromSuperview()
        print("cancel")
    }
    
   
    
    func setescalationspinner (){
        idarr.removeAll()
        var stmt1:OpaquePointer?
        var query: String! = ""
        if head == "Escalation" {
            query = "Select '0' as reasoncode,'Select' as reasondescription union Select reasoncode,reasondescription from EscalationReason where isblock='BLOCK'"
        }
        else if head == "Reason" {
            query = "select '0' as reasoncode,'Select' as reasondescription union  select reasoncode,reasondescription from NoOrderReasonMaster where isblock='BLOCK'"
        }
        else if head == "Likely" {
            query = "select '0' as reasoncode,'Select' as reasondescription union  select reasoncode,reasondescription from NoOrderReasonMaster where isblock='BLOCK'"
        }
        else if head == "Objection" {
            query = "select '0' as objectioncode,'Select' as objectiondesc union  select objectioncode,objectiondesc from ObjectionMaster where isblocked='false'"
        }
        self.reasonspinner.optionArray.removeAll()
        self.reasonspinner.optionIds?.removeAll()
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let reasondesc = String(cString: sqlite3_column_text(stmt1, 1))
            let reasoncode = String(cString: sqlite3_column_text(stmt1, 0))
            let reasoncodestring = String(cString: sqlite3_column_text(stmt1, 0))
            
            reasonspinner.optionArray.append(reasondesc)
            reasonspinner.optionIds?.append(Int(reasoncode) ?? 0)

         //   reasonspinner.optionIds?.append(reasoncode)
            idarr.append(reasoncodestring)
        }
        reasonspinner.text = reasonspinner.optionArray[0] 
    }
    
//    @IBAction func submitbtn(_ sender: UIButton) {
//        let base = Baseactivity()
//        let postapi = Postapi()
//
//        if (self.reasonspinner.text != "Select") {
//            if self.desc.text == "Add your descripition here..." || self.desc.text.isEmpty {
//                base.showtoast(controller: self, message: "Please add description...", seconds: 1.5)
//            }
//            else {
//                let database = Databaseconnection()
//                if head == "Escalation" {
//                    database.insertescalationreport(dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, escalationid: self.secondlbldetail.text! as NSString, customercode: self.customercode! as NSString, siteid: AppDelegate.siteid as NSString, submittime: self.datelbl.text! as NSString, createdby: UserDefaults.standard.string(forKey: "usercode")! as NSString, status: "OPEN", remark: self.desc.text! as NSString, reasoncode: self.id as NSString, username: "", closeremarks: "", post: "0", latitude: "0", longitude: "0")
//                    let data = Databaseconnection()
//                    data.updatelastvisitidForEscalation(lastvistactivityid: "3", customercode: customercode)
//                    postapi.postmarketescalation()
//                    base.self.showtoast(controller: self, message: "Escalation Submitted", seconds: 1.5)
//                    removebottomsheet()
//                    SwiftEventBus.post("gotoCustomercard")
//
//                }
//                else if head == "Reason" {
//                    database.insertnoorderremarkpost(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, STATUSID: self.secondlbldetail.text! as NSString, REASONCODE: self.id as NSString, CUSTOMERCODE: self.customercode! as NSString, SITEID: AppDelegate.siteid as NSString, SUBMITTIME: self.datelbl.text! as NSString, remarks: self.desc.text! as NSString, LATITUDE: "0", LONGITUDE: "0", USERCODE: UserDefaults.standard.string(forKey: "usercode")! as NSString, ISMOBILE: UserDefaults.standard.string(forKey: "ismobile")! as NSString, post: "0", date: "1900-01-01")
//                    let data = Databaseconnection()
//                    data.updatelastvisitid(lastvistactivityid: "2", customercode: customercode)
//                    postapi.postNoOrderReason()
//                    base.self.showtoast(controller: self, message: "Reason submitted successfully", seconds: 1.5)
//                    removebottomsheet()
//                    SwiftEventBus.post("gotoCustomercard")
//                }
//                else if head == "Likely" {
//                    if !(self.dateLikely.text!.isEmpty)
//                    {
//                        database.insertnoorderremarkpost(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, STATUSID: self.secondlbldetail.text! as NSString, REASONCODE: self.id as NSString, CUSTOMERCODE: self.customercode! as NSString, SITEID: AppDelegate.siteid as NSString, SUBMITTIME: self.datelbl.text! as NSString, remarks: self.desc.text! as NSString, LATITUDE: "0", LONGITUDE: "0", USERCODE: UserDefaults.standard.string(forKey: "usercode")! as NSString, ISMOBILE: UserDefaults.standard.string(forKey: "ismobile")! as NSString, post: "0", date: self.dateLikely.text! as NSString)
//                        let data = Databaseconnection()
//                        data.updatelastvisitid(lastvistactivityid: "2", customercode: customercode)
//                        postapi.postNoOrderReason()
//                        base.showtoast(controller: self, message: "Likely To Buy Submitted successfully", seconds: 1.5)
//                        removebottomsheet()
//                        SwiftEventBus.post("gotoCustomercard")
//                    }
//                    else{
//                        base.showtoast(controller: self, message: "Please Select Likely to Buy Date", seconds: 1.5)
//                    }
//                }
//                else if head == "Objection" {
//                    database.insertObjectionEntry(objectioncode: self.id as NSString, objectionid: self.secondlbldetail.text! as NSString, dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, customercode: self.customercode! as NSString, siteid: AppDelegate.siteid as NSString, submittime: self.datelbl.text! as NSString, status: "OPEN", remarks: self.desc.text! as NSString, latitude: "0", longitude: "0", userid: UserDefaults.standard.string(forKey: "usercode")! as NSString, post: "0")
//                    let data = Databaseconnection()
//                    data.updatelastvisitid(lastvistactivityid: "4", customercode: customercode)
//                    postapi.postObjectionEntry()
//                    removebottomsheet()
//                    SwiftEventBus.post("gotoCustomercard")
//                }
//
//            }
//        }
//        else {
//            base.showtoast(controller: self, message: "Select Reason", seconds: 1.5)
//        }
//    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
            
           let base = Baseactivity()
           let postapi = Postapi()
           
                   let database = Databaseconnection()
                   AppDelegate.custCodeBottomSheet = self.customercode!
                    if head == "Escalation" && self.validate(){
                        database.insertescalationreport(dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, escalationid: self.secondlbldetail.text! as NSString, customercode: self.customercode! as NSString, siteid: AppDelegate.siteid as NSString, submittime: self.datelbl.text! as NSString, createdby: UserDefaults.standard.string(forKey: "usercode")! as NSString, status: "OPEN", remark: self.desc.text! as NSString, reasoncode: self.id as NSString, username: "", closeremarks: "", post: "0", latitude: "0", longitude: "0")
                       let data = Databaseconnection()
                       data.updatelastvisitidForEscalation(lastvistactivityid: "3", customercode: customercode)
                       postapi.postmarketescalation()
                       base.self.showtoast(controller: self, message: "Escalation Submitted", seconds: 1.5)
                       removebottomsheet()
                       SwiftEventBus.post("gotoCustomercard")
                       
                   }
                   else if head == "Reason" && self.validate(){
                       database.insertnoorderremarkpost(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, STATUSID: self.secondlbldetail.text! as NSString, REASONCODE: self.id as NSString, CUSTOMERCODE: self.customercode! as NSString, SITEID: AppDelegate.siteid as NSString, SUBMITTIME: self.datelbl.text! as NSString, remarks: self.desc.text! as NSString, LATITUDE: "0", LONGITUDE: "0", USERCODE: UserDefaults.standard.string(forKey: "usercode")! as NSString, ISMOBILE: UserDefaults.standard.string(forKey: "ismobile")! as NSString, post: "0", date: "1900-01-01")
                       let data = Databaseconnection()
                       data.updatelastvisitid(lastvistactivityid: "2", customercode: customercode)
                       postapi.postNoOrderReason()
                       base.self.showtoast(controller: self, message: "Reason submitted successfully", seconds: 1.5)
                       removebottomsheet()
                       SwiftEventBus.post("gotoCustomercard")
                   }
                   else if head == "Likely" && self.validateLikelyBuy() {
                      
                           database.insertnoorderremarkpost(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, STATUSID: self.secondlbldetail.text! as NSString, REASONCODE: self.id as NSString, CUSTOMERCODE: self.customercode! as NSString, SITEID: AppDelegate.siteid as NSString, SUBMITTIME: self.datelbl.text! as NSString, remarks: self.desc.text! as NSString, LATITUDE: "0", LONGITUDE: "0", USERCODE: UserDefaults.standard.string(forKey: "usercode")! as NSString, ISMOBILE: UserDefaults.standard.string(forKey: "ismobile")! as NSString, post: "0", date: self.dateLikely.text! as NSString)
                           let data = Databaseconnection()
                           data.updatelastvisitid(lastvistactivityid: "2", customercode: customercode)
                           postapi.postNoOrderReason()
                           base.showtoast(controller: self, message: "Likely To Buy Submitted successfully", seconds: 1.5)
                           removebottomsheet()
                           SwiftEventBus.post("gotoCustomercard")
                      
                   }
                   else if head == "Objection" && self.validate() {
                        
                       database.insertObjectionEntry(objectioncode: self.id as NSString, objectionid: self.secondlbldetail.text! as NSString, dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, customercode: self.customercode! as NSString, siteid: AppDelegate.siteid as NSString, submittime: self.datelbl.text! as NSString, status: "OPEN", remarks: self.desc.text! as NSString, latitude: "0", longitude: "0", userid: UserDefaults.standard.string(forKey: "usercode")! as NSString, post: "0")
                       let data = Databaseconnection()
                       data.updatelastvisitid(lastvistactivityid: "4", customercode: customercode)
                       postapi.postObjectionEntry()
                       removebottomsheet()
                       SwiftEventBus.post("gotoCustomercard")
                   }
                   
               }

    func validate() -> Bool {
     var validate = true
         let base = Baseactivity()
        if (self.reasonspinner.text == "Select") {
            base.showtoast(controller: self, message: "Select Reason", seconds: 1.5)
            validate=false
        }
       else if self.desc.text == "Add your descripition here..." || self.desc.text.isEmpty {
            base.showtoast(controller: self, message: "Please add description...", seconds: 1.5)
            validate=false
        }
     return validate
    }
    
    func validateLikelyBuy() -> Bool {
     var validate = true
         let base = Baseactivity()
        
        if (self.reasonspinner.text == "Select") {
            base.showtoast(controller: self, message: "Select Reason", seconds: 1.5)
            validate=false
        }
        
      else if (self.dateLikely.text!.isEmpty)
        {     validate=false
             base.showtoast(controller: self, message: "Please Select Likely to Buy Date", seconds: 1.5)
        }
        
        else  if (self.desc.text == "Add your descripition here..." || self.desc.text.isEmpty) {
            base.showtoast(controller: self, message: "Please add description...", seconds: 1.5)
            validate=false
        }
     return validate
    }
}
