//
//  PendingSubdealervc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import Foundation
import Alamofire
import SwiftEventBus

class PendingSubdealervc: Executeapi, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var subdealertable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingsubdealeradapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PendingSubdealercell
        
        let list: PendingSubdealeradapter
        
        list = pendingsubdealeradapter[indexPath.row]
        
        cell.customername.text = list.customername
        cell.city.text = list.city
        cell.requestedby.text = list.requestedby
        
        return cell
    }
    
    var pendingsubdealeradapter = [PendingSubdealeradapter]()
    var customercodearr: [String]!
    var customercode: String?
    var recid: String?
    var customername: String?
    var distributorcode: String?
    var distributorname: String?
    var expsale:String?
    var expdiscount:String?
    var usercode:String?
    var submitdate:String?
    var type:String?
    var conV_REQUEST:String?
    var username:String?
    var linkedemployee:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Pending Subdealer")
        self.customercodearr = []
        self.checknet()
        self.deletePendingsubdealer()
        
        if AppDelegate.ntwrk > 0 {
          DispatchQueue.global(qos: .userInitiated).async {
          self.getPendingSubDealer()
        }
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getApproveCust))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.subdealertable.addGestureRecognizer(tapeno)
          }
        else{
             self.showtoast(controller: self, message: "Please check your Internet Connection", seconds: 1.5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         SwiftEventBus.onMainThread(self, name: "pending") { Result in
              self.setlist()
          }
        SwiftEventBus.onMainThread(self, name: "subdealerPost") { Result in
                     self.setlist()
                 }
        //subdealerPost
    }
 
    func setDetail(){
    let subDealerConvert: SubDealerConversionvc =  self.storyboard?.instantiateViewController(withIdentifier: "SubDealer")
       as! SubDealerConversionvc
        subDealerConvert.usercodesub =  self.usercode
        subDealerConvert.username = self.username
        subDealerConvert.submitdate = self.submitdate
        subDealerConvert.customercode = self.customercode
        subDealerConvert.customername = self.customername
        subDealerConvert.distributorcode = self.distributorcode
        subDealerConvert.distributorname = self.distributorname
        subDealerConvert.linkedemployee = self.linkedemployee
        subDealerConvert.expsale = self.expsale
        subDealerConvert.expdiscount = self.expdiscount
        subDealerConvert.recid = self.recid
        self.navigationController?.pushViewController(subDealerConvert, animated: true)
    }
    
    @objc func getApproveCust(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.subdealertable)
            if let indexPath = subdealertable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            self.setSubDealer(custcode: customercodearr[index])
        }
    }
    
    func setSubDealer(custcode:String?)
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            print("loader activated")

            let URL_SubDealerConversion = "GetUserPendingSubDealerConversion_V1?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&CUSTOMERCODE=" + custcode!
            
            DispatchQueue.global(qos: .userInitiated).async {
                Alamofire.request(constant.Base_url + URL_SubDealerConversion).validate().responseJSON {
                    response in
                    switch response.result {
                    case .success(let value): print("success=======>\(value)")
                    if  let json = response.result.value{
                        let listarray : NSArray = json as! NSArray
                        if listarray.count > 0 {
                            for i in 0..<listarray.count{
                                self.recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                                self.customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                self.customername = String (((listarray[i] as AnyObject).value(forKey:"customername") as? String)!)
                                self.distributorcode = String (((listarray[i] as AnyObject).value(forKey:"distributorcode") as? String)!)
                                self.distributorname = String (((listarray[i] as AnyObject).value(forKey:"distributorname") as? String)!)
                                self.expsale = String (((listarray[i] as AnyObject).value(forKey:"expsale") as? Double)!)
                                self.expdiscount = String (((listarray[i] as AnyObject).value(forKey:"expdiscount") as? Int)!)
                                self.usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as? String)!)
                                self.submitdate = String (((listarray[i] as AnyObject).value(forKey:"submitdate") as? String)!)
                                self.type = String (((listarray[i] as AnyObject).value(forKey:"type") as? String)!)
                                self.conV_REQUEST = String (((listarray[i] as AnyObject).value(forKey:"conV_REQUEST") as? String)!)
                                self.username = String (((listarray[i] as AnyObject).value(forKey:"username") as? String)!)
                                self.linkedemployee = String (((listarray[i] as AnyObject).value(forKey:"linkedemployee") as? String)!)
                                
                                self.setDetail()
//                                self.insertSubDealerConversion(recid: self.recid, customername: self.customername, username: self.username, conV_REQUEST: self.conV_REQUEST, type: self.type, distributorcode: self.distributorcode, usercode: self.usercode, customercode: self.customercode, distributorname: self.distributorname,expsale: self.expsale, submitdate: self.submitdate)
//
//                                  public func insertSubDealerConversion(recid: String?,customername: String?,username: String?,conV_REQUEST: String?,type: String?,distributorcode: String?,usercode: String?, customercode: String?,distributorname: String?,expsale: String?,submitdate: String?){
//                               SwiftEventBus.post("datad")
                                
                            }}
                        else {
                            self.showtoast(controller: self, message: "No Record Found", seconds: 2.0)
                        }
                    }
                        break
                        
                    case .failure(let error):
                        self.showtoast(controller: self, message: "Server Error...Please try again!", seconds: 1.5)
                        print("error=========>\(error)")
                        break
                        
                    }
                    DispatchQueue.main.async {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")

                        }}}
            }
        }
        else {
            self.showtoast(controller: self, message: "You are Offline", seconds: 2.0)
        }
    }
    
    func setlist()
    {
        pendingsubdealeradapter.removeAll()
        self.customercodearr.removeAll()
        
        var stmt1: OpaquePointer?
        
//        let query = "select 1 _id,A.recid, A.customername, A.customercode , A.username , A.conV_REQUEST, A.type,ifnull(C.CityName,'') as CityName from Pendingsubdealer A left join retailermaster B on A.customercode=B.customercode left join CityMaster C on B.city=C.CityID "
        
        
        let query = "select 1 _id,A.recid, A.customername, A.customercode , A.username , A.conV_REQUEST, A.type,ifnull(C.CityName,'') as CityName from Pendingsubdealer A left join retailermaster B on A.customercode=B.customercode left join CityMaster C on B.city=C.CityID left join InsertSubDealerRequest I ON I.customercode=A.customercode"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let customername = " " + String(cString: sqlite3_column_text(stmt1, 2))
            let city = "    " + String(cString: sqlite3_column_text(stmt1, 7))
            let requestedby = String(cString: sqlite3_column_text(stmt1, 4))
            let customercode = String(cString: sqlite3_column_text(stmt1, 3))
            
            self.customercodearr.append(customercode)
            self.pendingsubdealeradapter.append(PendingSubdealeradapter(customername: customername, city: city, requestedby: requestedby))
        }
        subdealertable.reloadData()
    }
    
    @IBAction func backbtn(_ sender: Any) {
        let teammanagement: TeamManegement = self.storyboard?.instantiateViewController(withIdentifier: "teammanagement") as! TeamManegement
        self.navigationController?.pushViewController(teammanagement, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
}
