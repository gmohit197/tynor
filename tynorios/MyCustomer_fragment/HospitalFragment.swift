//  HospitalFragment.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import Foundation


class HospitalFragment: Executeapi, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mycustomeradapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HospitalFragmentcell
        
        let list: MyCustomerAdapter
        
        list = mycustomeradapter[indexPath.row]
        
        cell.customername.text = list.customername
        cell.city.text = list.city
        cell.status.text = list.status
        
        return cell
    }
    var mycustomeradapter = [MyCustomerAdapter]()
    var usercodearr: [String]!
    var usercode: String? = ""
    
    @IBOutlet weak var hospital: UITextField!
    @IBOutlet weak var hospitaltable: UITableView!
    @IBOutlet weak var customerspinr: DropDownUtil!
    @IBOutlet weak var nodataview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "My Customers")
        usercodearr = []
        
        self.nodataview.isHidden = true
        hospital.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 18))
        let image = UIImage(named: "search1.png")
        imageView.image = image
        hospital.leftView = imageView
        
        self.hospitaltable.tableFooterView = UIView()
        let usertype:Int =  UserDefaults.standard.integer(forKey: "usertype")
        if usertype <= 13
        {
            hideview(view: customerspinr)
        }
        
        customerspinr.didSelect { (selected, index, id) in
            self.usercode = self.usercodearr[index]
            if self.usercode == ""
            {
                self.getRetailerListDetail(query: self.hospital.text, customertype: "CG0005", keycustomer: "", cityname: "")
            }
            else{
                self.getRetailerListDetail(query: self.hospital.text, customertype: "CG0005", keycustomer: "", cityname: "", uc: self.usercode!)
            }
        }
        
        
        getRetailerListDetail(query: "", customertype: "CG0005", keycustomer: "", cityname: "")
        setspinr()
        customerspinr.text = "ALL"
    }
    
    public func getRetailerListDetail (query: String?, customertype: String? , keycustomer: String?, cityname: String?,uc:String!) {
        
        mycustomeradapter.removeAll()
        var stmt1:OpaquePointer?
        let date = self.getdate()
        var keycust: String? = ""
        if (keycustomer?.contains("+"))!{
            keycust = "true"
        }
        else if (keycustomer?.contains("-"))!{
            keycust = "false"
        }
        
        let querystr = "select distinct 1 _id,A.customercode,D.lastvisit,A.referencecode,A.customername,B.CityName,C.sitename,D.currentmonth,D.complain ,case when (select count(*) from SoHeader A1 where A1.CUSTOMERCODE = A.customercode and A1.approved = '0')=0 then 'No Order' when(select count(*) from SoHeader A1 where A1.CUSTOMERCODE = A.customercode and A1.approved = '0') > 0 then 'Open' else 'Done' end as status,A.pricegroup,A.siteid,A.stateid ,case when lastactivityid='1' then substr(lastvisit,1,10) else  '' end  as lastorderdate from RetailerMaster A left outer join CityMaster B on A.city= B.CityID  left join USERDISTRIBUTOR C on A.siteid =C.siteid left join USERCUSTOMEROTHINFO D on A.customercode = D.customercode where  A.customertype='"
        
        let str = customertype! + "' and A.salepersonid='" + uc! + "' and (A.customername like '%" + query! + "%' or B.CityName like '%" + query! + "%')"
        
        var str1 = "and (A.keycustomer like '%" + keycust! + "%')"
        
        if cityname != "" && cityname != nil {
            str1 = str1 + "and  B.CityName like '%" + cityname! + "%'"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr +  str + str1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let customername = String(cString: sqlite3_column_text(stmt1, 4))
            let cityname = String(cString: sqlite3_column_text(stmt1, 5))
            let status = String(cString: sqlite3_column_text(stmt1, 13))
            
            self.mycustomeradapter.append(MyCustomerAdapter(customername: customername, city: cityname, status: status))
        }
        hospitaltable.reloadData()
        
        if mycustomeradapter.count == 0{
            self.nodataview.isHidden = false
        }else{
            self.nodataview.isHidden = true
        }
    }
    
    public func getRetailerListDetail (query: String?, customertype: String? , keycustomer: String?, cityname: String?) {
        
        mycustomeradapter.removeAll()
        var stmt1:OpaquePointer?
        let date = self.getdate()
        var keycust: String? = ""
        if (keycustomer?.contains("+"))! {
            keycust = "true"
        }
        else if (keycustomer?.contains("-"))!{
            keycust = "false"
        }
       
        let querystr = "select distinct 1 _id,A.customercode,D.lastvisit,A.referencecode,A.customername,B.CityName,C.sitename,D.currentmonth,D.complain,D.isescalated, case when (select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.customercode and A1.lastvisit LIKE '" + date + "%' )=0 then 'No Order' when(select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.customercode and A1.lastvisit LIKE '" + date + "%') > 0 then 'Done' else 'Open' end as status,A.pricegroup,A.siteid,A.stateid ,case when lastactivityid='1' then substr(strftime('%d-%m-%Y',substr(lastvisit,1,10)),1,6) || substr(strftime('%d-%m-%Y',substr(lastvisit,1,10)),9,10) else  '' end  as lastorderdate from RetailerMaster A left outer join CityMaster B on A.city= B.CityID  left join USERDISTRIBUTOR C on A.siteid =C.siteid left join USERCUSTOMEROTHINFO D on A.customercode = D.customercode where  A.isblocked='false' and  A.customertype='"
        
        let str = customertype! + "'and (A.customername like '%" + query! + "%' or B.CityName like '%" + query! + "%')"
        
        var str1 = "and (A.keycustomer like '%" + keycust! + "%')"
        
        if cityname != "" && cityname != nil {
            str1 = str1 + "and  B.CityName like '%" + cityname! + "%'"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr +  str + str1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let customername = String(cString: sqlite3_column_text(stmt1, 4))
            let cityname = String(cString: sqlite3_column_text(stmt1, 5))
            let status = String(cString: sqlite3_column_text(stmt1, 14))
            
            self.mycustomeradapter.append(MyCustomerAdapter(customername: customername, city: cityname, status: status))
        }
        hospitaltable.reloadData()
        
        if mycustomeradapter.count == 0{
            self.nodataview.isHidden = false
        }else{
            self.nodataview.isHidden = true
        }
    }
    
    func setspinr()
    {
        customerspinr.optionArray.removeAll()
        usercodearr.removeAll()
        
        customerspinr.optionArray.append("ALL")
        usercodearr.append("")
        
        var stmt1: OpaquePointer?
        let query = "select usercode,empname from USERHIERARCHY where usertype = '13' or usertype = '14'or usertype = '12'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW){
            
            let empname = String(cString: sqlite3_column_text(stmt1, 1))
            let usercode = String(cString: sqlite3_column_text(stmt1, 0))
            
            usercodearr.append(usercode)
            customerspinr.optionArray.append(empname)
        }
    }
    

    @IBAction func hospitalsearch(_ sender: Any) {
        if self.usercode == ""
        {
            getRetailerListDetail(query: self.hospital.text, customertype: "CG0005", keycustomer: "", cityname: "")
        }
        else{
            self.getRetailerListDetail(query: self.hospital.text, customertype: "CG0005", keycustomer: "", cityname: "", uc: self.usercode!)
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
}
