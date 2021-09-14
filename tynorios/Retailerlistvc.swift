//
//  Retailerlistvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 25/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//



import UIKit
import SQLite3
import SwiftEventBus

class Retailerlistvc: Executeapi, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
    {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retaileradapter.count
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.setlist(retailername: self.retailer, cityname: self.citynamestr , keycustomer: self.keycuststr)
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
////        self.retailertxt.text?.removeAll()
////        self.cityspinner.text?.removeAll()
////        self.keycuststr.removeAll()
//        print("textFieldDidBeginEditing==")
//        print(textField.tag)
//
//        if(textField.tag == 0){
//            self.setlist(retailername: "", cityname: self.citynamestr, keycustomer: self.keycuststr)
//
//        }
//
//        else if (textField.tag == 1){
//            self.setlist(retailername: self.retailer, cityname: self.citynamestr, keycustomer: "")
//
//        }
//        else if (textField.tag == 2){
//             self.setlist(retailername: self.retailer, cityname: "", keycustomer: self.keycuststr)
//
//        }
////            self.retailertxt.text?.removeAll()
////            self.cityspinner.text?.removeAll()
////            self.keycuststr.removeAll()
//    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    @IBAction func customersearch(_ sender: UITextField) {
        retailer = sender.text
        self.setlist(retailername: retailer, cityname: self.citynamestr, keycustomer: self.keycuststr)
    }
    
    @IBAction func citysrch(_ sender: UITextField) {
        citynamestr = sender.text
        self.setlist(retailername: self.retailer, cityname: self.citynamestr,keycustomer: self.keycuststr)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Retailerlistcell
        let list: Retailerlistadapter
        list = retaileradapter[indexPath.row]
        if (titlebar == "Doctor"){
            if ((prescribingarr[indexPath.row] == "true")){
                cell.percribestack.isHidden = false
                cell.prescribe.isHidden = false
            }
            else{
                cell.prescribe.isHidden = true
            }
            if((purchasingarr[indexPath.row] == "true")){
                cell.percribestack.isHidden = false
                cell.purchase.isHidden = false
            }
            else{
                cell.purchase.isHidden = true
            }
        }
        
        cell.customername.text = list.customername
        cell.cf.text = list.complain
        cell.curmonth.text = list.currmonth
        if list.sitename == ""{
         //   let fullString = NSMutableAttributedString(string: "Wrong Dealer Attached")
            let fullString = NSMutableAttributedString(string: "Wrong Dealer Attached ")
            // create our NSTextAttachment
            let image1Attachment = NSTextAttachment()
//            image1Attachment.image = UIImage(named: "markfordealer.png")
       //     image1Attachment.image = UIImage(named: "markfordealer_ios.png")
            image1Attachment.image = UIImage(named: "mark_final.png")

            // wrap the attachment in its own attributed string so we can append it
            let image1String = NSAttributedString(attachment: image1Attachment)
            
            // add the NSTextAttachment wrapper to our full string, then add some more text.
            fullString.append(image1String)
            
            cell.distributor.attributedText = fullString
            cell.distributor.textColor = UIColor.red
        }else{
            cell.distributor.text = list.sitename
            cell.distributor.textColor = UIColor.black
        }
        cell.lastvisit.text = list.lastvisit
        cell.mi.text = list.mi
        cell.cityname.text = list.cityname
        
        if (signarr[indexPath.row] == "-1"){
            cell.sign.isHidden = true
        }else if (signarr[indexPath.row] == "0"){
            cell.sign.isHidden = true
        }else if (signarr[indexPath.row] == "1"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "greentick")
        }else if (signarr[indexPath.row] == "2"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "red_tick")
        }else if (signarr[indexPath.row] == "3"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "esc_arrow")
        }else if (signarr[indexPath.row] == "4"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "question")
        }else if (signarr[indexPath.row] == "5"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "escalationsign")
        }else if (signarr[indexPath.row] == "6"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "likelytobuy")
        }
        return cell
    }
    
    let someImageView: UIImageView = {
       let theImageView = UIImageView()
       theImageView.image = UIImage(named: "box.png")
       theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
       return theImageView
    }()
    
    var custtype = ""
    var titlebar = ""
    var retailer: String!
    var citynamestr: String!
    var keycuststr: String!
    var retaileradapter = [Retailerlistadapter]()
    var customercodearr: [String]!
    var customerNamearr: [String]!
    var prescribingarr: [String]!
    var purchasingarr: [String]!
    var signarr: [String]!
    var ccode: String?
    var priscription: String?
    var purchasing: String?
    public static var wrongdealertext: NSMutableAttributedString?
    // static var titlebar: String?
    static var pricegroup: String?
    static var customername: String?
    static var stateid : String?
    static var retailerid: String?
    static var isescalated: String?
    static var salepersonid: String?
    var count : Int = 0
    
    @IBOutlet var nodataviewheight: NSLayoutConstraint!
    @IBOutlet weak var retailertxt: UITextField!
    @IBOutlet weak var lastspinner: DropDownUtil!
    @IBOutlet weak var cityspinner: DropDownUtil!
    @IBOutlet weak var retailertable: UITableView!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var nodataview: UIView!
    
    
    
    var islistCalled = false
    
    var loaderr = UIAlertController()
    override func viewDidLoad() {
        super.viewDidLoad()
        retailertable.alwaysBounceVertical = false
        let fullString = NSMutableAttributedString(string: "Wrong Dealer Attached")
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "markfordealer.png")
        
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        Retailerlistvc.wrongdealertext = fullString
        self.retailer = ""
        self.nodataview.isHidden = true
        self.nodataviewheight.constant=0
        self.setnav(controller: self, title: "\(titlebar) List")
        retailertable.delegate = self
        retailertable.dataSource = self
        self.retailertxt.delegate = self
     //   self.cityspinner.delegate = self
        retailertxt.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 16))
        let image = UIImage(named: "search1.png")
        imageView.image = image
        retailertxt.leftView = imageView
        
        cityspinner.leftViewMode = UITextFieldViewMode.always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 16))
        let image1 = UIImage(named: "search1.png")
        imageView1.image = image1
        cityspinner.leftView = imageView1
        
        self.navigationItem.title = titlebar + " List"
        self.addbtn.setTitle("Add \(titlebar)", for: .normal)
        if titlebar == "Doctor" {
            self.addbtn.setTitle("Add Doctors", for: .normal)
            self.addbtn.setBackgroundImage(UIImage(named: "submit.png"), for: UIControlState.normal)
        }
        setcityspinner()
        customercodearr = []
        signarr = []
        prescribingarr = []
        purchasingarr = []
        customerNamearr = []
        retailer  = ""
        citynamestr = ""
        keycuststr = ""
        retailertxt.placeholder?.append(titlebar)
        AppDelegate.titletxt = titlebar
        if titlebar == "Retailer" {
            custtype = "CG0001"
        }
        if titlebar == "Sub Dealer"
        {
            self.hideview(view: addbtn)
            self.hidetextview(view: lastspinner)
            custtype = "CG0004"
        }
        if titlebar == "Hospital" {
            self.hidetextview(view: lastspinner)
            custtype = "CG0005"
        }
        if titlebar == "Doctor"
        {
            self.hidetextview(view: lastspinner)
            custtype = "CG0003"
        }
        
        lastspinner.optionArray = ["ALL","Tynor+","Tynor-"]
        lastspinner.text = lastspinner.optionArray[0]
        
        self.checknet()
        if(!(AppDelegate.ntwrk > 0)){
            self.deleteretailerlistsearch()
            self.getRetailerListDetail(query: "", customertype: custtype, keycustomer: lastspinner.text!, cityname: "")
        }
        
        cityspinner.didSelect { (selected, index, id) in
            self.view.endEditing(true)
            self.citynamestr = selected
            self.setlist(retailername: self.retailer, cityname: self.citynamestr,keycustomer: self.keycuststr)
        }
        
        lastspinner.didSelect { (selection, index, id) in
            if(selection.contains("+")){
                self.keycuststr = "true"

            }
            else if (selection.contains("-")){
                self.keycuststr = "false"
            }
            else {
                 self.keycuststr = ""
            }
            self.setlist(retailername: self.retailer, cityname: self.citynamestr,keycustomer: self.keycuststr)
            // self.keycuststr = selection
            // self.retailertxt.delegate = self
        }
        
        
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getcustomer))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.retailertable.addGestureRecognizer(tapeno)
        
        let tapcityspinr = UITapGestureRecognizer(target: self, action: #selector(self.cityspinrtapped))
        self.cityspinner.addGestureRecognizer(tapcityspinr)
        
        self.retailertable.tableFooterView = UIView()
        
        view.addSubview(someImageView) //This add it the view controller without constraints
        someImageViewConstraints() //
        someImageView.isHidden = true
    }
    
    func someImageViewConstraints() {
        someImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        someImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        someImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        someImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 28).isActive = true
    }
   @objc func cityspinrtapped () {
    self.cityspinner.becomeFirstResponder()
        self.cityspinner.text?.removeAll()
          self.setlist(retailername: self.retailer, cityname: "", keycustomer: self.keycuststr)
    }
    
    func nodataViewProg(){
        let someImageView: UIImageView = {
           let theImageView = UIImageView()
           theImageView.image = UIImage(named: "box.png")
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
           return theImageView
        }()
        someImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        someImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        someImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        someImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 28).isActive = true
        
    }
   
    
    
    var loadingalert:UIAlertController?
    
    
    override func viewDidAppear(_ animated: Bool) {
        AppDelegate.customercode = ""
        AppDelegate.doccode = ""
        AppDelegate.hoscode = ""
        AppDelegate.popviewcontrolllercheck = false ;
        AppDelegate.chemistcheck = false ;
        AppDelegate.isChemist = false ;
        AppDelegate.showDocList = true
        AppDelegate.showHosList = true
        AppDelegate.isFromSalesPersonList = false
        AppDelegate.isFromCustomerCardList = false
        AppDelegate.isDocScreen = false
        AppDelegate.isHosScreen = false
        AppDelegate.isRetScreen = false
        AppDelegate.retcustomercode = ""
        AppDelegate.hoscustomercode = ""
        AppDelegate.doccustomercode = ""
        AppDelegate.source = ""
        AppDelegate.chemcustcode = ""
        AppDelegate.oldChemcustomercode = ""
        AppDelegate.oldhoscode = ""
        
        
        
        AppDelegate.isFromRetailerScreen = false
        AppDelegate.isFromDoctorScreen = false
        AppDelegate.isFromHospitalScreen = false
        AppDelegate.isFromMiStock = false
        AppDelegate.isPostedRetailer = 1
        AppDelegate.isPosted = 1
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            self.showSyncloader(title: "Syncing...")
            AppDelegate.issync = 1
            self.postDownload()
            if (titlebar == "Retailer" || titlebar == "Sub Dealer")  {
                AppDelegate.isFromRetailer = true
                self.downloadallNew()
            }else if (titlebar == "Doctor" || titlebar == "Hospital")  {
                AppDelegate.isFromRetailer = false
                self.downloadallNew()
            }
            
            if(AppDelegate.isFromRetailer){
                SwiftEventBus.onMainThread(self, name: "downloadedSyncRetailer") {
                    (Result) in
                    self.deleteretailerlistsearch()
                    self.getRetailerListDetail(query: "", customertype: self.custtype, keycustomer: self.lastspinner.text!, cityname: "")
                }
            }
            else{
                SwiftEventBus.onMainThread(self, name: "downloadedSync") {
                    (Result) in
                    self.deleteretailerlistsearch()
                    self.getRetailerListDetail(query: "", customertype: self.custtype, keycustomer: self.lastspinner.text!, cityname: "")
                }
            }
        }
        PendingEscalation.ispendingescalated = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    @objc func getcustomer(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.retailertable)
        if let indexPath =  retailertable.indexPathForRow(at: touchPoint)
        
        {
            let index = indexPath.row
            let cell = retailertable.cellForRow(at: indexPath) as! Retailerlistcell
            var miPer: String!
            miPer = cell.mi.text!
            miPer?.removeLast()
            let numberFormatter = NumberFormatter()
            let number = numberFormatter.number(from: miPer)
            let numberFloatValue = number!.floatValue
            AppDelegate.retailerper = numberFloatValue
            self.getcustcode(code: customercodearr[index])
        }
    }
    
    public func checklastactivityid(customercode: String?)-> Int{
        var stmt1: OpaquePointer? = nil
        let query = "select lastactivityid from USERCUSTOMEROTHINFO  where CUSTOMERCODE = '\(customercode!)'"
        var id = -1;
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return id
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = Int(String(cString: sqlite3_column_text(stmt1, 0)))!
        }
        return id
    }
    
    @IBAction func addbtn(_ sender: UIButton) {
        if titlebar == "Doctor" {
           AppDelegate.isFromDoctorScreen = true
            AppDelegate.showDocList = true
            let attachdoclist: Attachdoclist = self.storyboard?.instantiateViewController(withIdentifier: "addnewdoc") as! Attachdoclist
            attachdoclist.titletext = self.titlebar
            AppDelegate.customercode = self.getIDNew()
            self.navigationController?.pushViewController(attachdoclist, animated: true)
        }
            
        else if titlebar == "Retailer" {
            AppDelegate.isFromRetailerScreen = true
            AppDelegate.chemistcheck = false 
            let market: MarketIntelligence =  self.storyboard?.instantiateViewController(withIdentifier: "mivc") as! MarketIntelligence
            AppDelegate.customercode = "RE" + self.getID()
            market.titletext = self.titlebar
            Retailerlistvc.customername = ""
            market.siteid = AppDelegate.siteid
            market.source = self.titlebar
            
            self.navigationController?.pushViewController(market, animated: true)
        }
        else if titlebar == "Hospital"
        {
            AppDelegate.isFromHospitalScreen = true
            AppDelegate.showHosList = true
            AppDelegate.customercode = self.getIDNew()
            let attachdoclist: Attachdoclist = self.storyboard?.instantiateViewController(withIdentifier: "addnewdoc") as! Attachdoclist
            attachdoclist.titletext = self.titlebar
            self.navigationController?.pushViewController(attachdoclist, animated: true)
        }
    }
    
    func setlist(retailername: String,cityname: String ,keycustomer: String){
         self.customercodearr.removeAll()
        var querystr = ""
        var stmt1:OpaquePointer?

        querystr = "select * from retailerlistsearch where (customername like '%\(retailername)%' and cityname like '%\(cityname)%' and keycustomer like '%\(keycustomer)%')"
        if(AppDelegate.isDebug){
        print("retailersetlist==="+querystr)
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
         if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        
        self.retaileradapter.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let customername = String(cString: sqlite3_column_text(stmt1, 0))
            let lastvisit = String(cString: sqlite3_column_text(stmt1, 1))
            let cityname = String(cString: sqlite3_column_text(stmt1, 2))
            let sitename = String(cString: sqlite3_column_text(stmt1, 3))
            let currentmonth = String(cString: sqlite3_column_text(stmt1, 4))
            let complain = String(cString: sqlite3_column_text(stmt1, 5))
            let mi = String(cString: sqlite3_column_text(stmt1, 6))
            let customercode = String(cString: sqlite3_column_text(stmt1, 7))
            
            self.customercodearr.append(customercode)
            retaileradapter.append(Retailerlistadapter(customername: customername, lastvisit: lastvisit, cityname: cityname, sitename: sitename, currmonth: currentmonth, complain: complain, mi: mi, customercode: customercode))

        }
        
        DispatchQueue.main.async {
            self.retailertable.reloadData()
        }
        
        if retaileradapter.count == 0 {
            self.someImageView.isHidden = false
          //  self.nodataviewheight.constant=191
        }
        else {
            self.someImageView.isHidden = true
           // self.nodataviewheight.constant=0
        }
    }

    
    public func setcityspinner(){
        var stmt1:OpaquePointer?
        let query = "select A.cityid,B.CityName from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' order by CityName"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let cityname = String(cString: sqlite3_column_text(stmt1, 1))
            cityspinner.optionArray.append(cityname)
        }
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        if AppDelegate.usertype == "11"{
            let daily: DailyResponsibility = self.storyboard?.instantiateViewController(withIdentifier: "SPO") as! DailyResponsibility
            self.navigationController?.pushViewController(daily, animated: true)
        }
        else{
            let daily: DailyResponsibility = self.storyboard?.instantiateViewController(withIdentifier: "dailyres") as! DailyResponsibility
            self.navigationController?.pushViewController(daily, animated: true)
        }
    }
    
    public func getRetailerListDetail (query: String?,customertype: String?,keycustomer: String?,cityname: String?)
    {
        do {
        customerNamearr.removeAll()
        retaileradapter.removeAll()
        self.customercodearr.removeAll()
        if(AppDelegate.isDebug){
        print("CustomerCodeArrInitially==")
        print(self.customercodearr)
        }
        var stmt1:OpaquePointer?
     //   let date = self.getdate()
        signarr.removeAll()
        var keycust: String? = ""
        if (keycustomer?.contains("+"))! {
            keycust = "true"
        }
        else if (keycustomer?.contains("-"))!{
            keycust = "false"
        }
        var querystr: String!
        if (titlebar == "Doctor"){
            querystr = "select distinct 1 _id,ifnull(D.lastactivityid,'-'),A.customercode,ifnull(D.lastvisit,'-') as lastvisit,A.referencecode,A.customername,ifnull(B.CityName,''),case when C.sitename is null then '' else C.sitename end as sitename,ifnull(D.currentmonth,'0.0') as currentmonth,ifnull(D.complain,'0') as complain,ifnull(D.isescalated,'-'), case when (select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.customercode and A1.lastvisit )=0 then 'No Order' when(select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.customercode and A1.lastvisit) > 0 then 'Done' else 'Open' end as status,A.pricegroup,A.siteid,A.stateid ,case when A.isblocked='true' then 'Inactive' else  'Active' end as blockstatus,A.salepersonid,ifnull(D.isescalated,'-'),E.ispurchaseing,E.ispriscription, A.keycustomer from RetailerMaster A left outer join CityMaster B on A.city= B.CityID left join USERDISTRIBUTOR C on A.siteid = C.siteid left join USERCUSTOMEROTHINFO D on A.customercode = D.customercode left OUTER join DRMASTER E where  A.isblocked='false' and E.custrefcode = A.customercode and A.customertype='"
            
        }
        else
        {
            querystr = "select distinct 1 _id,ifnull(D.lastactivityid,'-'),A.customercode,ifnull(D.lastvisit,'-') as lastvisit,A.referencecode,A.customername,ifnull(B.CityName,''),case when C.sitename is null then '' else C.sitename end as sitename,ifnull(D.currentmonth,'0.0') as currentmonth,ifnull(D.complain,'0') as complain,ifnull(D.isescalated,'-'), case when (select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.customercode and A1.lastvisit )=0 then 'No Order' when(select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.customercode and A1.lastvisit ) > 0 then 'Done' else 'Open' end as status,A.pricegroup,A.siteid,A.stateid ,case when A.isblocked='true' then 'Inactive' else  'Active' end as blockstatus,A.salepersonid,ifnull(D.isescalated,'-'),A.keycustomer from RetailerMaster A left outer join CityMaster B on A.city= B.CityID left join USERDISTRIBUTOR C on A.siteid = C.siteid left join USERCUSTOMEROTHINFO D on A.customercode = D.customercode where  A.isblocked='false' and A.customertype='"
            
        }
        
        let str = customertype! + "'and (A.customername like '%" + query! + "%')"
        
        var str1 = "and (A.keycustomer like '%" + keycust! + "%')"
        
        if cityname != "" && cityname != nil {
            str1 = str1 + "and  B.CityName like '%" + cityname! + "%' "
        }
        let query = querystr+str+str1
        if(AppDelegate.isDebug){
        print("RetailerList=="+query)
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
            
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let customercode = String(cString: sqlite3_column_text(stmt1, 2))
            self.checkRetailersign(customercode: customercode)
            let lastvisitdate = String(cString: sqlite3_column_text(stmt1, 3))
            var lastvisit = lastvisitdate.replacingOccurrences(of: "T", with: " ")
            if  lastvisit == "1900-01-01 00:00:00"{
                lastvisit = "No Visit"
            }
            let customername = String(cString: sqlite3_column_text(stmt1, 5))
            customerNamearr.append(customername)
            let cityname = String(cString: sqlite3_column_text(stmt1, 6))
            let sitename = String(cString: sqlite3_column_text(stmt1, 7))
            let currentmonth = String(cString: sqlite3_column_text(stmt1, 8))
            let complain = String(cString: sqlite3_column_text(stmt1, 9))
            let refcode = String(cString: sqlite3_column_text(stmt1, 4))
            var purchaseing: String? = ""
            var prescribe: String? = ""
            var  keycustomerData: String? = ""
            var sign: String = String(cString: sqlite3_column_text(stmt1, 1))
            let isescalated = String(cString: sqlite3_column_text(stmt1, 17))
            if (titlebar == "Doctor"){
                 keycustomerData = String(cString: sqlite3_column_text(stmt1, 20))
            }
                
            else {
                 keycustomerData = String(cString: sqlite3_column_text(stmt1, 18))
            }
            
            if(AppDelegate.isDebug){
            print("keycustomer==" + keycustomerData!)
            }
            
            if (sign != "3" && isescalated != "true" && lastvisit.prefix(10) != self.getTodaydatetime().prefix(10))
            {
                sign = "0"
            }
            
            if (titlebar == "Doctor"){
                purchaseing = String(cString: sqlite3_column_text(stmt1, 18))
                prescribe = String(cString: sqlite3_column_text(stmt1, 19))
                self.prescribingarr.append(prescribe!)
                self.purchasingarr.append(purchaseing!)
            }
            signarr.append(sign)
            Retailerlistvc.salepersonid =  String(cString: sqlite3_column_text(stmt1, 16))
            var rper: Float = 0;
            if (titlebar == "Retailer" || titlebar == "Sub Dealer")  {
                rper = getretailerpecent(customercode: customercode)
                rper += getcustdoctor(query: "", customercode: customercode)
                rper += getcompetitor(customercode: customercode)
                rper += getmiimage(s: "0", customercode: customercode)
                rper += getmiimage(s: "1", customercode: customercode)
            }else if titlebar == "Doctor" {
                rper = getdoctorpecent(docid: refcode)
                rper += getcompetitor(customercode: customercode)
                rper += gethospitallist(docid: refcode)
            }else if titlebar == "Hospital" {
                rper = gethospitalpercent(hosid: refcode)
                rper += gethosdoctors(query: "",refcode: refcode)
                rper += gethoschemist(query: "",refcode: refcode)
                rper += getcompetitor(customercode: customercode)
            }
            self.customercodearr.append(customercode)
            retaileradapter.append(Retailerlistadapter(customername: customername, lastvisit: lastvisit, cityname: cityname, sitename: sitename, currmonth: currentmonth, complain: complain, mi: String(Int64(rper))+"%", customercode: customercode))
            
            self.insertretailerlistsearch(customername: customername, lastvisit: lastvisit, cityname: cityname, sitename: sitename, currmonth: currentmonth, complain: complain, mi: String(Int64(rper))+"%", customercode: customercode,keycustomer:keycustomerData)
            
        }
        if(AppDelegate.isDebug){
        print("CustomerCodeArrLastly==========================================================================================================")
        print(self.customercodearr)
        }
        
        DispatchQueue.main.async {
            self.retailertable.reloadData()
        }
        
            if retaileradapter.count == 0 {
                self.someImageView.isHidden = false
                //  self.nodataviewheight.constant=191
            }
            else {
                self.someImageView.isHidden = true
                // self.nodataviewheight.constant=0
            }

            
        self.hideSyncloader()
            self.view.isUserInteractionEnabled = true
            
        }
        catch {
            print("Error Occured while setting list")
        }
    }
    
    public func getcustcode(code: String?){
        var stmt:OpaquePointer?
        AppDelegate.customercode = code!
        let query: String!
        
        if titlebar == "Doctor" {
            query = "select customername,pricegroup,A.siteid,A.stateid,ifnull(isescalated,'') as isescalated,C.ispriscription,C.ispurchaseing from RetailerMaster A left outer join USERCUSTOMEROTHINFO B  on A.customercode = B.customercode left join DRMASTER C on C.custrefcode = A.customercode where A.customercode = '" + code! + "'"
        }
        else{
            query = "select customername,pricegroup,A.siteid,A.stateid,ifnull(isescalated,'') from RetailerMaster A left outer join USERCUSTOMEROTHINFO B  on A.customercode = B.customercode where A.customercode = '" + code! + "'"
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            
            let custname = String(cString: sqlite3_column_text(stmt, 0))
            Retailerlistvc.pricegroup = String(cString: sqlite3_column_text(stmt, 1))
            AppDelegate.siteid = String(cString: sqlite3_column_text(stmt, 2))
            Retailerlistvc.stateid = String(cString: sqlite3_column_text(stmt, 3))
            Retailerlistvc.isescalated = String(cString: sqlite3_column_text(stmt, 4))
          //  Retailerlistvc.customername = custname.prefix(14) + ""
            Retailerlistvc.customername = custname
            
            if titlebar == "Doctor"{
                priscription = String(cString: sqlite3_column_text(stmt, 5))
                purchasing = String(cString: sqlite3_column_text(stmt, 6))
            }
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
        
        vc.customername = Retailerlistvc.customername
        vc.pricegroup = Retailerlistvc.pricegroup
        CustomerCard.siteid = AppDelegate.siteid
        CustomerCard.stateid = Retailerlistvc.stateid
        vc.isescalated = Retailerlistvc.isescalated
        vc.titletxt = self.titlebar
        vc.customercode = AppDelegate.customercode
        vc.prescribe = self.priscription
        vc.purchasing = self.purchasing
        AppDelegate.oldcustomercodeFromRetailList = AppDelegate.customercode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}
