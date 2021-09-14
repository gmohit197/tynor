//
//  Marketvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 27/06/19.
//  Copyright © 2019 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus
import SkyFloatingLabelTextField
import CoreLocation


class Marketvc: Executeapi,UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print()
        if range.location == 0 && string == " " {
            return false
        }
        if(textField.tag==8){
            return string.rangeOfCharacter(from: CharacterSet(charactersIn: "#$%&'()*+,-:;<=>?[]^_`{|}~!'/Ω⍷␢⍹")) == nil
        }
        return string.rangeOfCharacter(from: CharacterSet(charactersIn: "#$%&'()*+,-:;<=>?[]^_`{|}~!'/Ω⍷␢⍹@")) == nil
    }
    var custcode: String?
    var source: String?
    var customername = ""
    var titletext: String?
    var siteid: String?
    var checkmi: Bool!
    var stateidarr: [String]!
    var cityidarr: [String]!
    var dealersrr: [String]!
    var stateid: String!
    var cityid: String!
    var salesid: String!
    var dealerid: String!
    var titletextgd: String?
    var lat, long : String!
    var controller: UIViewController!
    var controllerheight: CGFloat!
    var mobilecheck: Bool!
    var custtype : String?
    var customercode : String!
    
    public static var superdealerstr = ""
    
    @IBOutlet weak var dealerspinr: DropDownUtil!
    @IBOutlet weak var averagesale: SkyFloatingLabelTextField!
    @IBOutlet weak var monthlysale: SkyFloatingLabelTextField!
    @IBOutlet weak var orthoposspinr: DropDownUtil!
    @IBOutlet weak var gstnum: SkyFloatingLabelTextField!
    @IBOutlet weak var saleprsnspinr: DropDownUtil!
    @IBOutlet weak var pincode: SkyFloatingLabelTextField!
    @IBOutlet weak var cityspinr: DropDownUtil!
    @IBOutlet weak var statespinr: DropDownUtil!
    @IBOutlet weak var address: SkyFloatingLabelTextField!
    @IBOutlet weak var chemistname: SkyFloatingLabelTextField!
    @IBOutlet weak var email: SkyFloatingLabelTextField!
    @IBOutlet weak var landlinenum: SkyFloatingLabelTextField!
    @IBOutlet weak var mobilenum: SkyFloatingLabelTextField!
    @IBOutlet weak var customerspinr: DropDownUtil!
    @IBOutlet weak var ownername: SkyFloatingLabelTextField!
    @IBOutlet var genralDetailsPer: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
            self.updateprog()
        }
        SwiftEventBus.onMainThread(self, name: "setcity") { Result in
            self.cityspinr.text = AppDelegate.cityNameSpinner
            self.cityid = AppDelegate.cityidSpinner
        }
        print("City===ViewWillAppearCalled")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("City===ViewDidAppearCalled")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("City===ViewDidDisAppearCalled")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Market Intelligence")
      
        cityidarr = []
        stateidarr = []
        dealersrr = []
        
        gstnum.delegate = self
        ownername.delegate = self
        address.delegate = self
        email.delegate = self
        chemistname.delegate = self
        
        orthoposspinr.optionArray = ["Select","Yes","No"]
        orthoposspinr.text = orthoposspinr.optionArray[0]
        lat = "0"
        long = "0"
        mobilecheck = true
        self.dealerspinr.text = "Select"
        setdetail()
        
        customerspinr.isUserInteractionEnabled = false
        
        if AppDelegate.isChemist {
            customercode = "CHE" + self.getIDNew()
            AppDelegate.chemcustcode = customercode
            AppDelegate.oldChemcustomercode = customercode
        }
        else{
            customercode = AppDelegate.customercode
        }
        
         AppDelegate.retcustomercode = self.customercode!
        
        if(AppDelegate.titletxt == "Doctor" || AppDelegate.titletxt == "Hospital"){
             customerspinr.text = "RETAILER"
        }
        else{
             customerspinr.text = AppDelegate.titletxt
        }

        self.updateprog()
        self.email.keyboardType = UIKeyboardType.emailAddress
        
        self.dealerspinr.listHeight = 250.0
        self.cityspinr.listHeight = 0.0
        self.cityspinr.isSearchEnable = false
        
        let tapcityspinr = UITapGestureRecognizer(target: self, action: #selector(self.cityspinrtapped))
        self.cityspinr.addGestureRecognizer(tapcityspinr)
        
    }
    
    @objc func cityspinrtapped(){
        print("cityspinrtapped")
        self.cityspinrIntent()
    }
    
    func updateprog(){
        if(AppDelegate.isChemist){
            self.genralDetailsPer.text = "General Details" + "(\(Int(getretailerpecent(customercode: AppDelegate.chemcustcode)))%)"
        }
        else {
            self.genralDetailsPer.text = "General Details" + "(\(Int(getretailerpecent(customercode: AppDelegate.customercode)))%)"
        }
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        if source == "customer" {
            let customercard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            customercard.customercode = self.custcode
            customercard.titletxt = self.titletext
            CustomerCard.siteid = self.siteid
            customercard.customername = AppDelegate.customername
            self.navigationController?.pushViewController(customercard, animated: true)
        }
        else if source == "Retailer" {
            let retailer: Retailerlistvc = self.storyboard?.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            retailer.titlebar = self.titletext!
            self.navigationController?.pushViewController(retailer, animated: true)
        }
        else if source == "Doctor" {
            let retailer: Attachdocvc = self.storyboard?.instantiateViewController(withIdentifier: "attachdoc") as! Attachdocvc
            retailer.titletext = self.titletext!
            retailer.custcode = self.custcode!
            AppDelegate.source = "Retailer"
            self.navigationController?.pushViewController(retailer, animated: true)
        }
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
   
    func setdealerspinr(salespersonid: String!)
    {
        dealerspinr.optionArray.removeAll()
        dealersrr.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select '' as siteid,'Select' as sitename union select A.siteid ,A.sitename from USERDISTRIBUTOR A inner join USERDISTRIBUTORLIST B on B.siteid=A.siteid where B.userCode = '\(salespersonid!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let sitename = String(cString: sqlite3_column_text(stmt1, 1))
            let siteid = String(cString: sqlite3_column_text(stmt1, 0))
            dealerspinr.optionArray.append(sitename)
            dealersrr.append(siteid)
            print("siteid======> \(siteid)")
        }
        self.dealerspinr.text = dealerspinr.optionArray[0]
    }
    
    @IBAction func addbtn(_ sender: UIButton) {
        if validate() && mobilecheck {
            print("all set")
            self.insertretailermaster(customercode: self.customercode , customername: chemistname.text! , customertype: "CG0001" , contactperson: ownername.text! , mobilecustcode: "", mobileno: self.mobilenum.text! , alternateno: self.landlinenum.text! , emailid: email.text! , address: address.text! , pincode: pincode.text! , city: self.cityid , stateid: self.stateid , gstno: gstnum.text! , gstregistrationdate: "" , siteid: self.dealerid , salepersonid: self.salesid , keycustomer: "false" , isorthopositive: isorthopos() , sizeofretailer: "" , category: "" , isblocked: "false" , pricegroup: UserDefaults.standard.string(forKey: "pricegroup")! , dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! , latitude: lat , longitude: long , orthopedicsale: monthlysale.text! , avgsale: averagesale.text! , prefferedbrand: "" , secprefferedbrand: "" , secprefferedsale: "" , prefferedsale: "" , prefferedreasonid: "" , secprefferedreasonid: "" , createdtransactionid: "0" , modifiedtransactionid: "0" , post: "0" , referencecode: "" , lastvisited: "" , storeimage: "" , stockimage: "" , prefferedothbrand: "" , secprefferedothbrand: "")
            
            Marketvc.superdealerstr = self.dealerid!
            MarketIntelligence.flag = false
            
            if(AppDelegate.isDebug){
                print("Marketvc.superdealerstr====" + Marketvc.superdealerstr)
            }
            if(AppDelegate.isDebug){
                print("MarketVcCustomerCode==="+AppDelegate.customercode)
            }
            SwiftEventBus.post("updateprogress")
            SwiftEventBus.post("gotosegment")
            
            self.showtoast(controller: self, message: "General Details Added Successfully", seconds: 1.5)
            self.setdetail()
        }
    }
    
    func isorthopos()-> String {
        var ortho: String!
        if orthoposspinr.text == "Yes" {
            ortho = "True"
        }
        else if orthoposspinr.text == "No" {
            ortho = "False"
        }
        return ortho
    }
    
    func validate()-> Bool {
        var result = true
        
        if saleprsnspinr.text == "Select" {
            self.showtoast(controller: self, message: "select Sales Person", seconds: 1.5)
            result = false
        }
        if dealerspinr.text == "Select" {
            self.showtoast(controller: self, message: "select Super Dealer", seconds: 1.5)
            result = false
        }
        else if chemistname.text == "" {
            self.showtoast(controller: self, message: "Enter Chemist Name", seconds: 1.5)
            result = false
        }
        else if ownername.text == "" {
            self.showtoast(controller: self, message: "Enter Owner Name", seconds: 1.5)
            result = false
        }
        else if customerspinr.text == "Select" {
            self.showtoast(controller: self, message: "Select Customer", seconds: 1.5)
            result = false
        }
        else if (((mobilenum.text?.isEmpty)!)) || mobilenum.text?.count != 10 {
            self.showtoast(controller: self, message: "Enter a valid 10 Digit Mobile Number", seconds: 1.5)
            result = false
        }
        else if statespinr.text == "Select" {
            result = false
        }
        else if cityspinr.text == "" || self.checkcity(stateid: self.stateid, usercode:UserDefaults.standard.string(forKey: "usercode")!, citytext: cityspinr.text){
            self.showtoast(controller: self, message: "Select assigned City", seconds: 1.5)
            result = false
        }
        else if ((!(pincode.text?.isEmpty)!) && pincode.text?.count != 6)
        {
                self.showtoast(controller: self, message: "Pincode to be of length 6 only ", seconds: 1.5)
                result = false
         }
        else if gstnum.text != "" && gstnum.text?.count != 15
        {
                self.showtoast(controller: self, message: "Enter 15 Digit GST Number", seconds: 1.5)
                result = false
        }
        else if orthoposspinr.text == "Select" {
            self.showtoast(controller: self, message: "Is it Ortho Positive?", seconds: 1.5)
            result = false
        }
        else if monthlysale.text == "" {
            self.showtoast(controller: self, message: "Monthly Sale of Orthopedic Products Required", seconds: 1.5)
            result = false
        }
        else if averagesale.text == "" {
            self.showtoast(controller: self, message: "Please enter average monthly sale", seconds: 1.5)
            result = false
        }
        return result
    }
    
    func checkcity(stateid: String?,usercode:String?,citytext: String?)-> Bool{
        
        var stmt1: OpaquePointer?
        let query = "select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and SE.stateid = '\(stateid!)' and cityname = '\(citytext!)' and SE.isblocked <> 'true' order by cm.cityid"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return false
        }
        return true
    }
    
    
    func setstatespinr(usercode: String?)
    {
        statespinr.optionArray.removeAll()
        stateidarr.removeAll()
        var stmt1: OpaquePointer?
        let query = "select '' as stateid , '-Select-' as statename union SELECT distinct A.stateid, A.statename FROM StateMaster A join salelinkcity B on A.stateid = b.stateid AND b.isblocked = 'false' and B.usercode = '\(usercode!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var statename=""
        var stateid=""
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            statename = String(cString: sqlite3_column_text(stmt1, 1))
            stateid = String(cString: sqlite3_column_text(stmt1, 0))
            
            statespinr.optionArray.append(statename)
            stateidarr.append(stateid)
        }
        if (stateidarr.count == 1){
            statespinr.text = "Select"
            statespinr.isUserInteractionEnabled = false
        } else{
            statespinr.text = statespinr.optionArray[1]
            statespinr.isUserInteractionEnabled = false
            self.stateid = self.stateidarr[1]
        }
    }
    
    func setcityspinr(stateid: String?,usercode:String?)
    {
        cityspinr.optionArray.removeAll()
        cityidarr.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select CM.CITYID,CM.CITYNAME from salelinkcity SE  JOIN CITYMASTER CM  ON SE.CITYID=CM.CITYID where SE.usercode = '\(usercode!)' and SE.stateid = '\(stateid!)' and SE.isblocked <> 'true' order by cm.cityid"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var cityname=""
        var cityid=""
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            cityname = String(cString: sqlite3_column_text(stmt1, 1))
            cityid = String(cString: sqlite3_column_text(stmt1, 0))
            
            cityspinr.optionArray.append(cityname)
            cityidarr.append(cityid)
        }
    }
    
    func setsaleprsnspinr()
    {
        var stmt1: OpaquePointer?
//        let query = "select '0' as usercode, 'Select' as empname union  select usercode,empname  from USERHIERARCHY where usertype ='11' or usertype='12'"
        
        let query = "select usercode,empname  from USERHIERARCHY where employeecode = '\(UserDefaults.standard.string(forKey: "userid")!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            saleprsnspinr.text = String(cString: sqlite3_column_text(stmt1, 1))
            saleprsnspinr.isUserInteractionEnabled = false
            self.salesid = String(cString: sqlite3_column_text(stmt1, 0))
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
        var query = ""
        
        if(AppDelegate.isChemist){
             query = "select * from Retailermaster where customercode ='\(AppDelegate.chemcustcode)'"
        }
        else {
             query = "select * from Retailermaster where customercode ='\(AppDelegate.customercode)'"
        }
        
        print("setDetail====" + AppDelegate.customercode)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW)
        {
            self.saleprsnspinr.text = String(cString: sqlite3_column_text(stmt1, 15))
            self.salesid = String(cString: sqlite3_column_text(stmt1, 15))
            self.dealerid = String(cString: sqlite3_column_text(stmt1, 14))
            setdealername(siteid:  self.dealerid)
            Marketvc.superdealerstr = self.dealerid
            self.averagesale.text = String(sqlite3_column_int64(stmt1, 26))
            self.setuserintractionfalse(textfield: averagesale)
            self.monthlysale.text = String(cString: sqlite3_column_text(stmt1, 25))
            self.setuserintractionfalse(textfield: monthlysale)
            self.gstnum.text = String(cString: sqlite3_column_text(stmt1, 12))
            self.setuserintractionfalse(textfield: gstnum)
            self.pincode.text = String(cString: sqlite3_column_text(stmt1, 9))
            self.setuserintractionfalse(textfield: pincode)
            self.address.text = String(cString: sqlite3_column_text(stmt1, 8))
            self.setuserintractionfalse(textfield: address)
            self.chemistname.text = String(cString: sqlite3_column_text(stmt1, 1))
            self.setuserintractionfalse(textfield: chemistname)
            self.email.text = String(cString: sqlite3_column_text(stmt1, 7))
            self.setuserintractionfalse(textfield: email)
            self.landlinenum.text = String(cString: sqlite3_column_text(stmt1, 6))
            self.setuserintractionfalse(textfield: landlinenum)
            self.mobilenum.text = String(cString: sqlite3_column_text(stmt1, 5))
            self.setuserintractionfalse(textfield: mobilenum)
            self.ownername.text = String(cString: sqlite3_column_text(stmt1, 3))
            self.setuserintractionfalse(textfield: ownername)
            let isortho = String(cString: sqlite3_column_text(stmt1, 17))
            if isortho == "true"{
                orthoposspinr.text = "Yes"
            }
            else{
                orthoposspinr.text = "No"
            }
            orthoposspinr.isUserInteractionEnabled = false
            self.setstatename()
            self.setcityname()
        }
        else{
            setsaleprsnspinr()
            orthoposspinr.isUserInteractionEnabled = true
            salesspinrSelect()
        }
    }
    
    func salesspinrSelect(){
        self.setdealerspinr(salespersonid: self.salesid)
        self.dealerspinr.didSelect(completion: { (select, index, id) in
            self.dealerid =  self.dealersrr[index]
            AppDelegate.siteid = self.dealerid
        })
        self.setstatespinr(usercode: self.salesid)
        if self.stateidarr.count == 1{
            self.cityspinr.text = "Select City"
        }
        else{
            self.setcityspinr(stateid: self.stateid, usercode: self.salesid)
            self.cityspinr.didSelect(completion: { (select, index, id) in
                self.cityid = self.cityidarr[index]
                self.cityspinrIntent()
            })
        }
    }
    
    func cityspinrIntent(){
        let attachdoclist: Attachdoclist = self.storyboard?.instantiateViewController(withIdentifier: "addnewdoc") as! Attachdoclist
        attachdoclist.titletext = "City"
        attachdoclist.stateid = self.stateid
        attachdoclist.usercode = self.salesid
        attachdoclist.flag = "false"
        attachdoclist.isfrom = "Market"
        self.navigationController?.pushViewController(attachdoclist, animated: true)
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
            self.dealerspinr.text = String(cString: sqlite3_column_text(stmt1, 0))
        } else{
            self.dealerspinr.attributedText = Retailerlistvc.wrongdealertext
        }
        self.dealerspinr.isUserInteractionEnabled = false
    }
    
    func setcityname(){
        var stmt1: OpaquePointer?
        var query = ""
        if(AppDelegate.isChemist){
             query = "select cityname,cityid from citymaster where cityid = (select city from retailermaster where customercode = '\(AppDelegate.chemcustcode)')"
        }
        else {
            query = "select cityname,cityid from citymaster where cityid = (select city from retailermaster where customercode = '\(AppDelegate.customercode)')"

        }
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
    
    func setstatename(){
        var stmt1: OpaquePointer?
        var query = ""

        if(AppDelegate.isChemist){
         query = "select statename,stateid from statemaster where stateid = (select stateid from retailermaster where customercode = '\(AppDelegate.chemcustcode)')"
           }
        else {
         query = "select statename,stateid from statemaster where stateid = (select stateid from retailermaster where customercode = '\(AppDelegate.customercode)')"
        }
//        let query = "select statename,stateid from statemaster where stateid = (select stateid from retailermaster where customercode = '\(self.customercode)')"
        
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
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
}
