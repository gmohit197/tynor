//
//  Profiledetail.swift
//  tynorios
//
//  Created by Acxiom Consulting on 30/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import Alamofire

class Profiledetail: Executeapi, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var citytable: UITableView!
    @IBOutlet weak var profiletableview: UITableView!

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profiletableview{
            print("detail===========\(profileadapter.count)")
            return profileadapter.count
        }
        else {
            print("city===========\(cityadapter.count)")
            return cityadapter.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profiletableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Profiledetailcell
            let list: Profileadapter
            list = profileadapter[indexPath.row]
            cell.employee.text = list.employee
            cell.customertype.text = list.customerType
            cell.noofCustomer.text = "  " + list.noOfCustomer!
            print("cell===========\(cell.employee.text!)  \(cell.customertype.text!)   \(cell.noofCustomer.text!)")
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! linkcitycell
            let list: Profilecityadapter
            list = cityadapter[indexPath.row]
            cell.citylbl.text  = list.city
            print("cell===========\(cell.citylbl.text!)")
            return cell
        }
    }
    
    
    @IBOutlet weak var asmnamestack: UIStackView!
    @IBOutlet weak var asmmobilestack: UIStackView!
    @IBOutlet weak var rsmnamestack: UIStackView!
    @IBOutlet weak var rsmmobilestack: UIStackView!
    @IBOutlet weak var customerstack: UIStackView!
    @IBOutlet weak var hoscount: UIStackView!
    @IBOutlet weak var doccount: UIStackView!
    var profileadapter = [Profileadapter]()
    var cityadapter = [Profilecityadapter]()
    @IBOutlet weak var userid: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var username1: UILabel!
    @IBOutlet weak var employeecode: UILabel!
    @IBOutlet weak var mobileno: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var dealercount: UILabel!
    @IBOutlet weak var retailercount: UILabel!
    @IBOutlet weak var retailertynorpositive: UILabel!
    @IBOutlet weak var retailertynornegative: UILabel!
    @IBOutlet weak var subdealer: UILabel!
    @IBOutlet weak var asmname: UILabel!
    @IBOutlet weak var rsmname: UILabel!
    @IBOutlet weak var rsmmobile: UILabel!
    @IBOutlet weak var zsmmobile: UILabel!
    @IBOutlet weak var salarymonth: UILabel!
    @IBOutlet weak var tmname: UILabel!
    @IBOutlet weak var tmmobileno: UILabel!
    @IBOutlet weak var headquarter: UILabel!
    @IBOutlet weak var outstation: UILabel!
    @IBOutlet weak var exheadquarter: UILabel!
    @IBOutlet weak var designation: UILabel!
    @IBOutlet weak var asmmobile: UILabel!
    @IBOutlet weak var zsmname: UILabel!
    @IBOutlet weak var nsmname: UILabel!
    @IBOutlet weak var nsmmobile: UILabel!
    @IBOutlet weak var doctorcount: UILabel!
    @IBOutlet weak var hospitalcount: UILabel!
    @IBOutlet weak var monthlyta: UILabel!
    @IBOutlet weak var sector: UILabel!
    @IBOutlet weak var sectorlbl: UILabel!
    @IBOutlet weak var jobDescImage: UIImageView!
    @IBOutlet weak var profilelabel: UIStackView!
    @IBOutlet weak var companylabel: UIStackView!
    @IBOutlet weak var expenselabel: UIStackView!
    @IBOutlet weak var customerlabel: UIStackView!
    @IBOutlet weak var customerarrow: UIImageView!
    @IBOutlet weak var expensearrow: UIImageView!
    @IBOutlet weak var profilearrow: UIImageView!
    @IBOutlet weak var companyarrow: UIImageView!
    @IBOutlet weak var customerview: UIView!
    @IBOutlet weak var expenseview: UIView!
    @IBOutlet weak var profileview: UIView!
    @IBOutlet weak var companyview: UIView!

    var profileviewvisible=true
    var companyviewvisible=false
    var customerviewvisible=false
    var expenseviewvisible=false
    var jobDesc: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        companyview.isHidden = true
        customerview.isHidden = true
        expenseview.isHidden=true
        citytable.dataSource=self
        citytable.delegate=self
        profiletableview.dataSource=self
        profiletableview.delegate=self
        self.setnav(controller: self, title: "My Profile")
        
        if UserDefaults.standard.string(forKey: "usertype") == "11" {
            self.hideview(view: doccount)
            self.hideview(view: hoscount)
            self.hideview(view: customerstack)
        }
        
        jobDescImage.isUserInteractionEnabled = true
        
        let tapjobdescimg = UITapGestureRecognizer(target: self, action: #selector(pushPdf))
        tapjobdescimg.numberOfTapsRequired=1
        jobDescImage.addGestureRecognizer(tapjobdescimg)
        
        let tapProfile = UITapGestureRecognizer(target: self, action:#selector(toggleprofile(_:)))
        self.profilelabel.addGestureRecognizer(tapProfile)

        let tapCompany = UITapGestureRecognizer(target: self, action:#selector(togglecompany(_:)))
        self.companylabel.addGestureRecognizer(tapCompany)

        let tapCustomer = UITapGestureRecognizer(target: self, action:#selector(togglecustomer(_:)))
        self.customerlabel.addGestureRecognizer(tapCustomer)

        let tapExpense = UITapGestureRecognizer(target: self, action:#selector(toggleexpense(_:)))
        self.expenselabel.addGestureRecognizer(tapExpense)
        
        setlist()
        setprofiledetail()
        setcitytable()
        setdealercount()
    }

    @objc func toggleprofile (_ sender: UITapGestureRecognizer) {
        print("clicked")
        if(profileviewvisible){
            profileviewvisible=false
            profileview.isHidden=true

//            UIView.animate(withDuration: 0.1, animations: {
//                self.profileview.alpha = 0
//            }, completion: {
//                finished in
//                self.profileview.isHidden = true
//            })
             print("hide")
             profilearrow.image=UIImage(named: "arrow")
        }
        
        else{
            profileviewvisible=true
            profileview.isHidden=false
            
//            UIView.animate(withDuration: 0.2, animations: {
//                self.profileview.alpha = 1
//            }, completion: {
//                finished in
//                self.profileview.isHidden = false
//            })
            
            print("show")
            profilearrow.image=UIImage(named: "arrowup")
        }
    }
    
    @objc func togglecompany (_ sender: UITapGestureRecognizer) {
        if(companyviewvisible){
            companyviewvisible=false
            companyview.isHidden=true
            companyarrow.image=UIImage(named: "arrow")
        }
        else{
            companyviewvisible=true
            companyview.isHidden=false
            companyarrow.image=UIImage(named: "arrowup")
        }
    }
    
    @objc func togglecustomer (_ sender: UITapGestureRecognizer) {
        if(customerviewvisible){
            customerviewvisible=false
            customerview.isHidden=true
            customerarrow.image=UIImage(named: "arrow")
        }
        else{
            customerviewvisible=true
            customerview.isHidden=false
            customerarrow.image=UIImage(named: "arrowup")
        }
        
    }
    @objc func toggleexpense (_ sender: UITapGestureRecognizer) {
        if(expenseviewvisible){
            expenseviewvisible=false
            expenseview.isHidden=true
           expensearrow.image=UIImage(named: "arrow")
        }
        else{
            expenseviewvisible=true
            expenseview.isHidden=false
           expensearrow.image=UIImage(named: "arrowup")
        }
    }
    
    func setcitytable()
    {
        var stmt1: OpaquePointer?
        cityadapter.removeAll()
//        let query = "select A.cityid,B.CityName from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' order by CityName"
        
        let query = "select A.cityid,locationtype || ' - ' || b.cityname as CityName from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' order by CityName"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let city = String(cString: sqlite3_column_text(stmt1, 1))
            print("city data===========\(city)")
            cityadapter.append(Profilecityadapter(city: city))
        }
        print("city===========\(cityadapter.count)")
        citytable.reloadData()
    }
    func setprofiledetail()
    {
        var stmt1: OpaquePointer?
        
        let query = "select  usercode,employeecode,employeename,mobileno,emailid,salarymonth,asmname,rsmname,rsmmobile,zsmmobile,tmname,tmmobile,headquater,exheadquater,outstation,misc,sector,pocket,alloweddisc,asmmobile,zsmname,nsmname,nsmmobile,jobdesc,teritory,monthlyta from ProfileDetail"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            self.userid.text = String(cString: sqlite3_column_text(stmt1, 0))
            self.username.text = String(cString: sqlite3_column_text(stmt1, 2))
            self.username1.text = String(cString: sqlite3_column_text(stmt1, 2))
            self.employeecode.text = String(cString: sqlite3_column_text(stmt1, 1))
            self.mobileno.text = "+91 " + String(cString: sqlite3_column_text(stmt1, 3))
            self.salarymonth.text = String(sqlite3_column_int64(stmt1, 5))
            self.email.text = String(cString: sqlite3_column_text(stmt1, 4))
            self.asmname.text = String(cString: sqlite3_column_text(stmt1, 6))
            self.rsmname.text = String(cString: sqlite3_column_text(stmt1, 7))
            self.rsmmobile.text = String(cString: sqlite3_column_text(stmt1, 8))
            self.zsmmobile.text = String(cString: sqlite3_column_text(stmt1, 9))
            let taname = String(cString: sqlite3_column_text(stmt1, 10))
            if taname != "<null>"{
                 self.tmname.text = taname
            }
            else{
                self.tmname.text = ""
            }
            let tmmobile = String(cString: sqlite3_column_text(stmt1, 11))
            if tmmobile != "<null>"{
                self.tmmobileno.text = tmmobile
            }
            else{
                self.tmmobileno.text = ""
            }
            self.headquarter.text = String(sqlite3_column_int64(stmt1, 12))
            self.exheadquarter.text = String(sqlite3_column_int64(stmt1, 13))
            self.outstation.text = String(sqlite3_column_int64(stmt1, 14))
            self.asmmobile.text = String(cString: sqlite3_column_text(stmt1, 19))
            self.zsmname.text = String(cString: sqlite3_column_text(stmt1, 20))
            self.nsmname.text = String(cString: sqlite3_column_text(stmt1, 21))
            self.nsmmobile.text = String(cString: sqlite3_column_text(stmt1, 22))
            self.monthlyta.text = String(sqlite3_column_int64(stmt1, 25))
            self.jobDesc = String(cString: sqlite3_column_text(stmt1, 23))
            
            switch UserDefaults.standard.string(forKey: "usertype")! {
                
            case "11":
                self.sectorlbl.text = "Pocket"
                self.sector.text = String(cString: sqlite3_column_text(stmt1, 17))
                self.designation.text =  "Sales Promotional Officer"
                break
                
            case "12":
                self.sectorlbl.text = "Pocket"
                self.sector.text = String(cString: sqlite3_column_text(stmt1, 17))
                self.designation.text =  "Bussiness Development Officer"
                
                break
                
            case "13":
                self.sectorlbl.text = "Sector"
                self.hideview(view: self.asmnamestack)
                self.hideview(view: self.asmmobilestack)
                self.sector.text = String(cString: sqlite3_column_text(stmt1, 16))
                self.designation.text =  "Area Sales Manager"
                
                break
            case "14":
                self.hideview(view: self.asmnamestack)
                self.hideview(view: self.asmmobilestack)
                self.sectorlbl.text = "Sector"
                self.sector.text = String(cString: sqlite3_column_text(stmt1, 16))
                self.designation.text =  "Bussiness Development Manager"
                
                break
                
            case "15":
                self.hideview(view: self.asmnamestack)
                self.hideview(view: self.asmmobilestack)
                self.hideview(view: self.rsmnamestack)
                self.hideview(view: self.rsmmobilestack)
                self.sectorlbl.text = "Territory"
                self.sector.text = String(cString: sqlite3_column_text(stmt1, 24))
                self.designation.text =  "Regional Sales Manager"
                
                break
                
            default:
                break
            }
            
        }
        let tpositve = "select count(customercode) from RetailerMaster where keycustomer='true' and customertype='CG0001' and isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, tpositve, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            self.retailertynorpositive.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        let tnegative = "select count(customercode) from RetailerMaster where keycustomer='false' and customertype='CG0001' and isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, tnegative, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            self.retailertynornegative.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        let subdealercount = "select count(customercode) from RetailerMaster where customertype='CG0004' and isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, subdealercount, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            self.subdealer.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        let hospitalcount = "select count(customercode) from RetailerMaster where customertype='CG0005' and isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, hospitalcount, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            self.hospitalcount.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
        let doctorcount = "select count(customercode) from RetailerMaster where customertype='CG0003' and isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, doctorcount, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            self.doctorcount.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
        let retailercount = "select count(customercode) from RetailerMaster where customertype='CG0001' and isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, retailercount, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            self.retailercount.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        let superdealercount = "select count(sitename) from USERDISTRIBUTOR where pricegroup='DEALER'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, superdealercount, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            self.dealercount.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    func setlist()
    {
        var stmt1:OpaquePointer?
        
        let query = "select 1 _id ,empname,case when customertype='CG0001' then 'Retailers' when customertype='CG0002' then 'Super Dealer' when customertype='CG0003' then 'Doctors' when customertype='CG0004' then 'Sub-Dealers' when customertype='CG0005' then 'Hospitals' end as type,count(*) totalcustomers from retailermaster A  inner join USERHIERARCHY B on A.salepersonid =B.usercode where A.isblocked='false' group by salepersonid,customertype"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let employee = String(cString: sqlite3_column_text(stmt1, 1))
            let customertype = "         " + String(cString: sqlite3_column_text(stmt1, 2))
            let noofCustomer = String(cString: sqlite3_column_text(stmt1, 3))
            print(employee+customertype+noofCustomer)
            self.profileadapter.append(Profileadapter(employee: employee, customerType: customertype, noOfCustomer: noofCustomer))
        }
        
    }
    
    func setdealercount()
    {
        var stmt1:OpaquePointer?
        
      //  let query = "select count(sitename) from USERDISTRIBUTOR where pricegroup = 'DEALER'
        let query = "select count(sitename) from USERDISTRIBUTOR where distributortype <> 'DT000001' "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            self.dealercount.text = String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    @objc func pushPdf()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0{
            if jobDesc == ""{
                self.showtoast(controller: self, message: "Job Description Not Avaliable", seconds: 1.5)
            }
            else{
                let profilePdf: ProfilePdf = self.storyboard?.instantiateViewController(withIdentifier: "profilePdf") as! ProfilePdf
                
                profilePdf.jobdesc = self.jobDesc
                
                self.navigationController?.pushViewController(profilePdf, animated: true)
            }
        }
        else{
            self.showtoast(controller: self, message: "You Are Offline", seconds: 1.5)
        }
    }
    
    @IBAction func jobDescBtn(_ sender: Any) {
        self.checknet()
        if AppDelegate.ntwrk > 0{
            if jobDesc == ""{
                self.showtoast(controller: self, message: "Job Description Not Avaliable", seconds: 1.5)
            }
            else{
                let profilePdf: ProfilePdf = self.storyboard?.instantiateViewController(withIdentifier: "profilePdf") as! ProfilePdf
                
                profilePdf.jobdesc = self.jobDesc
                self.navigationController?.pushViewController(profilePdf, animated: true)
            }
        }
        else{
            self.showtoast(controller: self, message: "You Are Offline", seconds: 1.5)
        }
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
}
