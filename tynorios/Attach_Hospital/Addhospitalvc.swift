//  Addhospitalvc.swift
//  tynorios

//  Created by Acxiom Consulting on 29/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.

import UIKit
import SQLite3
import SkyFloatingLabelTextField
import CoreLocation
import SwiftEventBus
import DropDown

class Addhospitalvc: Executeapi, CLLocationManagerDelegate,UITextFieldDelegate  {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return string.rangeOfCharacter(from: CharacterSet(charactersIn: "#$%&'()*+,-:;<=>?[]^_`{|}~!'/")) == nil
    }
    
    @IBOutlet weak var superdealerspinr: DropDownUtil!
    @IBOutlet weak var hospitaltypespinr: DropDownUtil!
    @IBOutlet weak var statespinr: DropDownUtil!
    @IBOutlet weak var cityspinr: DropDownUtil!
    @IBOutlet weak var purchasemanagerspinr: DropDownUtil!
    @IBOutlet weak var chainspinr: DropDownUtil!
    @IBOutlet weak var salespersonlbl: UILabel!
    @IBOutlet weak var salespersoncode: DropDownUtil!
    @IBOutlet weak var otherdecision: SkyFloatingLabelTextField!
    @IBOutlet weak var yesstack: UIStackView!
    @IBOutlet weak var nostack: UIStackView!
    @IBOutlet weak var hospitalname: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileno: SkyFloatingLabelTextField!
    @IBOutlet weak var landlineno: SkyFloatingLabelTextField!
    @IBOutlet weak var emailid: SkyFloatingLabelTextField!
    @IBOutlet weak var address: SkyFloatingLabelTextField!
    @IBOutlet weak var pincode: SkyFloatingLabelTextField!
    @IBOutlet weak var namepurchaseman: SkyFloatingLabelTextField!
    @IBOutlet weak var mobilepurchaseman: SkyFloatingLabelTextField!
    @IBOutlet weak var monthalypurchase: SkyFloatingLabelTextField!
    @IBOutlet weak var noofbeds: SkyFloatingLabelTextField!
    @IBOutlet var genralDetailsPer: UILabel!
    
    var stateidarr: [String]!
    var cityidarr: [String]!
    var stateid: String!
    var cityid: String!
    var dealersrr: [String]!
    var dealerid: String!
    var drid: [String]!
    var hosid: [String]!
    var hosdes: [String]!
    var hospitalTypeid: String!
    var hospitaldesc: String!
    static var noheight: CGFloat!
    static var yesheight: CGFloat!
    var lat, longi : String!
    var locationManager:CLLocationManager!
    var salespersonarr: [String]!
    var salespersonid: String!
    static var nxtHos: Bool?
    var mobilecheck: Bool!
    var submitCheck: Bool!
    var customercode: String!
    var isSetDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setnav(controller: self, title: "Attach Hospital")
        submitCheck = true
        lat = "0"
        longi = "0"
        //  determineMyCurrentLocation()
        cityidarr = []
        dealersrr = []
        stateidarr = []
        drid = []
        hosid = []
        hosdes = []
        salespersonarr = []
        noofbeds.delegate = self
        hospitalname.delegate = self
        address.delegate = self
        otherdecision.delegate = self
        namepurchaseman.delegate = self
        namepurchaseman.autocapitalizationType = .words
        otherdecision.autocapitalizationType = .words

        if AppDelegate.usertype == "11"{
            //hide saleperson spinner
            //salespersoncode.isHidden = true
            self.hideview(view: salespersoncode)
            self.hideview(view: salespersonlbl)
        }
        AppDelegate.hosDealerId = ""
        Addhospitalvc.nxtHos = false
        self.sethosspnr()
        if (AppDelegate.hoscode.contains("HOS") && !(AppDelegate.isFromCustomerCardList)){
            customercode = self.getID()
            if(AppDelegate.source=="Attach Doctor" || AppDelegate.isFromSalesPersonList){
                AppDelegate.customercode = customercode
            }
        }
        else{
            customercode = AppDelegate.customercode
        }
        if(AppDelegate.hoscustomercode == ""){
            AppDelegate.oldhoscode = AppDelegate.hoscode
            AppDelegate.hoscustomercode = self.customercode!
        }
        
        Addhospitalvc.yesheight = otherdecision.frame.height
        if AppDelegate.source == "cust" {
            self.hideview(view: self.salespersoncode)
            self.hideview(view: self.salespersonlbl)
        }
        self.otherdecision.isHidden = true
        mobilecheck = true
        hospitaltypespinr.didSelect { (select, index, id) in
            self.hospitalTypeid = self.hosid[index]
            self.hospitaldesc = self.hosdes[index]
            if self.hospitaldesc == "-Select-"{
                self.hospitalname.placeholder = "Name"
                self.hospitalname.selectedTitle = "Name"
            }else{
                self.hospitalname.placeholder = self.hospitaldesc + " Name"
                self.hospitalname.selectedTitle = self.hospitaldesc + " Name"
            }
            if(AppDelegate.isDebug){
                print("dealerid===>\(self.dealerid!)")
            }
        }
        chainspinr.optionArray = ["Select","Chain","Single"]
        chainspinr.text = chainspinr.optionArray[0]
        purchasemanagerspinr.optionArray = ["Yes","No"]
        purchasemanagerspinr.text = purchasemanagerspinr.optionArray[0]
        purchasemanagerspinr.didSelect { (selected, index, id) in
            switch index {
            case 0:
                //            self.hideview(view: self.otherdecision)
                self.otherdecision.isHidden = true
                self.namepurchaseman.selectedTitle = "Name of purchase manager"
                self.mobilepurchaseman.selectedTitle = "Mobile No. of purchase manager"
                self.namepurchaseman.placeholder = "Name of purchase manager"
                self.mobilepurchaseman.placeholder = "Mobile No. of purchase manager"
                self.namepurchaseman.text = ""
                self.mobilepurchaseman.text = ""
                self.otherdecision.text = ""
                break
            case 1:
                self.otherdecision.isHidden = false
                self.namepurchaseman.selectedTitle = "Post of decision maker"
                self.namepurchaseman.placeholder = "Post of decision maker"
                self.namepurchaseman.text = ""
                self.mobilepurchaseman.placeholder = "Other decision maker's Mobile no"
                self.mobilepurchaseman.selectedTitle = "Other decision maker's Mobile no"
                self.mobilepurchaseman.text = ""
                self.otherdecision.text = ""
                //           self.showview(view: self.otherdecision , height: Addhospitalvc.yesheight)
                break
            default:
                break
            }
        }
        
        self.superdealerspinr.didSelect(completion: { (selection, index, id) in
            self.dealerid = self.dealersrr[index]
            AppDelegate.hosDealerId = self.dealersrr[index]
        })
        
        chainspinr.didSelect { (selected, index, id) in
            switch index {
            case 1:
                self.chainspinr.text! = "Chain"
                break
            case 2:
                self.chainspinr.text! = "Single"
                break
            default:
                break
            }
        }
        
        self.setdetail()
        self.updateprog()
        self.superdealerspinr.listHeight = 250.0
        self.cityspinr.isSearchEnable = false
        self.cityspinr.listHeight = 0.0
        let tapcityspinr = UITapGestureRecognizer(target: self, action: #selector(self.cityspinrtapped))
        self.cityspinr.addGestureRecognizer(tapcityspinr)
    }
    
     @objc func cityspinrtapped(){
           self.cityspinrIntent()
       }
    
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
        attachdoclist.isfrom = "Hospital"
        self.navigationController?.pushViewController(attachdoclist, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
            self.updateprog()
        }
        
        SwiftEventBus.onMainThread(self, name: "setcity") { Result in
            self.cityspinr.text = AppDelegate.cityNameSpinner
            self.cityid = AppDelegate.cityidSpinner
        }
    }
    
    func salesspinrSelect(){
        if self.superdealerspinr.isUserInteractionEnabled {
            self.setdealerspinr(salespersonid: self.salespersonid)
        }
        self.superdealerspinr.didSelect(completion: { (selection, index, id) in
            self.dealerid = self.dealersrr[index]
            AppDelegate.hosDealerId = self.dealersrr[index]
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
    
    func setsalespersonspinner(){
        
        var stmt1: OpaquePointer?
        let query = "select usercode,empname  from USERHIERARCHY where employeecode = '\(UserDefaults.standard.string(forKey: "userid")!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
              if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            self.salespersoncode.text = String(cString: sqlite3_column_text(stmt1, 1))
            self.salespersoncode.isUserInteractionEnabled = false
            self.salespersonid = String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    func updateprog(){
        self.genralDetailsPer.text = "General Details" + "(\(Int(gethospitalpercent(hosid: AppDelegate.hoscode)))%)"
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
        
        //     print("user latitude = \(userLocation.coordinate.latitude)")
        //     print("user longitude = \(userLocation.coordinate.longitude)")
        lat = String(userLocation.coordinate.latitude)
        longi = String(userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
          if(AppDelegate.isDebug){
        print("Error \(error)")
        }
    }
    func setdealerspinr(salespersonid: String?)
    {
        superdealerspinr.optionArray.removeAll()
        dealersrr.removeAll()
        var query: String?
        var stmt1: OpaquePointer?
        if salespersoncode.isHidden == true{
            query  = "select '' as siteid, '-Select-' as sitename union select siteid,sitename from USERDISTRIBUTOR"
        }else{
//            query = "select '' as siteid,'Select' as sitename union select  A.siteid ,A.sitename  from USERDISTRIBUTOR A inner join USERDISTRIBUTORLIST B on B.siteid=A.siteid where B.userCode = '\(salespersonid!)'"
            
             query = "select '' as siteid,'-Select-' as sitename union select  A.siteid ,A.sitename  from USERDISTRIBUTOR A inner join USERDISTRIBUTORLIST B on B.siteid=A.siteid where B.userCode = '\(salespersonid!)'"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let sitename = String(cString: sqlite3_column_text(stmt1, 1))
            let siteid = String(cString: sqlite3_column_text(stmt1, 0))
            
            superdealerspinr.optionArray.append(sitename)
            dealersrr.append(siteid)
            print("siteid======> \(siteid)")
        }
        self.superdealerspinr.text = superdealerspinr.optionArray[0]
    }
    
    func sethosspnr()
    {
        hospitaltypespinr.optionArray.removeAll()
        hosid.removeAll()
        
        var stmt1: OpaquePointer?
        
        let query = "select '-1' as typeid,'-Select-' as typedesc union select typeid,typedesc from hospitalType where isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let typedesc = String(cString: sqlite3_column_text(stmt1, 1))
            let typeid = String(cString: sqlite3_column_text(stmt1, 0))
            hospitaltypespinr.optionArray.append(typedesc)
            hosdes.append(typedesc)
            hosid.append(typeid)
            print("typeid======> \(typeid)")
        }
        hospitaltypespinr.text = hospitaltypespinr.optionArray[0]
    }
    
    func setstatespinr(usercode: String?)
    {
        statespinr.optionArray.removeAll()
        stateidarr.removeAll()
        var query: String?
        var stmt1: OpaquePointer?
        if salespersoncode.isHidden == true{
            query = "select '' as StateId, '-Select-' as StateName union select StateId,StateName from statemaster where stateid = (select distinct stateid from CityMaster where cityid = (select cityid from UserLinkCity))"
        }else{
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
    
    func validate() -> Bool {
        var validate = true
        
        if self.salespersoncode.text! == "Select" {
            self.showtoast(controller: self, message: "Select Sales Person", seconds: 1.5)
            validate = false
        }
        else if superdealerspinr.text! == "-Select-" {
            self.showtoast(controller: self, message: "Select Super Dealer", seconds: 1.5)
            validate = false
        }
        else if hospitaltypespinr.text! == "-Select-" {
            self.showtoast(controller: self, message: "Select Hospital Type", seconds: 1.5)
            validate = false
        }
        else if hospitalname!.text ==  "" {
            self.showtoast(controller: self, message: "Enter Hospital Name", seconds: 1.5)
            validate = false
        }
        else if statespinr.text! == "Select" {
            self.showtoast(controller: self, message: "Select State", seconds: 1.5)
            validate = false
        }
        else if cityspinr.text! == "Select" || cityspinr.text! == "" || self.checkcity(stateid: self.stateid, usercode: self.salespersonid,citytext: self.cityspinr.text) {
            self.showtoast(controller: self, message: "Select Assigned City", seconds: 1.5)
            validate = false
        }
        else if ((!(pincode.text?.isEmpty)!) && pincode.text?.count != 6)
        {
            self.showtoast(controller: self, message: "Pincode to be of length 6 only ", seconds: 1.5)
            validate = false
        }
        else if purchasemanagerspinr.text == "Yes"{
            if namepurchaseman!.text ==  ""{
                self.showtoast(controller: self, message: "Please Enter Purchase Manager Name", seconds: 1.5)
                validate = false
            }
            else if mobilepurchaseman!.text ==  "" || mobilepurchaseman.text?.count != 10{
                self.showtoast(controller: self, message: "Please Enter Purchase Manager Name Mobile Number", seconds: 1.5)
                validate = false
            }
        }
        else if purchasemanagerspinr.text == "No"{
            if otherdecision!.text == ""{
                self.showtoast(controller: self, message: "Enter Other Decision Maker", seconds: 1.5)
                validate = false
            }
            else if namepurchaseman!.text ==  ""{
                self.showtoast(controller: self, message: "Enter Post of Decision Maker", seconds: 1.5)
                validate = false
            }
            else if mobilepurchaseman!.text ==  "" || mobilepurchaseman.text?.count != 10{
                self.showtoast(controller: self, message: "Enter Decision Maker Mobile Number", seconds: 1.5)
                validate = false
            }
        }
        return validate
    }
    
    func salespersonspinner(){
        salespersonarr.removeAll()
        salespersoncode.optionArray.removeAll()
        var stmt1: OpaquePointer?
        var query: String?
        if cityspinr.isUserInteractionEnabled == false && salespersoncode.isUserInteractionEnabled == true {
            
            query = "select '' as usercode, 'Select' as empname union  select a.usercode,a.empname from USERHIERARCHY a join salelinkcity s on s.usercode = a.usercode join HospitalMaster h on h.cityid = s.cityid where h.hoscode = '(select referencecode from RetailerMaster where customercode = '\(AppDelegate.customercode)' ))' and (a.usertype ='13' or a.usertype='14' or a.usertype='12' or a.usertype='15')"
        }else{
            query = "select '' as usercode, 'Select' as empname union  select usercode,empname from USERHIERARCHY where usertype ='13' or usertype='14' or usertype='15' or usertype='12'"
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let salespersonname = String(cString: sqlite3_column_text(stmt1, 1))
            let salespersonid = String(cString: sqlite3_column_text(stmt1, 0))
            
            salespersoncode.optionArray.append(salespersonname)
            salespersonarr.append(salespersonid)
        }
        salespersoncode.text = salespersoncode.optionArray[0]
    }
    
    func setcityspinr(stateid: String?,usercode:String?)
    {
        cityspinr.optionArray.removeAll()
        cityidarr.removeAll()
        
        var stmt1: OpaquePointer?
        var query: String?
        if salespersoncode.isHidden == true{
            query = "select '' as CityId, '-Select-' as CityName union select A.cityid,B.CityName from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' and  stateid= '\(stateid!)' order by CityName"
        }else {
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
        //  cityspinr.text = cityspinr.optionArray[0]
    }
    
    @IBAction func mobilePurchase(_ sender: SkyFloatingLabelTextField) {
        if (sender.text?.count)! > 0 &&  (sender.text?.count)! < 10 {
            self.showtoast(controller: self, message: "Enter a valid 10 Digit Mobile Number", seconds: 1.5)
            mobilecheck = false
        }
        else {
            mobilecheck = true
        }
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        print("HosDealerid==="+AppDelegate.hosDealerId)
        
        if validate() && mobilecheck {
            if(self.salespersonid==nil){
                self.salespersonid = ""
            }
            
            if(!(AppDelegate.hosDealerId=="")){
               self.dealerid = AppDelegate.hosDealerId
            }
            
            if(self.dealerid==nil){
                self.setSiteId()
            }
            setcityspinrData(stateid: stateid, usercode: self.salespersonid)
            
            if monthalypurchase.text != ""
            {
                if purchasemanagerspinr.text! == "Yes" {
                    self.insertHospitalMaster(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid"), TYPE: self.hospitalTypeid, HOSCODE: AppDelegate.hoscode, HOSNAME: hospitalname.text!, MOBILENO: "0000000000", ALTNUMBER: "0000000000", EMAILID: "-", CityID: cityid, ADDRESS: address.text!, PINCODE: pincode.text!, STATEID: stateid, ISBLOCKED: "false", CREATEDTRANSACTIONID: "0", MODIFIEDTRANSACTIONID: "0", POST: "0", PURCHASEMGR: namepurchaseman.text!, AUTHORISEDPERSON: "", PURCHMGRMOBILENO: mobilepurchaseman.text!, AUTHPERSONMOBILENO: "", DEGISNATION: "", BEDCOUNT: noofbeds.text! == "" ? "" : noofbeds.text!, CATEGORY: chainspinr.text! == "Select" ? "" : chainspinr.text!, SITEID: self.dealerid, HOSPITALTYPE: "-1", ISPURCHASE: purchasemanagerspinr.text! == "Yes" ? "true" : "false", monthlypurchase: monthalypurchase.text!, custrefcode:self.customercode, salepersoncode: self.salespersonid!)
                }
                else {
                    self.insertHospitalMaster(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid"), TYPE: self.hospitalTypeid, HOSCODE: AppDelegate.hoscode, HOSNAME: hospitalname.text!, MOBILENO:"0000000000", ALTNUMBER: "0000000000", EMAILID: "-", CityID: cityid, ADDRESS: address.text!, PINCODE: pincode.text!, STATEID: stateid, ISBLOCKED: "false", CREATEDTRANSACTIONID: "0", MODIFIEDTRANSACTIONID: "0", POST: "0", PURCHASEMGR: "", AUTHORISEDPERSON: otherdecision.text!, PURCHMGRMOBILENO: "", AUTHPERSONMOBILENO: mobilepurchaseman.text!, DEGISNATION: namepurchaseman.text!, BEDCOUNT: noofbeds.text! == "" ? "" : noofbeds.text!, CATEGORY: chainspinr.text! == "Select" ? "" : chainspinr.text!, SITEID: self.dealerid, HOSPITALTYPE: "-1", ISPURCHASE: purchasemanagerspinr.text! == "Yes" ? "true" : "false", monthlypurchase: monthalypurchase.text!, custrefcode: self.customercode, salepersoncode: self.salespersonid!)
                    
                }
                if(self.salespersoncode.isHidden == false){
                    self.insertretailermaster(customercode: self.customercode , customername: hospitalname.text! , customertype: "CG0005", contactperson: hospitalname.text! , mobilecustcode: "", mobileno:"0000000000" , alternateno: "0000000000" , emailid: "-" , address: address.text! , pincode: pincode.text! , city: cityid , stateid: stateid , gstno: "", gstregistrationdate: "", siteid: self.dealerid , salepersonid: self.salespersonid , keycustomer: "true", isorthopositive: "false", sizeofretailer: "", category: "", isblocked: "false", pricegroup: UserDefaults.standard.string(forKey: "pricegroup")! , dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! , latitude: lat , longitude: longi , orthopedicsale: "", avgsale: monthalypurchase.text! , prefferedbrand: "", secprefferedbrand: "", secprefferedsale: "", prefferedsale: "", prefferedreasonid: "", secprefferedreasonid: "", createdtransactionid: "0", modifiedtransactionid: "0", post: "0", referencecode: AppDelegate.hoscode , lastvisited: "", storeimage: "", stockimage: "", prefferedothbrand: otherdecision.text! , secprefferedothbrand: "")
                    
                }
                Marketvc.superdealerstr = self.dealerid
                //  Addhospitalvc.nxtHos = false
                AttachHospitalvc.flag = false
                Addhospitalvc.nxtHos = true
                AppDelegate.showHosList = false
                self.isSetDetails = true
                self.setdetail()
                
                if((AppDelegate.source=="Attach Doctor" || AppDelegate.isFromSalesPersonList || AppDelegate.source.isEmpty) || (AppDelegate.source == "Hospital" && !AppDelegate.isDocScreen)){
                    self.showtoast(controller: self, message: "General Details Added Successfully", seconds: 1.5)
                }
                else{
                    self.showOkalert(controller: self)
                }
                SwiftEventBus.post("updateprogress")
                SwiftEventBus.post("gotohossegment")
            }
            else{
                self.showtoast(controller: self, message: "Please Enter Approx Monthly Purchase", seconds: 1.5)
            }
        }
        else {
            self.showtoast(controller: self, message: "Field's can't be empty", seconds: 1.5)
        }
    }
    
    func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
        for (index, obj) in array.enumerated() where obj == object {
            return index
        }
        return nil
    }
    
    func showOkalert(controller: UIViewController){
        let alert = UIAlertController(title: "Alert", message: "General Details Added Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            if(AppDelegate.titletxt == "Doctor" || AppDelegate.titletxt == "Hospital"){
                AppDelegate.customercode = AppDelegate.doccustomercode
            }
            AppDelegate.isHosScreen = false
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
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
    
    func setdetail()
    {
        
        var stmt1: OpaquePointer?
        
        let query = "select A.*,B.typedesc from hospitalmaster A left outer join HospitalType B on B.typeid = A.type where A.hoscode = '\(AppDelegate.hoscode)' and A.hoscode <> '' "
        
        print("setDetail=="+query)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW)
        {
            if(AppDelegate.isFromSalesPersonList && !self.isSetDetails ){
                Addhospitalvc.nxtHos = false
            }
            else {
                Addhospitalvc.nxtHos = true
            }
            
            let salespersonc = String(cString: sqlite3_column_text(stmt1, 27))
            if salespersonc == ""{
                if salespersoncode.isHidden == false{
                    setsalespersonspinner()
                    salesspinrSelect()
                }
            }
            else{
                self.salespersoncode.text = String(cString: sqlite3_column_text(stmt1, 27))
                self.salespersonid = String(cString: sqlite3_column_text(stmt1, 27))
            }
            
            self.dealerid = String(cString: sqlite3_column_text(stmt1, 22))
            setdealername(siteid: self.dealerid)
            
            Marketvc.superdealerstr = self.dealerid
            self.otherdecision.text = String(cString: sqlite3_column_text(stmt1, 1))
            self.setuserintractionfalse(textfield: otherdecision)
            self.hospitalname.text = String(cString: sqlite3_column_text(stmt1, 3))
            self.setuserintractionfalse(textfield: hospitalname)
            self.address.text = String(cString: sqlite3_column_text(stmt1, 8))
            self.setuserintractionfalse(textfield: address)
            self.pincode.text = String(cString: sqlite3_column_text(stmt1, 9))
            self.setuserintractionfalse(textfield: pincode)
            self.namepurchaseman.text = String(cString: sqlite3_column_text(stmt1, 16))
            self.setuserintractionfalse(textfield: namepurchaseman)
            self.mobilepurchaseman.text = String(cString: sqlite3_column_text(stmt1, 17))
            self.setuserintractionfalse(textfield: mobilepurchaseman)
            let noofBedstext = String(sqlite3_column_int64(stmt1, 20))
            
            if (noofBedstext=="0")  {
                noofbeds.isUserInteractionEnabled = true
                self.noofbeds.text = ""
            }
            else{
                self.noofbeds.text = String(sqlite3_column_int64(stmt1, 20))
                self.setuserintractionfalse(textfield: noofbeds)
            }
            
            self.hospitaltypespinr.text = String(cString: sqlite3_column_text(stmt1, 28))
            let hospitaltype = String(cString: sqlite3_column_text(stmt1, 28))
            self.hospitalname.placeholder = String(cString: sqlite3_column_text(stmt1, 28)) + " Name"
            self.hospitaltypespinr.isEnabled = false
            let category = String(cString: sqlite3_column_text(stmt1, 21))
            
            if category == ""{
                self.chainspinr.text = chainspinr.optionArray[0]
            }
                
            else{
                self.chainspinr.text = category
                self.setuserintractionfalse(textfield: chainspinr)
            }
            
            if hospitaltype == "Hospital"{
                self.hospitalTypeid = "1"
            }
            else if hospitaltype == "Nursing Home"{
                self.hospitalTypeid = "2"
            }
            else if hospitaltype == "Clinic"{
                self.hospitalTypeid = "3"
            }
            
            self.monthalypurchase.text = String(cString: sqlite3_column_text(stmt1, 25))
            self.monthalypurchase.isUserInteractionEnabled = false
            
            self.setstatename()
            self.setcityname()
            
            let ispurchase: String = String(cString: sqlite3_column_text(stmt1, 24))
            
            if ispurchase == "true"{
                self.purchasemanagerspinr.text = "Yes"
                self.purchasemanagerspinr.isUserInteractionEnabled =  false
            }
            else{
                self.purchasemanagerspinr.text = "No"
                self.purchasemanagerspinr.isUserInteractionEnabled =  false
            }
            
            switch ispurchase {
            case "true":
                //  self.hideview(view: self.otherdecision)
                self.otherdecision.isHidden = true
                self.namepurchaseman.selectedTitle = "Name of purchase manager"
                self.mobilepurchaseman.selectedTitle = "Mobile No. of purchase manager"
                self.namepurchaseman.text = String(cString: sqlite3_column_text(stmt1, 15))
                self.namepurchaseman.isUserInteractionEnabled = false
                self.mobilepurchaseman.text = String(cString: sqlite3_column_text(stmt1, 17))
                self.mobilepurchaseman.isUserInteractionEnabled = false
                self.namepurchaseman.placeholder = "Name of purchase manager"
                self.mobilepurchaseman.placeholder = "Mobile No. of purchase manager"
                
                break
            case "false":
                self.otherdecision.isHidden = false
                self.otherdecision.text = String(cString: sqlite3_column_text(stmt1, 16))
                self.otherdecision.isUserInteractionEnabled = false
                self.namepurchaseman.selectedTitle = "Post of decision maker"
                self.namepurchaseman.text = String(cString: sqlite3_column_text(stmt1, 19))
                self.namepurchaseman.isUserInteractionEnabled = false
                self.mobilepurchaseman.text = String(cString: sqlite3_column_text(stmt1, 18))
                self.mobilepurchaseman.isUserInteractionEnabled = false
                self.namepurchaseman.placeholder = "Post of decision maker"
                self.mobilepurchaseman.placeholder = "Other decision maker's Mobile no"
                self.mobilepurchaseman.selectedTitle = "Other decision maker's Mobile no"
                //  self.showview(view: self.otherdecision , height: Addhospitalvc.yesheight)
                break
                
            default:
                break
            }
        }
            
        else
        {
            if salespersoncode.isHidden == false{
                salespersonspinner()
                setsalespersonspinner()
                salesspinrSelect()
                
                salespersoncode.didSelect { (selection, index, id) in
                    self.salespersonid = self.salespersonarr[index]
                    self.setdealerspinr(salespersonid: self.salespersonid)
                    self.superdealerspinr.didSelect(completion: { (select, index, id) in
                        self.dealerid =  self.dealersrr[index]
                        AppDelegate.hosDealerId =  self.dealersrr[index]
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
            }
            else {
                //bind state city spinner and superdealer spinner
                setstatespinr(usercode: "")
                setcityspinr(stateid: stateid, usercode:"")
                setdealerspinr(salespersonid: "")
            }
        }
    }
    
    func setstatename(){
        var stmt1: OpaquePointer?
        
        let query = "select statename,stateid from statemaster where stateid = (select stateid from HospitalMaster where HOSCODE = '\(AppDelegate.hoscode)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            statespinr.text = String(cString: sqlite3_column_text(stmt1, 0))
            self.stateid = String(cString: sqlite3_column_text(stmt1, 1))
        }
        self.statespinr.isUserInteractionEnabled = false
    }
    
    func setcityname(){
        
        var stmt1: OpaquePointer?
        
        let query = "select cityname,cityid from citymaster where cityid = (select cityid from HospitalMaster where HOSCODE = '\(AppDelegate.hoscode)')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            cityspinr.text = String(cString: sqlite3_column_text(stmt1, 0))
            self.cityid = String(cString: sqlite3_column_text(stmt1, 1))
        }
        
        self.cityspinr.isUserInteractionEnabled = false
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
            self.superdealerspinr.text = String(cString: sqlite3_column_text(stmt1, 0))
            self.superdealerspinr.isUserInteractionEnabled = false
        }else{
            self.superdealerspinr.attributedText = Retailerlistvc.wrongdealertext
            self.superdealerspinr.isUserInteractionEnabled = false
        }
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
    
    @IBAction func backbtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        if(AppDelegate.titletxt == "Doctor" || AppDelegate.titletxt == "Hospital"){
            AppDelegate.customercode = AppDelegate.doccustomercode
        }
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    func checkcity(stateid: String?,usercode:String?,citytext: String?)-> Bool{
        
        var stmt1: OpaquePointer?
        var query: String?
        
        if(self.cityspinr.isUserInteractionEnabled == false){
            return false
        }
        
        if salespersoncode.isHidden == true{
            query = "select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where  SE.stateid = '\(stateid!)' and cityname = '\(citytext!)' and SE.isblocked <> 'true' order by cm.cityid"
        }
        else{
            query = "select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and SE.stateid = '\(stateid!)' and cityname = '\(citytext!)' and SE.isblocked <> 'true' order by cm.cityid"
            
        }
        
        print("CheckCityHospital=="+query!)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
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
    
}
