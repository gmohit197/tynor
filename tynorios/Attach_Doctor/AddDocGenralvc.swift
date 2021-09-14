//  AddDocGenralvc.swift
//  tynorios
//  Created by Acxiom Consulting on 11/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.

import UIKit
import SQLite3
import SkyFloatingLabelTextField
import CoreLocation
import SwiftEventBus

class AddDocGenralvc: Executeapi, CLLocationManagerDelegate,UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var flag = true
        if textField.tag == 11 {
            let cursorPosition = range.location
            print("\(cursorPosition)")
            if (cursorPosition <= 3){
                textField.text = "Dr. "
                flag = false
            }
            else if range.location == 3 && string == " " {
                flag = false
            }
            else{
                flag = string.rangeOfCharacter(from: CharacterSet(charactersIn: "#$%&'()*+,-:;<=>?[]^_`{|}~!'/")) == nil
            }
        } else {
            if range.location == 0 && string == " " {
                flag = false
            }   else{
                flag = string.rangeOfCharacter(from: CharacterSet(charactersIn: "#$%&'()*+,-:;<=>?[]^_`{|}~!'/")) == nil
            }
        }
        return flag
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var designatedlabel: UILabel!
    @IBOutlet weak var buyingdirectspinr: DropDownUtil!
    @IBOutlet weak var designatedsuperdealrspinr: DropDownUtil!
    @IBOutlet weak var doctortypespinr: DropDownUtil!
    @IBOutlet weak var specializationspinr: DropDownUtil!
    @IBOutlet weak var statespinr: DropDownUtil!
    @IBOutlet weak var cityspinr: DropDownUtil!
    @IBOutlet weak var salespersonlbl: UILabel!
    @IBOutlet weak var salespersoncode: DropDownUtil!
    @IBOutlet weak var noofprescription: SkyFloatingLabelTextField!
    @IBOutlet weak var purchaseamt: SkyFloatingLabelTextField!
    @IBOutlet weak var doctrname: SkyFloatingLabelTextField!
    @IBOutlet weak var doctrmobileno: SkyFloatingLabelTextField!
    @IBOutlet weak var doctrlandlineno: SkyFloatingLabelTextField!
    @IBOutlet weak var emailid: SkyFloatingLabelTextField!
    @IBOutlet weak var address: SkyFloatingLabelTextField!
    @IBOutlet weak var pincode: SkyFloatingLabelTextField!
    @IBOutlet weak var doadatepicker: UITextField!
    @IBOutlet weak var dobdatepicker: UITextField!
    @IBOutlet weak var purchasingspnr: DropDownUtil!
    @IBOutlet weak var prescriptionspnr: DropDownUtil!
    @IBOutlet weak var prescriptionlbl: UILabel!
    @IBOutlet weak var purchaselbl: UILabel!
    @IBOutlet var genralDetailper: UILabel!
    @IBOutlet weak var desLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var desSpinnerHeight: NSLayoutConstraint!
    @IBOutlet weak var purchaseLabelHeight: NSLayoutConstraint!  // 20.5
    @IBOutlet weak var purchaseSpinHeight: NSLayoutConstraint!
    @IBOutlet weak var purchAmt: NSLayoutConstraint!
    @IBOutlet weak var prescAmt: NSLayoutConstraint!
    
    private var flag: Bool = false
    static var nxt: Bool?
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    var stateidarr: [String]!
    var cityidarr: [String]!
    var stateid: String!
    var cityid: String!
    var dealersrr: [String]!
    var dealerid: String!
    var drtypeidarr: [String]!
    var drtypeid: String! = ""
    var drtypespclidarr: [String]!
    var drtypeidspcl: String!
    var lat, longi : String!
    var locationManager:CLLocationManager!
    var salespersonid: String!
    var mobilecheck: Bool!
    var customercode: String!
    var dcrNameArray: [String]!
    static var noofprescriptionHeight: CGFloat!
    var isSetDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lat = "0"
        longi = "0"
      //  determineMyCurrentLocation()
        buyingdirectspinr.optionArray = ["Select","Yes","No"]
        drtypeidarr = []
        drtypespclidarr = []
        cityidarr = []
        dealersrr = []
        stateidarr = []
        dcrNameArray = []
        mobilecheck = true
        doctrname.text = "Dr. "
        doctrmobileno.text = ""
        doctrlandlineno.text = ""
        emailid.text = ""
        address.text = ""
        pincode.text = ""
        purchaseamt.text = ""
        noofprescription.text = ""
        
        address.delegate = self
        doctrname.delegate = self
        emailid.delegate = self
        
        UserDefaults.standard.removeObject(forKey: "doadatepicker")
        UserDefaults.standard.removeObject(forKey: "dobdatepicker")
        self.DatePicker()
        self.doadatepicker.rightView = UIImageView(image: UIImage(named: "calendar"))
        self.doadatepicker.rightViewMode = .always
        self.dobdatepicker.rightView = UIImageView(image: UIImage(named: "calendar"))
        self.dobdatepicker.rightViewMode = .always
        
        if AppDelegate.usertype == "11"{
            self.hideview(view: self.salespersoncode)
            self.hideview(view: self.salespersonlbl)
        }
        
//        if AppDelegate.doccode.contains("DOC") {
//            customercode = self.getID()
//            if(AppDelegate.source=="Attach Doctor"){
//                AppDelegate.customercode = customercode
//            }
//        } else{
//            customercode = AppDelegate.customercode
//        }

//CURRENT
        if (AppDelegate.doccode.contains("DOC") && !(AppDelegate.isFromCustomerCardList)){
            customercode = self.getID()
            if(AppDelegate.source=="Attach Doctor" || AppDelegate.isFromSalesPersonList){
                AppDelegate.customercode = customercode
            }
        }
        else if(AppDelegate.isDocScreen == true){
            customercode = self.getID()
           
        }
        else{
            customercode = AppDelegate.customercode
        }
        
        AppDelegate.doccustomercode = customercode
       // AppDelegate.customercode = customercode
       // AppDelegate.customercode = self.customercode!
        
        //        purchaseamt.isHidden = true
        //        noofprescription.isHidden = true
        
        setdrtypespiner()
        AddDocGenralvc.noofprescriptionHeight = self.noofprescription.frame.height
        
        doctortypespinr.didSelect { (select, index, id) in
            self.drtypeid = self.drtypeidarr[index]
            if self.drtypeid != "0" {
                self.setdrspecilization(drtype: self.drtypeid)
            }
            else {
                self.showtoast(controller: self, message: "Please select a valid Doctor Type", seconds: 1.5)
            }
        }
        
        specializationspinr.didSelect { (select, index, id) in
            self.drtypeidspcl = self.drtypespclidarr[index]
        }
        
        purchasingspnr.didSelect { (select, index, id) in
            switch index {
            case 0 : self.purchaseamt.isHidden = false
                break
            case 1 : self.purchaseamt.isHidden = true
                break
            default : break
            }
        }
        
        prescriptionspnr.didSelect { (select, index, id) in
            switch index {
            case 0 :
                self.noofprescription.isHidden = false
                self.prescAmt.constant = 39.5
                break
            case 1 :
                self.noofprescription.isHidden = true
                self.prescAmt.constant = 0
                
                break
            default : break
            }
        }
        
        buyingdirectspinr.didSelect { (select, index, id) in
            switch index {
            case 1 :
                self.purchasingspnr.text = "Yes"
                self.purchasingspnr.isUserInteractionEnabled = false
                self.purchasingspnr.isHidden = false
                self.purchaselbl.isHidden = false
                self.purchaseamt.isHidden = false
                self.designatedsuperdealrspinr.isHidden = false
                self.designatedlabel.isHidden = false
                
                self.desLabelHeight.constant = 18
                self.desSpinnerHeight.constant = 34
                self.purchaseLabelHeight.constant = 20.5
                self.purchaseSpinHeight.constant = 34
                self.purchAmt.constant = 39.5
                
                break
            case 2 :
                self.purchasingspnr.text = "No"
                self.purchasingspnr.isUserInteractionEnabled = true
                self.purchasingspnr.isHidden = true
                self.purchaselbl.isHidden = true
                self.purchaseamt.isHidden = true
                self.designatedsuperdealrspinr.isHidden = true
                self.designatedlabel.isHidden = true
                
                self.desLabelHeight.constant = 0
                self.desSpinnerHeight.constant = 0
                self.purchaseLabelHeight.constant = 0
                self.purchaseSpinHeight.constant = 0
                self.purchAmt.constant = 0
                
                break
            default: break
            }
        }
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        
        datePicker?.addTarget(self, action: #selector(self.dobdatepicker(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(self.doadatepicker(datePicker2:)), for: .valueChanged)
        
        dobdatepicker.inputView = datePicker
        doadatepicker.inputView = datePicker2
        
        self.datePicker?.fromdatecheck()
        self.datePicker2?.fromdatecheck()
        
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        
        purchasingspnr.optionArray = ["Yes","No"]
        prescriptionspnr.optionArray = ["Yes","No"]
        purchasingspnr.text = purchasingspnr.optionArray[0]
        prescriptionspnr.text = prescriptionspnr.optionArray[0]
        buyingdirectspinr.text = buyingdirectspinr.optionArray[0]
        cityspinr.text = "Select"
        // designatedsuperdealrspinr.text = designatedsuperdealrspinr.optionArray[0]
        specializationspinr.text = "Select"
        AddDocGenralvc.nxt = false
        
        
        if salespersoncode.isHidden == false{
            salespersonspinner()
            salesspinrSelect()
        }
        else{
            //bind state city spinner and superdealer spinner
            setstatespinr(usercode: "")
            setcityspinr(stateid : self.stateid, usercode: "")
            setdealerspinr(salespersonid: "")
        }
        setdetail()
        self.emailid.keyboardType = UIKeyboardType.emailAddress
        self.updateprog()
        
        self.designatedsuperdealrspinr.listHeight = 250.0
        
        self.designatedsuperdealrspinr.isSearchEnable = false
        self.buyingdirectspinr.isSearchEnable = false
        self.doctortypespinr.isSearchEnable = false
        self.specializationspinr.isSearchEnable = false
        self.purchasingspnr.isSearchEnable = false
        self.prescriptionspnr.isSearchEnable = false
        self.cityspinr.isSearchEnable = false
        
        self.cityspinr.listHeight = 0.0
        
        let tapcityspinr = UITapGestureRecognizer(target: self, action: #selector(self.cityspinrtapped))
        self.cityspinr.addGestureRecognizer(tapcityspinr)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
            self.updateprog()
        }
        SwiftEventBus.onMainThread(self, name: "setcity") { Result in
            self.cityspinr.text = AppDelegate.cityNameSpinner
            self.cityid = AppDelegate.cityidSpinner
        }
        self.setdetail()
    }
    
    func updateprog(){
        self.genralDetailper.text = "General Details" + "(\(Int(getdoctorpecent(docid: AppDelegate.doccode)))%)"//AppDelegate.customercode
    }
    
    @objc func cityspinrtapped(){
        self.view.endEditing(true)
        self.cityspinrIntent()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        //       print("user latitude = \(userLocation.coordinate.latitude)")
        //       print("user longitude = \(userLocation.coordinate.longitude)")
        lat = String(userLocation.coordinate.latitude)
        longi = String(userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func getspecialisation(){
        var stmt1: OpaquePointer?
        
        let query = "select ismandatory from DRType where typeid='\(drtypeid!)' and ismandatory='true'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if (sqlite3_step(stmt1) == SQLITE_ROW){
            flag = true
        }
        else{
            flag = false
        }
        
    }
    
    func setdrtypespiner(){
        
        doctortypespinr.optionArray.removeAll()
        drtypeidarr.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select '0' as typeid,'Select' as typedesc union select distinct typeid,typedesc from DRType "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let drtype = String(cString: sqlite3_column_text(stmt1, 1))
            let drtypeid = String(cString: sqlite3_column_text(stmt1, 0))
            doctortypespinr.optionArray.append(drtype)
            drtypeidarr.append(drtypeid)
            print("drtypeid======> \(drtypeid)")
        }
        self.doctortypespinr.text = doctortypespinr.optionArray[0]
    }
    
    func salespersonspinner(){
        
        var stmt1: OpaquePointer?
        var query = ""
        if cityspinr.isUserInteractionEnabled == false{
            query = "select a.usercode,a.empname from USERHIERARCHY a join salelinkcity s on s.usercode = a.usercode join DRMASTER h on h.city = s.cityid where h.drcode = '\(AppDelegate.doccode)' and (a.usertype ='13' or a.usertype='14' or a.usertype='12' or a.usertype='15') and a.employeecode = '\(UserDefaults.standard.string(forKey: "userid")!)'"
        }
        else{
            query = "select usercode,empname  from USERHIERARCHY where employeecode = '\(UserDefaults.standard.string(forKey: "userid")!)'"
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            self.salespersoncode.text = String(cString: sqlite3_column_text(stmt1, 1))
            self.salespersoncode.isUserInteractionEnabled = false
            self.salespersonid = String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    func setdrspecilization(drtype: String!){
        
        specializationspinr.optionArray.removeAll()
        drtypespclidarr.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select '-1' as typeid,'Select' as typedesc union select distinct typeid,typedesc  from DRSpecialization where isblocked='false' and drtypeid='\(drtype!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let drtype = String(cString: sqlite3_column_text(stmt1, 1))
            let drtypeid = String(cString: sqlite3_column_text(stmt1, 0))
            specializationspinr.optionArray.append(drtype)
            drtypespclidarr.append(drtypeid)
            if(AppDelegate.isDebug){
            print("drtypeid======> \(drtypeid)")
            }
        }
        
        self.specializationspinr.text = specializationspinr.optionArray[0]
    }
    
    func setdealerspinr(salespersonid: String?)
    {
        designatedsuperdealrspinr.optionArray.removeAll()
        dealersrr.removeAll()
        var query: String?
        var stmt1: OpaquePointer?
        if salespersoncode.isHidden == true{
            query  = "select '' as siteid, '-Select-' as sitename union select siteid,sitename from USERDISTRIBUTOR"
        }
        else{
            query = "select '' as siteid,'Select' as sitename union select  A.siteid ,A.sitename  from USERDISTRIBUTOR A inner join USERDISTRIBUTORLIST B on B.siteid=A.siteid where B.userCode = '\(salespersonid!)'"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let sitename = String(cString: sqlite3_column_text(stmt1, 1))
            let siteid = String(cString: sqlite3_column_text(stmt1, 0))
            
            designatedsuperdealrspinr.optionArray.append(sitename)
            dealersrr.append(siteid)
            print("siteid======> \(siteid)")
        }
        self.designatedsuperdealrspinr.text = designatedsuperdealrspinr.optionArray[0]
    }
    
    func setstatespinr(usercode: String?)
    {
        statespinr.optionArray.removeAll()
        stateidarr.removeAll()
        var query: String?
        var stmt1: OpaquePointer?
        if salespersoncode.isHidden == true{
            query = "select '' as StateId, '-Select-' as StateName union select StateId,StateName from statemaster where stateid = (select distinct stateid from CityMaster where cityid = (select cityid from UserLinkCity))"
        }
        else{
            query = "select '' as stateid , '-Select-' as statename union SELECT distinct A.stateid, A.statename FROM StateMaster A join salelinkcity B on A.stateid = b.stateid AND b.isblocked = 'false' and B.usercode = '\(usercode!)'"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let statename = String(cString: sqlite3_column_text(stmt1, 1))
            let stateid = String(cString: sqlite3_column_text(stmt1, 0))
            
            statespinr.optionArray.append(statename)
            stateidarr.append(stateid)
        }
        if (stateidarr.count == 1){
            statespinr.text = "Select"
            statespinr.isUserInteractionEnabled = false
        }else{
            statespinr.text = statespinr.optionArray[1]
            statespinr.isUserInteractionEnabled = false
            self.stateid = self.stateidarr[1]
        }
    }
    
    func checkcity(stateid: String?,usercode:String?,citytext: String?)-> Bool{
        
        var stmt1: OpaquePointer?
        if salespersoncode.isHidden == true{
            let query = "select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where  SE.stateid = '\(stateid!)' and cityname = '\(citytext!)' and SE.isblocked <> 'true' order by cm.cityid"
            if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
            }
        }
        else{
            let query1 = "select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and SE.stateid = '\(stateid!)' and cityname = '\(citytext!)' and SE.isblocked <> 'true' order by cm.cityid"
            if sqlite3_prepare_v2(Databaseconnection.dbs, query1 , -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
            }
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
    }
    
    func setcityspinr(stateid: String?,usercode:String?)
    {
        cityspinr.optionArray.removeAll()
        cityidarr.removeAll()
        
        var stmt1: OpaquePointer?
        var query: String?
        if salespersoncode.isHidden == true{
            query = "select '' as CityId, '-Select-' as CityName union select A.cityid,B.CityName from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' and  stateid= '\(stateid!)' order by CityName"
        }
        else {
            query = "select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and SE.stateid = '\(stateid!)' and SE.isblocked <> 'true' order by cm.cityid"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let cityname = String(cString: sqlite3_column_text(stmt1, 1))
            let cityid = String(cString: sqlite3_column_text(stmt1, 0))
            
            cityspinr.optionArray.append(cityname)
            cityidarr.append(cityid)
        }
        
    }
    
    func setcityspinrData(stateid: String?,usercode:String?)
    {
        cityspinr.optionArray.removeAll()
        cityidarr.removeAll()
        
        var stmt1: OpaquePointer?
        var query: String?
        if salespersoncode.isHidden == true{
            query = " select A.cityid from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false'  and cityname ='\(cityspinr.text!)'  and  stateid= '\(stateid!)' order by CityName"
        }
        else {
            query = "select CM.CITYID from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and cityname ='\(cityspinr.text!)' and SE.stateid = '\(stateid!)' and SE.isblocked <> 'true' order by cm.cityid"
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            cityid = String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    
//    func getcityspinrNameFromId()
//    {
//        var stmt1: OpaquePointer?
//        var query: String?
//        if salespersoncode.isHidden == true{
//            query = " select A.cityid from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false'  and cityid ='\(cityspinr.text!)'  and  stateid= '\(stateid!)' order by CityName"
//        }
//        else {
//            query = "select CM.CITYID from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and cityid ='\(cityspinr.text!)' and SE.stateid = '\(stateid!)' and SE.isblocked <> 'true' order by cm.cityid"
//        }
//        
//        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//            return
//        }
//        while(sqlite3_step(stmt1) == SQLITE_ROW){
//            cityid = String(cString: sqlite3_column_text(stmt1, 0))
//        }
//    }

    func cityspinrIntent(){
        let attachdoclist: Attachdoclist = self.storyboard?.instantiateViewController(withIdentifier: "addnewdoc") as! Attachdoclist
        attachdoclist.titletext = "City"
        attachdoclist.stateid = self.stateid
        if  self.salespersoncode.isHidden {
            attachdoclist.usercode = ""
        }
        else {
            attachdoclist.usercode = self.salespersonid
        }
        attachdoclist.flag = "\(self.salespersoncode.isHidden)"
        attachdoclist.isfrom = "Doctor"
        self.navigationController?.pushViewController(attachdoclist, animated: true)
       }
    
    
    @objc func dobdatepicker(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dobdatepicker.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func doadatepicker(datePicker2: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.doadatepicker.text = dateFormatter.string(from: datePicker2.date)
    }
    
    func validate() -> Bool {
        var validate = true
        
        getspecialisation()
        
        if self.salespersoncode.text! == "Select" {
            self.showtoast(controller: self, message: "Select Sales Person", seconds: 1.5)
            validate = false
        }
        else if buyingdirectspinr.text == "Select"{
            self.showtoast(controller: self, message: "Is doctor buying directly", seconds: 1.5)
            validate = false
        }
        else if designatedsuperdealrspinr.text == "Select" && buyingdirectspinr.text == "Yes" {
            self.showtoast(controller: self, message: "Select Super Dealer", seconds: 1.5)
            validate = false
        }
        else if doctortypespinr.text == "Select"{
            self.showtoast(controller: self, message: "Select Doctor Type", seconds: 1.5)
            validate = false
        }
        else if (flag && self.specializationspinr.text == "Select"){
            self.showtoast(controller: self, message: "Select Specialization type", seconds: 1.5)
            validate = false
        }
        else if doctrname.text == "" || doctrname.text == "Dr. "{
            self.showtoast(controller: self, message: "Enter Doctor Name", seconds: 1.5)
            validate = false
        }
        else if doctrmobileno.text == "" || doctrmobileno.text?.count != 10
        {
            self.showtoast(controller: self, message: "Enter Mobile Number", seconds: 1.5)
            validate = false
        }
        else if statespinr.text == "Select"{
            self.showtoast(controller: self, message: "Select State", seconds: 1.5)
            validate = false
        }
        else if cityspinr.text == "Select" ||  cityspinr.text == "" || self.checkcity(stateid: self.stateid, usercode: self.salespersonid, citytext: self.cityspinr.text)
        {
            self.showtoast(controller: self, message: "Select Assigned City", seconds: 1.5)
            validate = false
        }
        else if ((!(pincode.text?.isEmpty)!) && pincode.text?.count != 6)
        {
            self.showtoast(controller: self, message: "Pincode to be of length 6 only ", seconds: 1.5)
            validate = false
        }
        else if purchasingspnr.text == "Yes" && self.purchaseamt.text!.isEmpty && !self.purchaseamt.isHidden {
            self.showtoast(controller: self, message: "Amount of purchase", seconds: 1.5)
            validate = false
        }
        else if prescriptionspnr.text == "Yes" && self.noofprescription.text!.isEmpty {
            self.showtoast(controller: self, message: "No of Prescription", seconds: 1.5)
            validate = false
        }
            
        else if (prescriptionspnr.text == "No" && purchasingspnr.text == "No"  ){
            self.showtoast(controller: self, message: "Either Purchasing or Prescrbing?", seconds: 1.5)
            validate = false
        }
        return validate
    }
    
    @IBAction func mobilenum(_ sender: SkyFloatingLabelTextField) {
        if (sender.text?.count)! > 0 &&  (sender.text?.count)! < 10 {
            self.showtoast(controller: self, message: "Enter a valid 10 Digit Mobile Number", seconds: 1.5)
            mobilecheck = false
        }
        else {
            mobilecheck = true
        }
    }
    
   
    
    @IBAction func submitbtn(_ sender: UIButton) {
        if validate() && mobilecheck {
            
            // AddDocGenralvc.nxt = true
            AddDocGenralvc.nxt = false
            
            print(self.salespersoncode.isHidden)
            self.setSite()
            
            if self.dealerid == nil{
                self.setSiteId()
            }
            
            if(self.salespersonid==nil){
                self.salespersonid = ""
            }
            self.prespribValue()
            self.setcityspinrData(stateid: stateid, usercode: self.salespersonid)
            if(AppDelegate.isDebug){
            print("Purchasing==="+purchasingspnr.text!)
            print("Prescriptionspnr==="+prescriptionspnr.text!)
            print("AddDocSpecializationdrtypeidspcl==="+self.drtypeidspcl!)
            print("AddDocSpecialization==="+self.specializationspinr.text!)
            }
            
            self.insertDRmaster(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), drcode: AppDelegate.doccode, drname:doctrname.text!, mobileno: doctrmobileno.text!, alternateno: doctrlandlineno.text!, emailid: emailid.text!, address: address.text!, pincode: pincode.text!, city: cityid, stateid: stateid, dob: dobdatepicker.text!, doa: doadatepicker.text!, isblocked: "false", ispurchaseing: purchasingspnr.text! == "Yes" ? "true" : "false", ispriscription: prescriptionspnr.text! == "Yes" ? "true" : "false", CREATEDTRANSACTIONID: "0", MODIFIEDTRANSACTIONID: "0", POST: "0", drspecialization: self.drtypeidspcl == nil ? " " : "\(self.drtypeidspcl!)", purchaseamt: self.purchaseamt.text, noofprescription: self.noofprescription.text, siteid: dealerid, isbuying: buyingdirectspinr.text! == "Yes" ? "true" : "false", drtype: self.drtypeid, custrefcode: self.customercode, salepersoncode: self.salespersonid)
            
            if(self.salespersoncode.isHidden == false){
                
                self.insertretailermaster(customercode: self.customercode , customername: self.doctrname.text! , customertype: "CG0003", contactperson: doctrname.text! , mobilecustcode: "", mobileno: doctrmobileno.text! , alternateno: doctrlandlineno.text! , emailid: emailid.text! , address: address.text! , pincode: pincode.text! , city: cityid , stateid: stateid , gstno: "", gstregistrationdate: "", siteid: dealerid , salepersonid: self.salespersonid , keycustomer: "true", isorthopositive: "false", sizeofretailer: "", category: "", isblocked: "false", pricegroup: UserDefaults.standard.string(forKey: "pricegroup")! , dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! , latitude: lat , longitude: longi , orthopedicsale: "", avgsale: "", prefferedbrand: "", secprefferedbrand: "", secprefferedsale: "", prefferedsale: "", prefferedreasonid: "", secprefferedreasonid: "", createdtransactionid: "0", modifiedtransactionid: "0", post: "0", referencecode: AppDelegate.doccode , lastvisited: "", storeimage: "", stockimage: "", prefferedothbrand: "", secprefferedothbrand: "")
                
            }
            if(AppDelegate.isDebug){
            print("AddDocVc=" + AppDelegate.source)
            print("AddDocVc=" + AppDelegate.customercode)
            }
            Marketvc.superdealerstr = self.dealerid
            
            AddDocGenralvc.nxt = true
            
            AttachDoctorvc.flag = false
            AppDelegate.showDocList = false
            self.isSetDetails = true
            
            SwiftEventBus.post("updateprogress")
            SwiftEventBus.post("gotodoctor")
            
            self.setdetail()
            self.showtoast(controller: self, message: "General Details Added Successfully", seconds: 1.5)
          //  DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
               
         //   }
        }
    }
    
    func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
        for (index, obj) in array.enumerated() where obj == object {
            return index
        }
        return nil
    }
    
    func setdetail()
    {
        var stmt1: OpaquePointer?
        
        let query = "select A.*, B.typedesc as type,ifnull(C.typedesc,'') as specialisation from DRMASTER A left outer join drtype B on B.typeid = A.drtype left outer join drspecialization C on C.typeid = A.drspecialization where drcode ='\(AppDelegate.doccode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        print("setDetailAddDoc====="+query)
        if(sqlite3_step(stmt1) == SQLITE_ROW)
        {
            
            if(AppDelegate.isFromSalesPersonList && !self.isSetDetails ){
                AddDocGenralvc.nxt = false
            }
            else {
                AddDocGenralvc.nxt = true
            }
            
            //            AddDocGenralvc.nxt = true
            flag = true
            //    self.salespersoncode.text = String(cString: sqlite3_column_text(stmt1, 25))
            //    self.salespersonid = String(cString: sqlite3_column_text(stmt1, 25))
            self.salespersoncode.isUserInteractionEnabled = false
            let buyingdirect = String(cString: sqlite3_column_text(stmt1, 22))
            if buyingdirect == "false" {
                self.buyingdirectspinr.text = "No"
                self.hideview(view:self.purchasingspnr)
                self.hideview(view:self.purchaselbl)
                self.hideview(view:self.purchaseamt)
                self.hideview(view:self.designatedsuperdealrspinr)
                self.hideview(view:self.designatedlabel)
            }
            else{
                self.buyingdirectspinr.text = "Yes"
            }
            buyingdirectspinr.isUserInteractionEnabled = false
            self.dealerid = String(cString: sqlite3_column_text(stmt1, 21))
            setdealername(siteid: self.dealerid)
            Marketvc.superdealerstr = self.dealerid
            self.doctortypespinr.text = String(cString: sqlite3_column_text(stmt1, 26))
            self.doctortypespinr.isUserInteractionEnabled = false
            self.specializationspinr.text = String(cString: sqlite3_column_text(stmt1, 27))
            self.specializationspinr.isUserInteractionEnabled = false
            
            let purchasing = String(cString: sqlite3_column_text(stmt1, 13))
            
            if purchasing == "true"{
                self.purchasingspnr.text = "Yes"
                self.purchasingspnr.isEnabled = false
                self.purchaseamt.text = String(cString: sqlite3_column_text(stmt1, 19))
                self.setuserintractionfalse(textfield: purchaseamt)
                self.prescriptionlbl.isHidden =  false
                self.prescriptionspnr.text = "No"
                self.prescriptionspnr.isEnabled = false
                // do here
                self.purchAmt.constant = 39.5
                self.purchaseLabelHeight.constant = 20.5
                self.purchaseSpinHeight.constant = 34
            }
            else{
                self.purchasingspnr.isHidden = true
                self.purchaseamt.isHidden = true
                self.purchaselbl.isHidden = true
                // do here
                self.purchAmt.constant = 0.0
                self.purchaseLabelHeight.constant = 0.0
                self.purchaseSpinHeight.constant = 0.0
            }
            
            let prescription = String(cString: sqlite3_column_text(stmt1, 14))
            if prescription == "true" {
                self.prescriptionspnr.text = "Yes"
                self.prescriptionspnr.isEnabled = false
                self.noofprescription.isHidden = false
                self.noofprescription.text = String(sqlite3_column_int64(stmt1, 20))
                self.setuserintractionfalse(textfield: noofprescription)
            }
            else{
                self.noofprescription.isHidden = true
            }
            self.doctrname.text = String(cString: sqlite3_column_text(stmt1, 2))
            self.setuserintractionfalse(textfield: doctrname)
            self.doctrmobileno.text = String(cString: sqlite3_column_text(stmt1, 3))
            self.setuserintractionfalse(textfield: doctrmobileno)
            self.doctrlandlineno.text = String(cString: sqlite3_column_text(stmt1, 4))
            self.setuserintractionfalse(textfield: doctrlandlineno)
            self.emailid.text = String(cString: sqlite3_column_text(stmt1, 5))
            self.setuserintractionfalse(textfield: emailid)
            self.address.text = String(cString: sqlite3_column_text(stmt1, 6))
            self.setuserintractionfalse(textfield: address)
            self.pincode.text = String(cString: sqlite3_column_text(stmt1, 7))
            self.setuserintractionfalse(textfield: pincode)
            self.drtypeid = String(cString: sqlite3_column_text(stmt1, 23))
            self.drtypeidspcl = String(cString: sqlite3_column_text(stmt1, 18))
            
            
            var dob = String(cString: sqlite3_column_text(stmt1, 10))
            var doa = String(cString: sqlite3_column_text(stmt1, 11))
            
            //  dob == "1900-01-01T00:00:00" ? "" : dob
            
            
            
            if (dob.count > 0){
                if(dob.count > 10){
                    dob.removeLast(09)
                }
                self.dobdatepicker.isUserInteractionEnabled = false
            }else{
                dob = ""
                self.dobdatepicker.isUserInteractionEnabled = true
            }
            if (doa.count > 0){
                if(doa.count > 10){
                    doa.removeLast(09)
                }
                self.doadatepicker.isUserInteractionEnabled = false
            }else{
                doa = ""
                self.doadatepicker.isUserInteractionEnabled = true
            }
            self.dobdatepicker.text = dob
            self.doadatepicker.text = doa
            self.setstatename()
            self.setcityname()
        }
        else
        {
            //            let prefix = UITextField()
            //            prefix.text = "Dr."
            //            prefix.font = UIFont.systemFont(ofSize: 14)
            //            prefix.sizeToFit()
            //
            //            doctrname.leftView = prefix
            //            doctrname.leftViewMode = .always // or .always
            
            //            if salespersoncode.isHidden == false{
            //                salespersonspinner()
            //                salesspinrSelect()
            //            }
            //            else{
            //                //bind state city spinner and superdealer spinner
            //                setstatespinr(usercode: "")
            //                setdealerspinr(salespersonid: "")
            //            }
        }
    }
    
    func salesspinrSelect(){
        
        self.setdealerspinr(salespersonid: self.salespersonid)
        self.designatedsuperdealrspinr.didSelect(completion: { (selection, index, id) in
            
            self.dealerid = self.dealersrr[index]
        })
        
        self.setstatespinr(usercode: self.salespersonid)
        if self.stateidarr.count == 1{
            self.cityspinr.text = "Select"
        }
            
        else{
            self.setcityspinr(stateid: self.stateid, usercode: self.salespersonid)
            self.cityspinr.didSelect(completion: { (selection, index, id) in
                self.cityid = self.cityidarr[index]
            })
        }
        
    }
    func getdoccust(doccode: String?)->String{
        var stmt1:OpaquePointer?
        var cust = ""
        let query = "select custrefcode from DRMASTER where drcode = '\(doccode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            cust = String(cString: sqlite3_column_text(stmt1, 0))
            
        }
        return cust
    }

    func setcityname(){
        var stmt1: OpaquePointer?
        //        Cursor res = sq.rawQuery("select cityname from citymaster where cityid = (select cityid from hospitalmaster where hoscode = '" + HospitalList.hossid + "')", null);
        
        //        let query = "select cityname,cityid from citymaster where cityid = (select city from retailermaster where customercode = '\(customercode!)')"
        
        let query = "select cityname,cityid from citymaster where cityid = (select city from DRMASTER where drcode = '\(AppDelegate.doccode)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            cityspinr.text = String(cString: sqlite3_column_text(stmt1, 0))
            self.cityid = String(cString: sqlite3_column_text(stmt1, 1))
        }
        cityspinr.isUserInteractionEnabled = false
    }
    
    func setstatename(){
        var stmt1: OpaquePointer?
        
        let query = "select statename,stateid from statemaster where stateid = (select stateid from DRMASTER where drcode = '\(AppDelegate.doccode)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            statespinr.text = String(cString: sqlite3_column_text(stmt1, 0))
            self.stateid = String(cString: sqlite3_column_text(stmt1, 1))
        }
        statespinr.isUserInteractionEnabled = false
    }
    
    func setdealername(siteid: String?){
        var stmt1: OpaquePointer?
        
        let query = "select sitename from USERDISTRIBUTOR where siteid = '\(siteid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.designatedsuperdealrspinr.text = String(cString: sqlite3_column_text(stmt1, 0))
        }else{
            
            self.designatedsuperdealrspinr.attributedText = Retailerlistvc.wrongdealertext
        }
        self.designatedsuperdealrspinr.isUserInteractionEnabled = false
    }
    
    func setuserintractionfalse(textfield: UITextField)
    {
        if(textfield.text != ""){
            textfield.isUserInteractionEnabled = false
        }
    }
    
    func disableSpinnerInteraction(dropdown: DropDownUtil,index: Int)
    {
        if(index > 0){
            dropdown.isUserInteractionEnabled = false
        }
    }
    func setSiteId(){
        var stmt1: OpaquePointer?
        
        let query = "select siteid from USERDISTRIBUTOR LIMIT 1"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.dealerid = String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    func prespribValue(){
        if(buyingdirectspinr.text! == "Yes" ){
            purchasingspnr.text! = "Yes"
        }
        else{
            purchasingspnr.text! = "No"
        }
    }
    
    func setSite(){
        let sitename = self.designatedsuperdealrspinr.text!
        if  !(sitename == ""){
            var stmt1: OpaquePointer?
            let query = "select siteid from USERDISTRIBUTOR where sitename = '\(sitename)'"
            
            if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                self.dealerid = String(cString: sqlite3_column_text(stmt1, 0))
            }
        }
    }
    
    
    
    func DatePicker (){
        UserDefaults.standard.removeObject(forKey: "doadatepicker")
        UserDefaults.standard.removeObject(forKey: "dobdatepicker")
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        
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
        
        doadatepicker.inputAccessoryView = toolbar
        doadatepicker.inputView = datePicker
        
        toolbar1.setItems([donetButton,spacetButton,canceltButton], animated: false)
        
        dobdatepicker.inputAccessoryView = toolbar1
        dobdatepicker.inputView = datePicker2
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        self.datePicker?.fromdatecheck()
        self.datePicker2?.fromdatecheck()
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        doadatepicker.text = formatter.string(from: self.datePicker!.date)
        self.view.endEditing(true)
    }
    @objc func donedatetPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dobdatepicker.text = formatter.string(from: self.datePicker2!.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

extension UIView{
    func isVisible(_ isVisible: Bool,view: UIView) {
        view.isHidden = !isVisible
        view.translatesAutoresizingMaskIntoConstraints = isVisible
        if isVisible { //if visible we remove the hight constraint
            if let constraint = (view.constraints.filter{$0.firstAttribute == .height}.first){
                view.removeConstraint(constraint)
            }
        } else { //if not visible we add a constraint to force the view to have a hight set to 0
            let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal , toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
            view.addConstraint(height)
        }
        view.layoutIfNeeded()
    }
}


extension String {
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
}


