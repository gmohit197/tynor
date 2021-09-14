//
//  Marketescalationvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 27/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3
import SwiftEventBus

class Marketescalationvc: Executeapi, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource ,PromotionalDelegate  {
func setstate(at index: IndexPath, state: Bool) {
    
    let list: Prmotionaladapter

    list = promotionaladapter[index.row]

    list.state = state
}
    
    var controller:Bottomsheetvc?
    var BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var BlurEffectView = UIVisualEffectView()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotionaladapter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

         
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Reasonordercell

          

          let list: Prmotionaladapter

          list = promotionaladapter[indexPath.row]

      
          cell.promotionalitem.isSelected = list.state!

      }

      

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Reasonordercell

          let list: Prmotionaladapter

          list = promotionaladapter[indexPath.row]
          cell.promotionalitem.setTitle(list.itemname, for: UIControlState.normal)

          cell.promotionalitem.isSelected = list.state!
          cell.index = indexPath
          cell.delegate = self
        return cell

      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return escalationreport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketcell", for: indexPath) as! Marketescalationcell
        let list: Escalationcelladapter
        list = escalationreport[indexPath.row]
        cell.escalationno.numberOfLines = 2
        cell.date.numberOfLines = 2
        cell.date.text = list.customername
        cell.escalationno.text = list.escalationno
        cell.reason.text = list.reason
        cell.status.text = list.status
        cell.cretedby.text = list.createdby
        
        //escalationno: objectionid, customername: submittime, status: "", reason: remarks))
        if (self.titlebar == "Escalation Marking"){
            cell.escalationlbl.text = "Escalation No."
            cell.status.isHidden = false
            cell.statusStack.isHidden = false
        }
        else if (self.titlebar == "Reason For No Order" || self.titlebar == "Likely to buy"){
            cell.escalationlbl.text = "Reason Code"
            cell.status.isHidden = true
            cell.statusStack.isHidden = true
            cell.cretedByStack.isHidden = true
        }
        else if (self.titlebar == "Objection Report"){
            cell.escalationlbl.text = "Objection Code"
            cell.status.isHidden = true
            cell.statusStack.isHidden = true
            cell.cretedByStack.isHidden = true
        }
        return cell
    }
    
    private func makeSearchViewControllerIfNeeded() -> Bottomsheetvc {
        let currentPullUpController = childViewControllers
            .filter({ $0 is Bottomsheetvc })
            .first as? Bottomsheetvc
        let pullUpController: Bottomsheetvc = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "bottomsheet") as! Bottomsheetvc
        
        if (self.titlebar == "Escalation Marking"){
            pullUpController.head = "Escalation"
            
        }
        else if (self.titlebar == "Reason For No Order"){
            pullUpController.head = "Reason"
        }
        else if (self.titlebar == "Objection Report"){
            pullUpController.head = "Objection"
        }
        pullUpController.customercode = self.customercode
        pullUpController.siteid = self.siteid
        
        return pullUpController
    }
    var customername: String!
    
    var url: String!
    var ccardtitle: String!
    var titlebar: String?
    var customercode: String?
    var siteid: String?
    var purchasing: String?
    var escalatioarr: [String]!
    static var flag: Bool = false
    
    
    @IBOutlet var rootview: UIView!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    var escalationreport = [Escalationcelladapter]()
    var promotionaladapter = [Prmotionaladapter]()
    
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    
    @IBOutlet weak var Escalationtable: UITableView!
    @IBOutlet weak var promitionalitem: UICollectionView!
    
    var objectioncodearr: [String]!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var escalationcode: UILabel!
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var escalationlbl: UILabel!
    @IBOutlet weak var detailtxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubview(toBack: detailview)
        self.setnav(controller: self, title: titlebar!)
        AppDelegate.isBottomSheetSync = 0
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        objectioncodearr = []
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        escalatioarr = []
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        
        self.escalationcode.numberOfLines = 2
        
               let toolbar = UIToolbar();
               let toolbar1 = UIToolbar();
               toolbar.sizeToFit()
               toolbar1.sizeToFit()
               let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
               let donetButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatetPicker));
               let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
               let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
               let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
               let canceltButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

               toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
               
               fromdate.inputAccessoryView = toolbar
               fromdate.inputView = datePicker
               
               toolbar1.setItems([donetButton,spacetButton,canceltButton], animated: false)
               
               todate.inputAccessoryView = toolbar1
               todate.inputView = datePicker2
        self.datePicker?.fromdatecheck()
       self.datePicker2?.fromdatecheck()
//        fromdate.text = self.getdate()
//        todate.text = self.getdate()
        
        Escalationtable.delegate = self
        Escalationtable.dataSource = self
        self.setpromotionalitem()
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getdetailview))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.Escalationtable.addGestureRecognizer(tapeno)
//        let tapdetail = UITapGestureRecognizer(target: self, action: #selector(closedetail))
//        tapdetail.numberOfTapsRequired=2
//        self.detailview.addGestureRecognizer(tapdetail)
        let detailhide = UITapGestureRecognizer(target: self, action: #selector(closedetail))
        self.rootview.addGestureRecognizer(detailhide)
        
        if titlebar == "Escalation Marking" {
            self.addbtn.setTitle("Escalate", for: .normal)
            self.navigationItem.title = titlebar
        }
        else if titlebar == "Reason For No Order" {
            self.addbtn.setTitle("Add Reason", for: .normal)
            self.navigationItem.title = titlebar
        }
        else if titlebar == "Likely to buy"{
            self.addbtn.setTitle("Add Reason", for: .normal)
            self.navigationItem.title = titlebar
        }
        else if titlebar == "Objection Report" {
            self.addbtn.setTitle("Add Objection", for: .normal)
            self.navigationItem.title = titlebar
        }
        
        SwiftEventBus.onMainThread(self, name: "gotoCustomercard")
        {
            Result in
            
            let custcard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            custcard.titletxt = self.ccardtitle
            custcard.customercode = self.customercode
            custcard.customername = self.customername
            custcard.purchasing = self.purchasing
             
            if(custcard.customercode == AppDelegate.custCodeBottomSheet && AppDelegate.isBottomSheetSync == 0){
                AppDelegate.isBottomSheetSync = 1
                self.navigationController?.pushViewController(custcard, animated: true)
            }
        }
    }
    
    
  
    @objc func closedetail () {
        view.sendSubview(toBack: detailview)
        removeBlurView()
    }
    
    @objc func donedatePicker(){
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          fromdate.text = formatter.string(from: self.datePicker!.date)
          self.view.endEditing(true)
      }
      @objc func donedatetPicker(){
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          todate.text = formatter.string(from: self.datePicker2!.date)
          self.view.endEditing(true)
      }
      @objc func cancelDatePicker(){
          self.view.endEditing(true)
      }
    
    @objc func getdetailview(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.Escalationtable)
        if let indexPath = Escalationtable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            self.getescalationdetail(eno: escalatioarr[index])
            print("\n \(self.escalatioarr[index])")
        }
    }
    @objc func singleTapped() {
        // do something here
        view.endEditing(true)
    }
    
    @IBAction func cancelbtn(_ sender: Any) {
        view.sendSubview(toBack: detailview)
        removeBlurView()
    }
    
    func setpromotionalitem()
    {
        promotionaladapter.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "select 1 _id,B.rowid,*,case when isapprove='0' then 'PENDING' else 'APPROVED' end as status  from ProductDay B join (select distinct itemname,itemgroup, itemgroupid from ItemMaster) A on A.itemgroupid = B.itemgroupid where status='APPROVED' and B.isdate like '\(self.getdate())%' order by itemname "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 9 ))
            
            promotionaladapter.append(Prmotionaladapter(itemname: itemname, state: false))
        }
        promitionalitem.reloadData()
    }
    
    public func getTodayReasonNoOrder(date: String?)
    {
        var stmt: OpaquePointer?
        let query = "select * from USERCUSTOMEROTHINFO where CUSTOMERCODE='\(customercode!)' and lastvisit like '" + self.getdate() + "%'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt) == SQLITE_ROW){
            self.showtoast(controller: self, message: "Call Counted for today", seconds: 1.5)
        }
        else{
            addPullUpController()
        }
    }
    
    @IBAction func addbtn(_ sender: UIButton) {
        if titlebar == "Reason For No Order"
        {
           getTodayReasonNoOrder(date: self.getdate())
        }
        else if titlebar == "Likely to buy"{
            getTodayReasonNoOrder(date: self.getdate())
        }
        else if titlebar == "Escalation Marking"{
            if isescalated(customercode: customercode) == true {
                addPullUpController()
            }
        }
        else {
            addPullUpController()
        }
    }
    
    private func addPullUpController() {
        var a=[UIView]()
        a = view.window!.subviews
        BlurView(view:view.window!.subviews[a.count - 1])
        controller = storyboard!.instantiateViewController(withIdentifier: "bottomsheet") as! Bottomsheetvc
        if (self.titlebar == "Escalation Marking"){
            controller?.head = "Escalation"
        }
        else if (self.titlebar == "Reason For No Order"){
            controller?.head = "Reason"
        }
        else if titlebar == "Likely to buy"{
            controller?.head = "Likely"
        }
        else if (self.titlebar == "Objection Report"){
            controller?.head = "Objection"
        }
        controller?.customercode = self.customercode
        controller?.siteid = self.siteid
        let screenSize = UIScreen.main.bounds.size
        self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
        UIApplication.shared.keyWindow!.addSubview(self.controller!.view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            
            self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height - self.view.frame.height + 100 , width: screenSize.width, height:  self.view.frame.height)
        }, completion: nil)
        
        let tapblurview = UITapGestureRecognizer(target: self, action: #selector(hidesheet))
        tapblurview.numberOfTapsRequired = 1
        AppDelegate.blureffectview.addGestureRecognizer(tapblurview)
    }
    @objc func hidesheet(sender: UITapGestureRecognizer){
        print("tappedd")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.controller!.view.frame  = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
            
        })
        { (finished) in
            self.controller!.willMove(toParentViewController: nil)
            self.controller!.view.removeFromSuperview()
            self.controller!.removeFromParentViewController()
        }
        AppDelegate.blureffectview.removeFromSuperview()
        
    }
    func BlurView(view: UIView){
        
        BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        BlurEffectView = UIVisualEffectView(effect: blurEffect)
        BlurEffectView.backgroundColor = UIColor.lightGray
        BlurEffectView.alpha = 0.2
        BlurEffectView.frame = view.bounds
        AppDelegate.blureffectview=BlurEffectView
        view.addSubview(AppDelegate.blureffectview)
    }
    @objc func fromdate(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.fromdate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func todate(datePicker2: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.todate.text = dateFormatter.string(from: datePicker2.date)
    }
    
    @IBAction func viewbtn(_ sender: UIButton) {
        if self.titlebar! == "Escalation Marking" {
            self.deleteescalationreport()
            self.getescalationreport()
            self.Escalationtable.reloadData()
        }
        else if self.titlebar! == "Reason For No Order" || self.titlebar! == "Likely to buy"  {
            self.deleteNoOrderRemarks()
             self.getnoroder()
             self.Escalationtable.reloadData()
        }
        else if self.titlebar! == "Objection Report" {
           self.deleteObjectionEntry()
            self.getobjectionreport()
            self.Escalationtable.reloadData()
        }
        
        
        if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){

//        if fromdate.text != ""{
//            if todate.text != ""{
                let URL_noorder = "GetUserNoReasonEntry?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text! + "&CUSTOMERCODE=" + self.customercode! + "&ismobile=" + UserDefaults.standard.string(forKey: "ismobile")!
            print("URL_noorder="+URL_noorder)
                
                let URL_escalationreport = "GetUserEscalationEntry?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text! + "&CUSTOMERCODE=" + customercode!
                 print("URL_escalationreport="+URL_escalationreport)
            
                let URL_objectionreport = "GetUserObjectionEntry?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text! + "&CUSTOMERCODE=" + self.customercode! + "&ismobile=" + UserDefaults.standard.string(forKey: "ismobile")!
                 print("URL_objectionreport="+URL_objectionreport)
            
                if self.titlebar! == "Escalation Marking" {
                    self.forescalation(url: URL_escalationreport)
                }
                // Likely to buy
                else if self.titlebar! == "Reason For No Order" || self.titlebar! == "Likely to buy"   {
                    self.fornoreasonentry(url: URL_noorder)
                }
                    
                else if self.titlebar! == "Objection Report" {
                    self.forobjectionreport(url: URL_objectionreport)
                }
            }
//            else{
//                self.showtoast(controller: self, message: "Please enter to date", seconds: 1.5)
//            }
        }
//        else{
//            self.showtoast(controller: self, message: "Please enter from date", seconds: 1.5)
//        }
    

    
    func fornoreasonentry(url: String!){
            self.view.isUserInteractionEnabled = false
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            print("loader activated")
            DispatchQueue.global(qos: .userInitiated).async {
                Alamofire.request(constant.Base_url + url).validate().responseJSON {
                    response in
                    print("fornoreasonentry==>"+constant.Base_url + url)
                    switch response.result {
                    case .success(let value): print("success=======>\(value)")
                    self.deleteNoOrderRemarks()
                    self.escalatioarr.removeAll()
                    if  let json = response.result.value{
                        let listarray : NSArray = json as! NSArray
                        if listarray.count > 0 {
                            for i in 0..<listarray.count{
                                
                                let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                                let statusid = String (((listarray[i] as AnyObject).value(forKey:"statusid") as? String)!)
                                let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as? String)!)
                                let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                                let submittime = String (((listarray[i] as AnyObject).value(forKey:"submittime") as? String)!)
                                let remarks = String (((listarray[i] as AnyObject).value(forKey:"remarks") as? String)!)
                                print("     \(dataareaid)     \(statusid)     \(reasoncode)     \(customercode)     \(siteid)     \(submittime)     \(remarks)")
                                self.insertnoorderremark(DATAAREAID: dataareaid as NSString, STATUSID: statusid as NSString, REASONCODE: reasoncode as NSString, CUSTOMERCODE: customercode as NSString, SITEID: siteid as NSString, SUBMITTIME: submittime as NSString, remarks: remarks as NSString)
                            }}
                        else {
                            self.showtoast(controller: self, message: "No Data Available", seconds: 2.0)
                        }
                    }
                        break
                    case .failure(let error): print("error=========>\(error)")
                        break
                    }
                    DispatchQueue.main.async {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            // stop animating now that background task is finished
                            activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                            // self.deleteNoOrderRemarks()
                            self.getnoroder()
                            self.Escalationtable.reloadData()
                            
                        }}}
            }
    }
    
    func forobjectionreport(url: String!){
        
            self.view.isUserInteractionEnabled = false
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            print("loader activated")
            DispatchQueue.global(qos: .userInitiated).async {
                Alamofire.request(constant.Base_url + url).validate().responseJSON {
                    response in
                    switch response.result {
                    case .success(let value): print("success=======>\(value)")
                    self.escalatioarr.removeAll()
                    if  let json = response.result.value{
                        let listarray : NSArray = json as! NSArray
                        self.deleteObjectionEntry()
                        if listarray.count > 0 {
                            for i in 0..<listarray.count{
                                
                                let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                                let objectionid = String (((listarray[i] as AnyObject).value(forKey:"objectionid") as? String)!)
                                let objectioncode = String (((listarray[i] as AnyObject).value(forKey:"objectioncode") as? String)!)
                                let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                                let submittime = String (((listarray[i] as AnyObject).value(forKey:"submittime") as? String)!)
                                let remarks = String (((listarray[i] as AnyObject).value(forKey:"remarks") as? String)!)
                                let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? String)!)
                                print("     \(dataareaid)     \(objectionid)     \(customercode)     \(customercode)     \(siteid)     \(submittime)     \(remarks)")
                                
                                self.insertObjectionEntry(objectioncode: objectioncode as NSString, objectionid: objectionid as NSString, dataareaid: dataareaid as NSString, customercode: customercode as NSString, siteid: siteid as NSString, submittime: submittime as NSString, status: status as NSString, remarks: remarks as NSString, latitude: "0", longitude: "0", userid: UserDefaults.standard.string(forKey: "userid")! as NSString, post: "0")
                                
                            }
                        }
                        else
                        {
                            self.showtoast(controller: self, message: "No Objections Submitted", seconds: 1.5)
                        }
                    }
                        break
                        
                    case .failure(let error): print("error=========>\(error)")
                        break
                    }
                    DispatchQueue.main.async {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            // stop animating now that background task is finished
                            activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                            self.getobjectionreport()
                            self.Escalationtable.reloadData()
                            
                        }}}
            }
//        }
//        else {
//            self.showtoast(controller: self, message: "You are Offline", seconds: 2.0)
//        }
    }
    func forescalation(url: String!){
        
//       if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){
        
            self.view.isUserInteractionEnabled = false
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            print("loader activated")
            DispatchQueue.global(qos: .userInitiated).async {
                Alamofire.request(constant.Base_url + url).validate().responseJSON {
                    response in
                    switch response.result {
                    case .success(let value): print("success=======>\(value)")
                    self.deleteescalationreport()
                    self.escalatioarr.removeAll()
                    if  let json = response.result.value{
                        let listarray : NSArray = json as! NSArray
                        if listarray.count > 0 {
                            for i in 0..<listarray.count{
                                let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                                let escalationid = String (((listarray[i] as AnyObject).value(forKey:"escalationid") as? String)!)
                                let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as? String)!)
                                let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                                let submittime = String (((listarray[i] as AnyObject).value(forKey:"submittime") as? String)!)
                                let createdby = String (((listarray[i] as AnyObject).value(forKey:"createdby") as? String)!)
                                let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? String)!)
                                let remark = String (((listarray[i] as AnyObject).value(forKey:"remark") as? String)!)
                                let username = String (((listarray[i] as AnyObject).value(forKey:"username") as? String)!)
                                let closeremarks = String (((listarray[i] as AnyObject).value(forKey:"closeremarks") as? String)!)
                                
                                self.insertescalationreport(dataareaid: dataareaid as NSString, escalationid: escalationid as NSString, customercode: customercode as NSString, siteid: siteid as NSString, submittime: submittime as NSString, createdby: createdby as NSString, status: status as NSString, remark: remark as NSString, reasoncode: reasoncode as NSString, username: username as NSString, closeremarks: closeremarks as NSString, post: "2", latitude: "0" , longitude: "0")
                            }
                        }
                        else
                        {                           
                            self.showtoast(controller: self, message: "No Escalations Submitted", seconds: 1.5)
                        }
                    }
                        break
                        
                    case .failure(let error): print("error=========>\(error)")
                        break
                    }
                    DispatchQueue.main.async {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            // stop animating now that background task is finished
                            activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                            //self.deleteescalationreport()
                            self.getescalationreport()
                            self.Escalationtable.reloadData()
                        }
                    }
                    
                }
            
        
        }
        
    }
    
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        if titlebar == "Objection Report" {
            let custcard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            custcard.titletxt = ccardtitle
            custcard.customercode = customercode
            custcard.customername = customername
            custcard.purchasing = purchasing
            self.navigationController?.pushViewController(custcard, animated: true)
        }
        else {
            
            let custcard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            custcard.titletxt = self.ccardtitle
            custcard.customername = self.customername
            custcard.customercode = self.customercode
            custcard.purchasing = self.purchasing
            self.navigationController?.pushViewController(custcard, animated: true)
            
       //     self.performSegue(withIdentifier: "ccardback", sender: (Any).self)
        }
    }
    
    func getobjectionreport()
    {
        self.objectioncodearr.removeAll()
        self.escalatioarr.removeAll()
        self.escalationreport.removeAll()
        var stmt:OpaquePointer?
        
        let query = "select 1 _id,A.objectionid,B.objectiondesc,A.remarks,substr(A.submittime,0,10) from ObjectionEntry A left join ObjectionMaster B on A.objectioncode=B.objectioncode"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let objectionid = String(cString: sqlite3_column_text(stmt, 1))
            let remarks = String(cString: sqlite3_column_text(stmt, 2))
            let submittime = String(cString: sqlite3_column_text(stmt, 4))
            self.escalatioarr.append(objectionid)
            self.escalationreport.append(Escalationcelladapter(escalationno: objectionid, customername: submittime, status: "", reason: remarks, custtype: "", createdby: ""))
            self.Escalationtable.reloadData()
            print("got data")
        }
    }
    func getescalationreport()
    {
        self.escalatioarr.removeAll()
        self.escalationreport.removeAll()
        var stmt:OpaquePointer?
        
        let query = "select 1 _id,A.escalationCode,substr(A.date,0,10),A.status,A.detail,B.reasondescription,A.username from MarketEscalationActivity A left outer join EscalationReason B on A.reason = B.reasoncode where customercode='" + self.customercode! + "'  and A.post='2'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let date = String(cString: sqlite3_column_text(stmt, 2))
            let escalationno = String(cString: sqlite3_column_text(stmt, 1))
            let reason = String(cString: sqlite3_column_text(stmt, 5))
            let status = String(cString: sqlite3_column_text(stmt, 3))
            let cretedby = String(cString: sqlite3_column_text(stmt, 6))
            
            self.escalatioarr.append(escalationno)
            self.escalationreport.append(Escalationcelladapter(escalationno: escalationno, customername: date, status: status, reason: reason, custtype: "", createdby: cretedby))
         //   self.Escalationtable.reloadData()z     cxvv
            print("got data")
        }
    } //select '0' as objectioncode,'Select' as objectiondesc union  select objectioncode,objectiondesc from ObjectionMaster where isblocked='false'
    
    func getnoroder()
    {
        self.escalatioarr.removeAll()
        self.escalationreport.removeAll()
        var stmt:OpaquePointer?
        
        let query = "select 1 as _id, B.reasondescription,substr(SUBMITTIME,0,10),remarks,statusid  from NoOrderRemarks A inner join NoOrderReasonMaster B on A.REASONCODE = B.reasoncode  where CUSTOMERCODE='" + self.customercode! + "'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let date = String(cString: sqlite3_column_text(stmt, 2))
            let escalationno = String(cString: sqlite3_column_text(stmt, 4))
            let reason = String(cString: sqlite3_column_text(stmt, 1))
            
            self.escalatioarr.append(escalationno)
            self.escalationreport.append(Escalationcelladapter(escalationno: escalationno, customername: date, status: "", reason: reason, custtype: "", createdby: ""))
            self.Escalationtable.reloadData()
            print("got data")
        }
    }
    func getescalationdetail(eno: String?)
    {
        var stmt:OpaquePointer?
        var query: String! = ""
        if self.titlebar! == "Escalation Marking" {
            query = "select escalationCode, detail from MarketEscalationActivity where escalationCode ='" + eno! + "'"
            self.escalationlbl.text = "Order No:"
        }
        else if self.titlebar! == "Reason For No Order" {
            query = "select statusid, remarks from NoOrderRemarks where statusid ='" + eno! + "'"
            self.escalationlbl.text = "No Order Code:"
        }
        else if self.titlebar! == "Objection Report" {
            query = "select objectionid, remarks from ObjectionEntry where objectionid ='" + eno! + "'"
            self.escalationlbl.text = "Objection Code:"
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.blurView(view: rootview)
        view.willRemoveSubview(detailview)
        view.addSubview(detailview)
        
        detailview.centerXAnchor.constraint(equalTo: rootview.centerXAnchor).isActive = true
        detailview.centerYAnchor.constraint(equalTo: rootview.centerYAnchor).isActive = true
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let descalation = String(cString: sqlite3_column_text(stmt, 0))
            let ddetail = String(cString: sqlite3_column_text(stmt, 1))
            
            let boldText  = "Description: "
            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            
            let normalText = ddetail
            let normalString = NSMutableAttributedString(string:normalText)
            
            attributedString.append(normalString)
            
            self.detailtxt.attributedText = attributedString
            self.escalationcode.text = descalation
           // self.detailtxt.text = ddetail
            
        }}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let marketvc = segue.destination as?  UINavigationController,
            let vc = marketvc.topViewController as? CustomerCard {
            if (segue.identifier == "ccardback"){
                vc.titletxt = self.ccardtitle
                vc.customername = self.customername
                vc.customercode = self.customercode
                vc.purchasing = self.purchasing
            }
        }}
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}
