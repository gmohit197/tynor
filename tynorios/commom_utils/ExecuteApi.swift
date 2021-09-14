//
//  ExecuteApi.swift
//  tynorios
//
//  Created by Acxiom Consulting on 06/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import Alamofire
import SQLite3
import UIKit
import SwiftEventBus

public class Executeapi: Postapi {

    public func executeapifunc(view: UIView, alert: Bool){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            self.alertbool = alert
            view.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
            print("loader activated")
            let date = self.getdate()
            
            UserDefaults.standard.set(date, forKey: "executeapi")
            self.totalapi = 43
            
            self.setprogress(title: "Downloading...")
            print("task in sync ==============> STARTED")
           
            dashboardprimary()
            print("task in sync ==============> STOPED")
            // stop animating now that background task is finished
            activityIndicator.stopAnimating()
            
            view.isUserInteractionEnabled = true
            print("loader deactivated")
           
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }        
    }
    
    func downloadall(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
        self.retailermaster1()
        }
    }
    func downloadallNew(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                self.retailermaster2()
            }
        }
    }
    
    
    func downloadallRetailerList(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
        self.retailermaster3()
        }
    }
    
    
    func downloadallDrHosList(){
           self.checknet()
           if AppDelegate.ntwrk > 0 {
           self.drmaster2()
           }
       }
    
    func dashboardprimary() {
        Alamofire.request(constant.Base_url + constant.URL_dashboardprimaryConst()).validate().responseJSON {
            response in
            print("DashboardPrimary=="+constant.Base_url + constant.URL_dashboardprimaryConst())
            switch response.result {
            case .success(let value): Loginvc.flagcount = 0;
            if constant.isDebug {
                print("success=======\(value)")
            }
            if  let json = response.result.value{
                self.deleteuserprimary()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let tmonth = String (((listarray[i] as AnyObject).value(forKey:"tmonth") as! NSObject).description)
                        let targetmonth = String (((listarray[i] as AnyObject).value(forKey:"targetmonth") as! NSObject).description)
                        let ptarget = String (((listarray[i] as AnyObject).value(forKey:"ptarget") as? Double)!)
                        let pachivement = String (((listarray[i] as AnyObject).value(forKey:"pachivement") as? Double)!)
                        
                        self.insertprimarydashboard(usercode: usercode as NSString, tmonth: tmonth as NSString, targetmonth: targetmonth as NSString, ptarget: ptarget as NSString, pachivement: pachivement as NSString)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "UserPrimaryDashboard", status: "success", datetime: self.getTodaydatetime())
                    
                }
                self.updateprogress()
                self.dashdetailscard()
            }
            
                break
                
            case .failure(let error):
                if constant.isDebug {
                    print("error===========\(error)")
                }
                self.updatelog(tablename: "UserPrimaryDashboard", status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.dashdetailscard()
                self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func dashdetailscard(){
        
        Alamofire.request(constant.Base_url + constant.URL_dashdetailscardConst()).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):
                if constant.isDebug {
                    print("success=======\(value)")
                }
                if  let json = response.result.value{
                    self.deletedashdetailcard()
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        for i in 0..<listarray.count{
                            let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                            let ptarget = String (((listarray[i] as AnyObject).value(forKey:"ptarget") as? Int)!)
                            let starget = String (((listarray[i] as AnyObject).value(forKey:"starget") as? Int)!)
                            let psalerate = String (((listarray[i] as AnyObject).value(forKey:"psalerate") as? Int)!)
                            let ssalerate = String (((listarray[i] as AnyObject).value(forKey:"ssalerate") as? Int)!)
                            let preqrate = String (((listarray[i] as AnyObject).value(forKey:"preqrate") as? Int)!)
                            let sreqrate = String (((listarray[i] as AnyObject).value(forKey:"sreqrate") as? Int)!)
                            
                            self.insertdashdetailscard(usercode: usercode as NSString, ptarget: ptarget as NSString, starget: starget as NSString, psalerate: psalerate as NSString, ssalerate: ssalerate as NSString, preqrate: preqrate as NSString, sreqrate: sreqrate as NSString)
                        }
                        Loginvc.flagcount = Loginvc.flagcount + 1
                        
                        self.updatelog(tablename: "USERTARGETSALERATE", status: "success", datetime: self.getTodaydatetime())
                        
                    }
                    self.updateprogress()
                    self.getusertype()
                }
                break
                
            case .failure(let error):
                if constant.isDebug {
                    print("error===========\(error)")
                }
                self.updatelog(tablename: "USERTARGETSALERATE", status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.getusertype()
                self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func getusertype(){
        Alamofire.request(constant.Base_url + constant.URL_getusertypeConst()).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):
                if constant.isDebug {
                    print("success=======\(value)")
                }
                if  let json = response.result.value{
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        self.deleteusertype()
                        for i in 0..<listarray.count{
                            let sno = String (((listarray[i] as AnyObject).value(forKey:"s.no") as? Int32)!)
                            let custtypeid = String (((listarray[i] as AnyObject).value(forKey:"custtypeid") as! NSObject).description)
                            let custtypedesc = String (((listarray[i] as AnyObject).value(forKey:"custtypedesc") as! NSObject).description)
                            //                        "s.no": 1,
                            //                        "custtypeid": "CG0001",
                            //                        "custtypedesc": "RETAILER"
                            self.insertusertype(sno: sno as NSString, custtypeid: custtypeid as NSString, custtypedesc: custtypedesc as NSString)
                        }
                        Loginvc.flagcount = Loginvc.flagcount + 1
                        
                        self.updatelog(tablename: "usertype", status: "success", datetime: self.getTodaydatetime())
                    }
                    self.updateprogress()
                    self.getreasonmaster()
                }
                break
                
            case .failure(let error):
                if constant.isDebug {
                    print("error===========\(error)")
                }
                self.updatelog(tablename: "usertype", status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.getreasonmaster()
                self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func getreasonmaster(){
        let url = getEscalationReasonData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):
                if constant.isDebug {
                    print("success=======\(value)")
                }
                if  let json = response.result.value{
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
//                        self.deleteEscalationReason()
                        for i in 0..<listarray.count{
                            let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                            let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as! NSObject).description)
                            let reasondescription = String (((listarray[i] as AnyObject).value(forKey:"reasondescription") as! NSObject).description).replacingOccurrences(of: "n'", with: "")
                            let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                            let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                            //let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Bool)!)
                            let isblock = String (((listarray[i] as AnyObject).value(forKey:"isblock") as! NSObject).description)
                         
                            self.updateEscalationReasonData(reasoncode: reasoncode, reasondescription: reasondescription, createdtransationid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, isblock: isblock, recid: recid)
                        }
                        
                        Loginvc.flagcount = Loginvc.flagcount + 1
                        
                        self.updatelog(tablename: "EscalationReason", status: "success", datetime: self.getTodaydatetime())
                        
                    }
                    self.updateprogress()
                    self.GetUserdeistributerLink()
                }
                
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "EscalationReason", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.GetUserdeistributerLink()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    
    func GetUserdeistributerLink() {
        Alamofire.request(constant.Base_url + constant.URL_GetUserdeistributerLinkConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                if constant.isDebug {
                    print("success=======\(value)")
                }
                if  let json = response.result.value{
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        self.deleteUSERDISTRIBUTORITEMLINK()
                        for i in 0..<listarray.count{
                            let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                            let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                            let itemgrpid = String (((listarray[i] as AnyObject).value(forKey:"itemgrpid") as! NSObject).description)
                            let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                            let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                            
                            self.insertUSERDISTRIBUTORITEMLINK(dataareaid: dataareaid, siteid: siteid, itemgrpid: itemgrpid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                        }
                        Loginvc.flagcount = Loginvc.flagcount + 1
                        
                        self.updatelog(tablename: "USERDISTRIBUTORITEMLINK", status: "success", datetime: self.getTodaydatetime())
                    }
                    self.updateprogress()
                    self.retailermaster()
                }
                
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "USERDISTRIBUTORITEMLINK", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.retailermaster()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }

    public func updateretailermaster (customercode: String,customername: String ,customertype: String , contactperson: String    ,mobilecustcode: String , mobileno: String,  alternateno: String  ,  emailid: String ,address: String,pincode: String,city: String,stateid: String,gstno: String ,gstregistrationdate: String , siteid: String    ,salepersonid: String , keycustomer: String,  isorthopositive: String  ,  sizeofretailer: String ,category: String,isblocked: String,pricegroup: String,dataareaid: String,latitude: String ,longitude: String , orthopedicsale: String    ,avgsale: String , prefferedbrand: String ,secprefferedbrand: String ,secprefferedsale: String ,prefferedsale: String ,prefferedreasonid : String,secprefferedreasonid : String,createdtransactionid: String ,modifiedtransactionid: String ,post: String ,referencecode : String,lastvisited : String,storeimage : String,stockimage: String ,prefferedothbrand : String,secprefferedothbrand: String){
        
        
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from RetailerMaster where customercode = '\(customercode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        
        let query  = "update RetailerMaster set customertype = '\(customertype)',contactperson = '\(contactperson)',mobilecustcode = '\(mobilecustcode)', mobileno = '\(mobileno)' ,alternateno = '\(alternateno)',emailid = '\(emailid)',address = '\(address)',pincode = '\(pincode)',city = '\(city)',stateid = '\(stateid)',gstno = '\(gstno)',gstregistrationdate = '\(gstregistrationdate)' ,siteid = '\(siteid)' ,salepersonid = '\(salepersonid)',keycustomer = '\(keycustomer)',isorthopositive = '\(isorthopositive)',sizeofretailer = '\(sizeofretailer)',category = '\(category)',isblocked = '\(isblocked)' ,pricegroup = '\(pricegroup)',dataareaid = '\(dataareaid)',latitude = '\(latitude)',longitude = '\(longitude)',orthopedicsale = '\(orthopedicsale)',avgsale = '\(avgsale)',prefferedbrand = '\(prefferedbrand)',secprefferedbrand = '\(secprefferedbrand)',secprefferedsale = '\(secprefferedsale)',prefferedsale = '\(prefferedsale)',prefferedreasonid = '\(prefferedreasonid)',secprefferedreasonid = '\(secprefferedreasonid)',createdtransactionid = '\(createdtransactionid)',modifiedtransactionid = '\(modifiedtransactionid)',post = '\(post)',referencecode = '\(referencecode)',lastvisited = '\(lastvisited)',storeimage = '\(storeimage)',stockimage = '\(stockimage)',prefferedothbrand = '\(prefferedothbrand)',secprefferedothbrand = '\(secprefferedothbrand)' where customercode = '\(customercode)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table retailer master")
            
            return
            }}
        else{
            if(AppDelegate.isDebug){
            print("data being inserted in retailermaster")
            }
            self.insertretailermaster(customercode: customercode , customername: customername , customertype: customertype , contactperson: contactperson , mobilecustcode: mobilecustcode , mobileno: mobileno , alternateno: alternateno , emailid: emailid , address: address , pincode: pincode , city: city , stateid: stateid , gstno: gstno , gstregistrationdate: gstregistrationdate , siteid: siteid , salepersonid: salepersonid , keycustomer: keycustomer , isorthopositive: isorthopositive , sizeofretailer: sizeofretailer , category: category , isblocked: isblocked , pricegroup: pricegroup , dataareaid: dataareaid , latitude: latitude , longitude: longitude , orthopedicsale: orthopedicsale , avgsale: avgsale , prefferedbrand: prefferedbrand , secprefferedbrand: secprefferedbrand , secprefferedsale: secprefferedsale , prefferedsale: prefferedsale , prefferedreasonid: prefferedreasonid , secprefferedreasonid: secprefferedreasonid , createdtransactionid: createdtransactionid , modifiedtransactionid: modifiedtransactionid , post: "2", referencecode: referencecode , lastvisited: "", storeimage: storeimage , stockimage: stockimage , prefferedothbrand: prefferedothbrand , secprefferedothbrand: secprefferedothbrand )
        }
    }
    
    public func updateretailermaster1 (customercode: String,customername: String ,customertype: String , contactperson: String    ,mobilecustcode: String , mobileno: String,  alternateno: String  ,  emailid: String ,address: String,pincode: String,city: String,stateid: String,gstno: String ,gstregistrationdate: String , siteid: String    ,salepersonid: String , keycustomer: String,  isorthopositive: String  ,  sizeofretailer: String ,category: String,isblocked: String,pricegroup: String,dataareaid: String,latitude: String ,longitude: String , orthopedicsale: String    ,avgsale: String , prefferedbrand: String ,secprefferedbrand: String ,secprefferedsale: String ,prefferedsale: String ,prefferedreasonid : String,secprefferedreasonid : String,createdtransactionid: String ,modifiedtransactionid: String ,post: String ,referencecode : String,lastvisited : String,storeimage : String,stockimage: String ,prefferedothbrand : String,secprefferedothbrand: String){
        
        
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from RetailerMaster where customercode = '\(customercode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        let query  = "update RetailerMaster set customertype = '\(customertype)',contactperson = '\(contactperson)',mobilecustcode = '\(mobilecustcode)', mobileno = '\(mobileno)' ,alternateno = '\(alternateno)',emailid = '\(emailid)',address = '\(address)',pincode = '\(pincode)',city = '\(city)',stateid = '\(stateid)',gstno = '\(gstno)',gstregistrationdate = '\(gstregistrationdate)' ,siteid = '\(siteid)' ,salepersonid = '\(salepersonid)',keycustomer = '\(keycustomer)',isorthopositive = '\(isorthopositive)',sizeofretailer = '\(sizeofretailer)',category = '\(category)',isblocked = '\(isblocked)' ,pricegroup = '\(pricegroup)',dataareaid = '\(dataareaid)',latitude = '\(latitude)',longitude = '\(longitude)',orthopedicsale = '\(orthopedicsale)',avgsale = '\(avgsale)',prefferedbrand = '\(prefferedbrand)',secprefferedbrand = '\(secprefferedbrand)',secprefferedsale = '\(secprefferedsale)',prefferedsale = '\(prefferedsale)',prefferedreasonid = '\(prefferedreasonid)',secprefferedreasonid = '\(secprefferedreasonid)',createdtransactionid = '\(createdtransactionid)',modifiedtransactionid = '\(modifiedtransactionid)',post = '\(post)',lastvisited = '\(lastvisited)',storeimage = '\(storeimage)',stockimage = '\(stockimage)',prefferedothbrand = '\(prefferedothbrand)',secprefferedothbrand = '\(secprefferedothbrand)' where customercode = '\(customercode)'"
        
            
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table retailer master")
            return
            }}
        else{
            
            if(AppDelegate.isDebug){
                print("data being inserted in retailermaster")
            }

            self.insertretailermaster(customercode: customercode , customername: customername , customertype: customertype , contactperson: contactperson , mobilecustcode: mobilecustcode , mobileno: mobileno , alternateno: alternateno , emailid: emailid , address: address , pincode: pincode , city: city , stateid: stateid , gstno: gstno , gstregistrationdate: gstregistrationdate , siteid: siteid , salepersonid: salepersonid , keycustomer: keycustomer , isorthopositive: isorthopositive , sizeofretailer: sizeofretailer , category: category , isblocked: isblocked , pricegroup: pricegroup , dataareaid: dataareaid , latitude: latitude , longitude: longitude , orthopedicsale: orthopedicsale , avgsale: avgsale , prefferedbrand: prefferedbrand , secprefferedbrand: secprefferedbrand , secprefferedsale: secprefferedsale , prefferedsale: prefferedsale , prefferedreasonid: prefferedreasonid , secprefferedreasonid: secprefferedreasonid , createdtransactionid: createdtransactionid , modifiedtransactionid: modifiedtransactionid , post: "2", referencecode: referencecode , lastvisited: "", storeimage: storeimage , stockimage: stockimage , prefferedothbrand: prefferedothbrand , secprefferedothbrand: secprefferedothbrand )
        }
    }
    
    
    func retailermaster(){
        let url = getretailermasterdata()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    //self.deleteretailermaster()
                    for i in 0..<listarray.count{
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let customername = String (((listarray[i] as AnyObject).value(forKey:"customername") as! NSObject).description)
                        let customertype = String (((listarray[i] as AnyObject).value(forKey:"customertype") as! NSObject).description)
                        let contactperson = String (((listarray[i] as AnyObject).value(forKey:"contactperson") as! NSObject).description)
                        let mobilecustcode = String (((listarray[i] as AnyObject).value(forKey:"mobilecustcode") as! NSObject).description)
                        let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let alternateno = String (((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        var gstno = String (((listarray[i] as AnyObject).value(forKey:"gstno")  as! NSObject).description)
                        if gstno == "<null>"{
                            gstno = ""
                        }
                        let gstregistrationdate = String (((listarray[i] as AnyObject).value(forKey:"gstregistrationdate") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let salepersonid = String (((listarray[i] as AnyObject).value(forKey:"salepersonid") as! NSObject).description)
                        let keycustomer = String (((listarray[i] as AnyObject).value(forKey:"keycustomer") as? Bool)!)
                        let isorthopositive = String (((listarray[i] as AnyObject).value(forKey:"isorthopositive") as? Bool)!)
                        let sizeofretailer = String (((listarray[i] as AnyObject).value(forKey:"sizeofretailer") as! NSObject).description)
                        let category = String (((listarray[i] as AnyObject).value(forKey:"category") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let latitude = String (((listarray[i] as AnyObject).value(forKey:"latitude") as! NSObject).description)
                        let longitude = String (((listarray[i] as AnyObject).value(forKey:"longitude") as! NSObject).description)
                        let orthopedicsale = String (((listarray[i] as AnyObject).value(forKey:"orthopedicsale") as? Double)!)
                        let avgsale = String (((listarray[i] as AnyObject).value(forKey:"avgsale") as? Double)!)
                        let prefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedbrand") as! NSObject).description)
                        let secprefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedbrand") as! NSObject).description)
                        let secprefferedsale = String (((listarray[i] as AnyObject).value(forKey:"secprefferedsale") as! NSObject).description)
                        let prefferedsale = String (((listarray[i] as AnyObject).value(forKey:"prefferedsale") as! NSObject).description)
                        let prefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"prefferedreasonid") as! NSObject).description)
                        let secprefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"secprefferedreasonid") as! NSObject).description)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int32)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int32)!)
                        let referencecode = String (((listarray[i] as AnyObject).value(forKey:"referencecode") as! NSObject).description)
                        let storeimage = String (((listarray[i] as AnyObject).value(forKey:"storeimage") as? Int32)!)
                        let stockimage = String (((listarray[i] as AnyObject).value(forKey:"stockimage") as? Int32)!)
                        let prefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedothbrand") as! NSObject).description)
                        let secprefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedothbrand") as! NSObject).description)
                        
                        self.updateretailermaster(customercode: customercode, customername: customername, customertype: customertype, contactperson: contactperson, mobilecustcode: mobilecustcode, mobileno: mobileno, alternateno: alternateno, emailid: emailid, address: address, pincode: pincode, city: city, stateid: stateid, gstno: gstno, gstregistrationdate: gstregistrationdate, siteid: siteid, salepersonid: salepersonid, keycustomer: keycustomer, isorthopositive: isorthopositive, sizeofretailer: sizeofretailer, category: category, isblocked: isblocked, pricegroup: pricegroup, dataareaid: dataareaid, latitude: latitude, longitude: longitude, orthopedicsale: orthopedicsale, avgsale: avgsale, prefferedbrand: prefferedbrand, secprefferedbrand: secprefferedbrand, secprefferedsale: secprefferedsale, prefferedsale: prefferedsale, prefferedreasonid: prefferedreasonid, secprefferedreasonid: secprefferedreasonid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2", referencecode: referencecode, lastvisited: "", storeimage: storeimage, stockimage: stockimage, prefferedothbrand: prefferedothbrand, secprefferedothbrand: secprefferedothbrand)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "RetailerMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.getusercity()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "RetailerMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.getusercity()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }
        }
        
        Alamofire.request(constant.Base_url + constant.URL_AttendancemasterConst()).validate().responseJSON {
            response in
            print("URL_Attendancemaster===" + constant.Base_url + constant.URL_AttendancemasterConst())
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deleteAttendanceMaster()
                    for i in 0..<listarray.count{
                        
                        //let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let attnid = String (((listarray[i] as AnyObject).value(forKey:"attnid") as? Int)!)
                        let attndesc = String (((listarray[i] as AnyObject).value(forKey:"attndesc") as! NSObject).description)
                        
                        self.insertattendancemaster(attnid: attnid as NSString, attndesc: attndesc as NSString, isblock: "0")
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updateprogress()
                    self.updatelog(tablename: "AttendanceMaster", status: "success", datetime: self.getTodaydatetime())
                }
                
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "AttendanceMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func getusercity(){
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast( createdtransactionid as int)),'0') as createdtransactionid,ifnull(max(cast(modifiedtransactionid as int)),'0')as modifiedtransactionid from CityMaster"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
         // + created! + "&MODIFIEDTRANSACTIONID=" + modified!
        }
        
        Alamofire.request(constant.Base_url + constant.URL_getusercityConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                  //  self.deleteCityMaster()
                    for i in 0..<listarray.count{
                        
                        //let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let cityname = String (((listarray[i] as AnyObject).value(forKey:"cityname") as! NSObject).description).replacingOccurrences(of: "'", with: "")
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        // let state = String (((listarray[i] as AnyObject).value(forKey:"state") as! NSObject).description)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                        self.insertusercity(CityID: cityid, CityName: cityname, stateid: stateid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "CityMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.userlinkedcity()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "CityMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.userlinkedcity()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func userlinkedcity(){
        
        let url = getUserLinkCityData()
        
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                  //  self.deleteUserLinkCity()
                    for i in 0..<listarray.count{
                        
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let locationtype = String (((listarray[i] as AnyObject).value(forKey:"locationtype") as! NSObject).description)
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                       
                        self.updateUserLinkCityData(cityid: cityid, locationtype: locationtype, dataareaid: dataareaid, isblocked: isblocked, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    constant.taxUpdate = false
                    self.updatelog(tablename: "UserLinkCity", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_statemaster()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "UserLinkCity", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_statemaster()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_statemaster(){
        
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from StateMaster"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
        }
        
        Alamofire.request(constant.Base_url + constant.URL_statemasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                  //  self.deleteStateMaster()
                    for i in 0..<listarray.count{
                        
                        //let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let statename = String (((listarray[i] as AnyObject).value(forKey:"statename") as! NSObject).description)
                        let gststatecode = String (((listarray[i] as AnyObject).value(forKey:"gststatecode") as! NSObject).description)
                        let isunion = String (((listarray[i] as AnyObject).value(forKey:"isunion") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                        self.insertstatemaster(StateID: stateid, StateName: statename, Gststatecode: gststatecode, isunion: isunion, CREATEDTRANSACTIONID: createdtransactionid, ModifiedTransactionId: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "StateMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GETUSERCUSTOMEROTHINFO()
            }
                break
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "StateMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GETUSERCUSTOMEROTHINFO()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_GETUSERCUSTOMEROTHINFO(){
        Alamofire.request(constant.Base_url + constant.URL_GETUSERCUSTOMEROTHINFOConst() + "-1").validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteusercustomer()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let lms = String (((listarray[i] as AnyObject).value(forKey:"lms") as? Double)!)
                        let avgsale = String (((listarray[i] as AnyObject).value(forKey:"avgsale") as? Double)!)
                        let curmonth = String (((listarray[i] as AnyObject).value(forKey:"curmonth") as? Double)!)
                        let lastvisit = String (((listarray[i] as AnyObject).value(forKey:"lastvisit") as! NSObject).description)
                        let reasoN1 = String (((listarray[i] as AnyObject).value(forKey:"reasoN1") as! NSObject).description)
                        let reasoN2 = String (((listarray[i] as AnyObject).value(forKey:"reasoN2") as! NSObject).description)
                        let complain = String (((listarray[i] as AnyObject).value(forKey:"complain") as? Int)!)
                        let escalation = String (((listarray[i] as AnyObject).value(forKey:"escalation") as? Int)!)
                        let usertype = String (((listarray[i] as AnyObject).value(forKey:"usertype") as? Int)!)
                        let lastactivity = String (((listarray[i] as AnyObject).value(forKey:"lastactivity") as! NSObject).description)
                        let lastactivityid = String (((listarray[i] as AnyObject).value(forKey:"lastactivityid") as? Int)!)
                        let ispendingsubconv = String (((listarray[i] as AnyObject).value(forKey:"ispendingsubconv") as? Int)!)
                        let ispendingcomplain = String (((listarray[i] as AnyObject).value(forKey:"ispendingcomplain") as? Int)!)
                        let usertype1 = AppDelegate.usertype
                        if(AppDelegate.isDebug){
                        print("usertype =====> \(usertype1)")
                        }
                        self.insertgetusercustomer(customercode: customercode as NSString?, lms: lms as NSString? as NSString?, avgsale: avgsale as NSString?, reasoN1: reasoN1 as NSString?, reasoN2: reasoN2 as NSString?, complain: complain as NSString?, escalation: escalation as NSString?, currentmonth: curmonth as NSString?, lastvisit: lastvisit as NSString?, usertypeapi: usertype as NSString?, lastactivity: lastactivity as NSString?, lastactivityid: lastactivityid as NSString?, ispendingsubconv: ispendingsubconv as NSString?, ispendingcomplain: ispendingcomplain as NSString?, usertype: "\(usertype1)" as NSString)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "USERCUSTOMEROTHINFO", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GETUSERDISTRIBUTOR()
            }
                break
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "USERCUSTOMEROTHINFO", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GETUSERDISTRIBUTOR()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GETUSERCUSTOMEROTHINFOAsync(customercode: String?)
    {
        Alamofire.request(constant.Base_url + constant.URL_GETUSERCUSTOMEROTHINFOConst() + customercode!).validate().responseJSON {
            response in
            if(AppDelegate.isDebug){
            print("URL_GETUSERCUSTOMEROTHINFOAsync==="+constant.Base_url + constant.URL_GETUSERCUSTOMEROTHINFOConst() + customercode!)
            }
            switch response.result {
            
            case .success(let value):
                 if(AppDelegate.isDebug){
                print("success=======\(value)")
                 }
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let lms = String (((listarray[i] as AnyObject).value(forKey:"lms") as? Double)!)
                        let avgsale = String (((listarray[i] as AnyObject).value(forKey:"avgsale") as? Double)!)
                        let curmonth = String (((listarray[i] as AnyObject).value(forKey:"curmonth") as? Double)!)
                        let lastvisit = String (((listarray[i] as AnyObject).value(forKey:"lastvisit") as! NSObject).description)
                        let reasoN1 = String (((listarray[i] as AnyObject).value(forKey:"reasoN1") as! NSObject).description)
                        let reasoN2 = String (((listarray[i] as AnyObject).value(forKey:"reasoN2") as! NSObject).description)
                        let complain = String (((listarray[i] as AnyObject).value(forKey:"complain") as? Int)!)
                        let escalation = String (((listarray[i] as AnyObject).value(forKey:"escalation") as? Int)!)
                        let usertype = String (((listarray[i] as AnyObject).value(forKey:"usertype") as? Int)!)
                        let lastactivity = String (((listarray[i] as AnyObject).value(forKey:"lastactivity") as! NSObject).description)
                        let lastactivityid = String (((listarray[i] as AnyObject).value(forKey:"lastactivityid") as? Int)!)
                        let ispendingsubconv = String (((listarray[i] as AnyObject).value(forKey:"ispendingsubconv") as? Int)!)
                        let ispendingcomplain = String (((listarray[i] as AnyObject).value(forKey:"ispendingcomplain") as? Int)!)
                        let usertype1 = AppDelegate.usertype
                        
                        var pointer: OpaquePointer? = nil
                        let query1 = "SELECT * FROM USERCUSTOMEROTHINFO where customercode like '\(customercode)'"
                        
                        if sqlite3_prepare_v2(Databaseconnection.dbs, query1 , -1, &pointer, nil) != SQLITE_OK{
                            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                             if(AppDelegate.isDebug){
                            print("error preparing get: \(errmsg)")
                            }
                            return
                        }
                        if(sqlite3_step(pointer) != SQLITE_ROW){
                             self.insertgetusercustomer(customercode: customercode as NSString?, lms: lms as NSString? as NSString?, avgsale: avgsale as NSString?, reasoN1: reasoN1 as NSString?, reasoN2: reasoN2 as NSString?, complain: complain as NSString?, escalation: escalation as NSString?, currentmonth: curmonth as NSString?, lastvisit: lastvisit as NSString?, usertypeapi: usertype as NSString?, lastactivity: lastactivity as NSString?, lastactivityid: lastactivityid as NSString?, ispendingsubconv: ispendingsubconv as NSString?, ispendingcomplain: ispendingcomplain as NSString?, usertype: "\(usertype1)" as NSString)
                        }
                        else{
                            self.updategetusercustomer(customercode: customercode, lms: lms, avgsale: avgsale, reasoN1: reasoN1, reasoN2: reasoN2, complain: complain, escalation: escalation, currentmonth: curmonth, lastvisit: lastvisit, usertypeapi: usertype, lastactivity: lastactivity, lastactivityid: lastactivityid, ispendingsubconv: ispendingsubconv, ispendingcomplain: ispendingcomplain, usertype: "\(usertype1)" as NSString)
                        }
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "USERCUSTOMEROTHINFO", status: "success", datetime: self.getTodaydatetime())
                }
            }
            SwiftEventBus.post("gotusercust")
            break
                
            case .failure(let error):
                if(AppDelegate.isDebug){
                    print("error===========\(error)")
                }
                self.updatelog(tablename: "USERCUSTOMEROTHINFO", status: error.localizedDescription, datetime: self.getTodaydatetime())
                SwiftEventBus.post("errorusercust")
              //  self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GETUSERDISTRIBUTOR(){
        Alamofire.request(constant.Base_url + constant.URL_GETUSERDISTRIBUTORConst()).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteUSERDISTRIBUTOR ()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let sitename = String (((listarray[i] as AnyObject).value(forKey:"sitename") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let mobile = String (((listarray[i] as AnyObject).value(forKey:"mobile") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let statename = String (((listarray[i] as AnyObject).value(forKey:"statename") as! NSObject).description)
                        let salespersoncode = String (((listarray[i] as AnyObject).value(forKey:"salespersoncode") as! NSObject).description)
                        let gstinno = String (((listarray[i] as AnyObject).value(forKey:"gstinno") as! NSObject).description)
                        let email = String (((listarray[i] as AnyObject).value(forKey:"email") as! NSObject).description)
                        let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                        let plantcode = String (((listarray[i] as AnyObject).value(forKey:"plantcode") as! NSObject).description)
                        let plantstateid = String (((listarray[i] as AnyObject).value(forKey:"plantstateid") as! NSObject).description)
                       
                        let isdisplay = String (((listarray[i] as AnyObject).value(forKey:"isdisplay") as? Bool)!)//distributortype
                        
                        let distributortype = String (((listarray[i] as AnyObject).value(forKey:"distributortype") as! NSObject).description)
                       
                        self.insertgetUSERDISTRIBUTOR(siteid: siteid as NSString, sitename: sitename as NSString, address: address as NSString, city: city as NSString, mobile: mobile as NSString, stateid: stateid as NSString, statename: statename as NSString, salespersoncode: salespersoncode as NSString, gstinno: gstinno as NSString, email: email as NSString, pricegroup: pricegroup as NSString, plantcode: plantcode as NSString, plantstateid: plantstateid as NSString,isdisplay: isdisplay as NSString, distributortype: distributortype)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "USERDISTRIBUTOR", status: "success", datetime: self.getTodaydatetime())
                    
                    
                }
                self.updateprogress()
                self.URL_ITEMMASTER()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "USERDISTRIBUTOR", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_ITEMMASTER()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_ITEMMASTER(){
        let url = getitemmasterdata()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
//                self.deleteitemmaster()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        
                        let itemgroup = String (((listarray[i] as AnyObject).value(forKey:"itemgroup") as! NSObject).description)
                        let itemsubgroup = String (((listarray[i] as AnyObject).value(forKey:"itemsubgroup") as! NSObject).description)
                        let itemgroupid = String (((listarray[i] as AnyObject).value(forKey:"itemgroupid") as! NSObject).description)
                        let itemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as! NSObject).description)
                        let itemname = String (((listarray[i] as AnyObject).value(forKey:"itemname") as! NSObject).description)
                        let itemmrp = String (((listarray[i] as AnyObject).value(forKey:"itemmrp") as? Double)!)
                        let itempacksize = String (((listarray[i] as AnyObject).value(forKey:"itempacksize") as? Double)!)
                        let itemvarriantsize = String (((listarray[i] as AnyObject).value(forKey:"itemvarriantsize") as! NSObject).description)
                        let uom = String (((listarray[i] as AnyObject).value(forKey:"uom") as! NSObject).description)
                        let barcode = ""
                        //String (((listarray[i] as AnyObject).value(forKey:"barcode") as! NSObject).description)
                        let createdTransactionId = String (((listarray[i] as AnyObject).value(forKey:"createdTransactionId") as? Int32)!)
                        let modifiedTransactionId = String (((listarray[i] as AnyObject).value(forKey:"modifiedTransactionId") as? Int32)!)
                        let hsncode = String (((listarray[i] as AnyObject).value(forKey:"hsncode") as! NSObject).description)
                        let isexempt = String (((listarray[i] as AnyObject).value(forKey:"isexempt") as? Bool)!)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let ispcsapply = String (((listarray[i] as AnyObject).value(forKey:"ispcsapply") as! NSObject).description)
                        let itembuyergroupid = String (((listarray[i] as AnyObject).value(forKey:"itembuyergroupid") as! NSObject).description)
                        
                        self.updateitemmaster(itemgroup: itemgroup, itemsubgroup: itemsubgroup, itemgroupid: itemgroupid, itemid: itemid, itemname: itemname, itemmrp: itemmrp, itempacksize: itempacksize, itemvarriantsize: itemvarriantsize, uom: uom, barcode: barcode, createdTransactionId: createdTransactionId, modifiedTransactionId: modifiedTransactionId, hsncode: hsncode, isexempt: isexempt, isblocked: isblocked, ispcsapply: ispcsapply, itembuyergroupid: itembuyergroupid)

                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "ItemMaster", status: "success", datetime: self.getTodaydatetime())
                    
                }
                self.updateprogress()
                self.URL_PROFILEDETAIL()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "ItemMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_PROFILEDETAIL()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    // Profile Detail
    // self.showloader(title: "We\'re setting things up for you...")
    func URL_PROFILEDETAIL(){
        Alamofire.request(constant.Base_url + constant.URL_PROFILEDETAILConst()).validate().responseJSON {
            response in
            print("ProfileDetail====="+constant.Base_url + constant.URL_PROFILEDETAILConst())
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteProfiledetail()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let employeecode = String (((listarray[i] as AnyObject).value(forKey:"employeecode") as! NSObject).description)
                        let employeename = String (((listarray[i] as AnyObject).value(forKey:"employeename") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let statename = String (((listarray[i] as AnyObject).value(forKey:"statename") as! NSObject).description)
                        let dob = String (((listarray[i] as AnyObject).value(forKey:"dob") as! NSObject).description)
                        let doj = String (((listarray[i] as AnyObject).value(forKey:"doj") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let contactno = String (((listarray[i] as AnyObject).value(forKey:"contactno") as! NSObject).description)
                        let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let password = String (((listarray[i] as AnyObject).value(forKey:"password") as! NSObject).description)
                        let pocket = String (((listarray[i] as AnyObject).value(forKey:"pocket") as! NSObject).description)
                        let sector = String (((listarray[i] as AnyObject).value(forKey:"sector") as! NSObject).description)
                        let teritory = String (((listarray[i] as AnyObject).value(forKey:"teritory") as! NSObject).description)
                        let usertype = String (((listarray[i] as AnyObject).value(forKey:"usertype") as? Int)!)
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let sponame = String (((listarray[i] as AnyObject).value(forKey:"sponame") as! NSObject).description)
                        let spomobile = String (((listarray[i] as AnyObject).value(forKey:"spomobile") as! NSObject).description)
                        let asmname = String (((listarray[i] as AnyObject).value(forKey:"asmname") as! NSObject).description)
                        let asmmobile = String (((listarray[i] as AnyObject).value(forKey:"asmmobile") as! NSObject).description)
                        let rsmname = String (((listarray[i] as AnyObject).value(forKey:"rsmname") as! NSObject).description)
                        let rsmmobile = String (((listarray[i] as AnyObject).value(forKey:"rsmmobile") as! NSObject).description)
                        let zsmname = String (((listarray[i] as AnyObject).value(forKey:"zsmname") as! NSObject).description)
                        let zsmmobile = String (((listarray[i] as AnyObject).value(forKey:"zsmmobile") as! NSObject).description)
                        let tmname = String (((listarray[i] as AnyObject).value(forKey:"tmname") as! NSObject).description)
                        let tmmobile = String (((listarray[i] as AnyObject).value(forKey:"tmmobile") as! NSObject).description)
                        let nsmname = String (((listarray[i] as AnyObject).value(forKey:"nsmname") as! NSObject).description)
                        let nsmmobile = String (((listarray[i] as AnyObject).value(forKey:"nsmmobile") as! NSObject).description)
                        let salarymonth = String (((listarray[i] as AnyObject).value(forKey:"salarymonth") as? Double)!)
                        let aadhaar = String (((listarray[i] as AnyObject).value(forKey:"aadhaar") as! NSObject).description)
                        let docpan = String (((listarray[i] as AnyObject).value(forKey:"docpan") as! NSObject).description)
                        let docgst = String (((listarray[i] as AnyObject).value(forKey:"docgst") as! NSObject).description)
                        let docpdc = String (((listarray[i] as AnyObject).value(forKey:"docpdc") as! NSObject).description)
                        let docaggreement = String (((listarray[i] as AnyObject).value(forKey:"docaggreement") as! NSObject).description)
                        let docaadhaar = String (((listarray[i] as AnyObject).value(forKey:"docaadhaar") as! NSObject).description)
                        let doccancelledcheque = String (((listarray[i] as AnyObject).value(forKey:"doccancelledcheque") as! NSObject).description)
                        let headquater = String (((listarray[i] as AnyObject).value(forKey:"headquater") as? Double)!)
                        let exheadquater = String (((listarray[i] as AnyObject).value(forKey:"exheadquater") as? Double)!)
                        let outstation = String (((listarray[i] as AnyObject).value(forKey:"outstation") as? Double)!)
                        let misc = String (((listarray[i] as AnyObject).value(forKey:"misc") as? Double)!)
                        let ismobileblock = String (((listarray[i] as AnyObject).value(forKey:"ismobileblock") as? Int)!)
                        let alloweddisc = String (((listarray[i] as AnyObject).value(forKey:"alloweddisc") as? Double)!)
                        let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                        let jobdesc = String (((listarray[i] as AnyObject).value(forKey:"jobdesc") as! NSObject).description)
                        let monthlyta = String (((listarray[i] as AnyObject).value(forKey:"monthlyta") as? Double)!)
                        let balanceta = String (((listarray[i] as AnyObject).value(forKey:"balanceta") as? Double)!)
                        let oscount = String (((listarray[i] as AnyObject).value(forKey:"oscount") as? Int)!)
                        let balancemiscellaneous = String (((listarray[i] as AnyObject).value(forKey:"balancemiscellaneous") as? Double)!)
                        let trainername = String (((listarray[i] as AnyObject).value(forKey:"trainername") as! NSObject).description)
                        let istraining = String (((listarray[i] as AnyObject).value(forKey:"istraining") as? Int)!)
                        
                        UserDefaults.standard.set(pricegroup, forKey: "pricegroup")
                        
                        self.insertProfiledetail(usercode: usercode as NSString, employeecode: employeecode as NSString, employeename: employeename as NSString, address: address as NSString, city: city as NSString, pincode: pincode as NSString, stateid: stateid as NSString, statename: statename as NSString, dob: dob as NSString, doj: doj as NSString, emailid: emailid as NSString, contactno: contactno as NSString, mobileno: mobileno as NSString, password: password as NSString, pocket: pocket as NSString, sector: sector as NSString, teritory: teritory as NSString, usertype: usertype as NSString, dataareaid: dataareaid as NSString, siteid: siteid as NSString, sponame: sponame as NSString, spomobile: spomobile as NSString, asmname: asmname as NSString, asmmobile: asmmobile as NSString, rsmname: rsmname as NSString, rsmmobile: rsmmobile as NSString, zsmname: zsmname as NSString, zsmmobile: zsmmobile as NSString, tmname: tmname as NSString, tmmobile: tmmobile as NSString, nsmname: nsmname as NSString, nsmmobile: nsmmobile as NSString, salarymonth: salarymonth as NSString, aadhaar: aadhaar as NSString, docpan: docpan as NSString, docgst: docgst as NSString, docpdc: docpdc as NSString, docaggreement: docaggreement as NSString, docaadhaar: docaadhaar as NSString, doccancelledcheque: doccancelledcheque as NSString, headquater: headquater as NSString, exheadquater: exheadquater as NSString, outstation: outstation as NSString, misc: misc as NSString, Ismobileblock: ismobileblock as NSString, alloweddisc: alloweddisc as NSString, pricegroup: pricegroup as NSString, jobdesc: jobdesc as NSString, monthlyta: monthlyta as NSString, balanceta: balanceta as NSString, oscount: oscount as NSString, balancemiscellaneous: balancemiscellaneous as NSString,showtrainbar: trainername as NSString, istraining: istraining as NSString)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "ProfileDetail", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetEscalationReason()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "ProfileDetail", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetEscalationReason()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_PROFILEDETAILbck(){
        Alamofire.request(constant.Base_url + constant.URL_PROFILEDETAILConst()).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteProfiledetail()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let employeecode = String (((listarray[i] as AnyObject).value(forKey:"employeecode") as! NSObject).description)
                        let employeename = String (((listarray[i] as AnyObject).value(forKey:"employeename") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let statename = String (((listarray[i] as AnyObject).value(forKey:"statename") as! NSObject).description)
                        let dob = String (((listarray[i] as AnyObject).value(forKey:"dob") as! NSObject).description)
                        let doj = String (((listarray[i] as AnyObject).value(forKey:"doj") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let contactno = String (((listarray[i] as AnyObject).value(forKey:"contactno") as! NSObject).description)
                        let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let password = String (((listarray[i] as AnyObject).value(forKey:"password") as! NSObject).description)
                        let pocket = String (((listarray[i] as AnyObject).value(forKey:"pocket") as! NSObject).description)
                        let sector = String (((listarray[i] as AnyObject).value(forKey:"sector") as! NSObject).description)
                        let teritory = String (((listarray[i] as AnyObject).value(forKey:"teritory") as! NSObject).description)
                        let usertype = String (((listarray[i] as AnyObject).value(forKey:"usertype") as? Int)!)
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let sponame = String (((listarray[i] as AnyObject).value(forKey:"sponame") as! NSObject).description)
                        let spomobile = String (((listarray[i] as AnyObject).value(forKey:"spomobile") as! NSObject).description)
                        let asmname = String (((listarray[i] as AnyObject).value(forKey:"asmname") as! NSObject).description)
                        let asmmobile = String (((listarray[i] as AnyObject).value(forKey:"asmmobile") as! NSObject).description)
                        let rsmname = String (((listarray[i] as AnyObject).value(forKey:"rsmname") as! NSObject).description)
                        let rsmmobile = String (((listarray[i] as AnyObject).value(forKey:"rsmmobile") as! NSObject).description)
                        let zsmname = String (((listarray[i] as AnyObject).value(forKey:"zsmname") as! NSObject).description)
                        let zsmmobile = String (((listarray[i] as AnyObject).value(forKey:"zsmmobile") as! NSObject).description)
                        let tmname = String (((listarray[i] as AnyObject).value(forKey:"tmname") as! NSObject).description)
                        let tmmobile = String (((listarray[i] as AnyObject).value(forKey:"tmmobile") as! NSObject).description)
                        let nsmname = String (((listarray[i] as AnyObject).value(forKey:"nsmname") as! NSObject).description)
                        let nsmmobile = String (((listarray[i] as AnyObject).value(forKey:"nsmmobile") as! NSObject).description)
                        let salarymonth = String (((listarray[i] as AnyObject).value(forKey:"salarymonth") as? Double)!)
                        let aadhaar = String (((listarray[i] as AnyObject).value(forKey:"aadhaar") as! NSObject).description)
                        let docpan = String (((listarray[i] as AnyObject).value(forKey:"docpan") as! NSObject).description)
                        let docgst = String (((listarray[i] as AnyObject).value(forKey:"docgst") as! NSObject).description)
                        let docpdc = String (((listarray[i] as AnyObject).value(forKey:"docpdc") as! NSObject).description)
                        let docaggreement = String (((listarray[i] as AnyObject).value(forKey:"docaggreement") as! NSObject).description)
                        let docaadhaar = String (((listarray[i] as AnyObject).value(forKey:"docaadhaar") as! NSObject).description)
                        let doccancelledcheque = String (((listarray[i] as AnyObject).value(forKey:"doccancelledcheque") as! NSObject).description)
                        let headquater = String (((listarray[i] as AnyObject).value(forKey:"headquater") as? Double)!)
                        let exheadquater = String (((listarray[i] as AnyObject).value(forKey:"exheadquater") as? Double)!)
                        let outstation = String (((listarray[i] as AnyObject).value(forKey:"outstation") as? Double)!)
                        let misc = String (((listarray[i] as AnyObject).value(forKey:"misc") as? Double)!)
                        let ismobileblock = String (((listarray[i] as AnyObject).value(forKey:"ismobileblock") as? Int)!)
                        let alloweddisc = String (((listarray[i] as AnyObject).value(forKey:"alloweddisc") as? Double)!)
                        let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                        let jobdesc = String (((listarray[i] as AnyObject).value(forKey:"jobdesc") as! NSObject).description)
                        let monthlyta = String (((listarray[i] as AnyObject).value(forKey:"monthlyta") as? Double)!)
                        let balanceta = String (((listarray[i] as AnyObject).value(forKey:"balanceta") as? Double)!)
                        let oscount = String (((listarray[i] as AnyObject).value(forKey:"oscount") as? Int)!)
                        let balancemiscellaneous = String (((listarray[i] as AnyObject).value(forKey:"balancemiscellaneous") as? Double)!)
                        let trainername = String (((listarray[i] as AnyObject).value(forKey:"trainername") as! NSObject).description)
                        UserDefaults.standard.set(pricegroup, forKey: "pricegroup")
                        let istraining = String (((listarray[i] as AnyObject).value(forKey:"istraining") as? Int)!)
                        
                        self.insertProfiledetail(usercode: usercode as NSString, employeecode: employeecode as NSString, employeename: employeename as NSString, address: address as NSString, city: city as NSString, pincode: pincode as NSString, stateid: stateid as NSString, statename: statename as NSString, dob: dob as NSString, doj: doj as NSString, emailid: emailid as NSString, contactno: contactno as NSString, mobileno: mobileno as NSString, password: password as NSString, pocket: pocket as NSString, sector: sector as NSString, teritory: teritory as NSString, usertype: usertype as NSString, dataareaid: dataareaid as NSString, siteid: siteid as NSString, sponame: sponame as NSString, spomobile: spomobile as NSString, asmname: asmname as NSString, asmmobile: asmmobile as NSString, rsmname: rsmname as NSString, rsmmobile: rsmmobile as NSString, zsmname: zsmname as NSString, zsmmobile: zsmmobile as NSString, tmname: tmname as NSString, tmmobile: tmmobile as NSString, nsmname: nsmname as NSString, nsmmobile: nsmmobile as NSString, salarymonth: salarymonth as NSString, aadhaar: aadhaar as NSString, docpan: docpan as NSString, docgst: docgst as NSString, docpdc: docpdc as NSString, docaggreement: docaggreement as NSString, docaadhaar: docaadhaar as NSString, doccancelledcheque: doccancelledcheque as NSString, headquater: headquater as NSString, exheadquater: exheadquater as NSString, outstation: outstation as NSString, misc: misc as NSString, Ismobileblock: ismobileblock as NSString, alloweddisc: alloweddisc as NSString, pricegroup: pricegroup as NSString, jobdesc: jobdesc as NSString, monthlyta: monthlyta as NSString, balanceta: balanceta as NSString, oscount: oscount as NSString, balancemiscellaneous: balancemiscellaneous as NSString, showtrainbar: trainername as NSString, istraining: istraining as NSString)
                        
                    }
                    self.updatelog(tablename: "ProfileDetail", status: "success", datetime: self.getTodaydatetime())
                    
                }
//                self.updateprogress()
                SwiftEventBus.post("profiledone")
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "ProfileDetail", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GetEscalationReason(){
        
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(CREATEDTRANSACTIONID),'0') as createdid,ifnull(max(ModifiedTransactionId),'0') as modifiedid from EscalationReason"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
        }

        Alamofire.request(constant.Base_url + constant.URL_GetEscalationReasonConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
            switch response.result {
               // 0&MODIFIEDTRANSACTIONID=0
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    self.deleteescalationreason()
                    for i in 0..<listarray.count{
                        
                        let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                        let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as! NSObject).description)
                        let reasondescription = String (((listarray[i] as AnyObject).value(forKey:"reasondescription") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblock") as! NSObject).description)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                        self.insertescalation(reasoncode: reasoncode as NSString?, reasondescription: reasondescription as NSString?, CREATEDTRANSACTIONID: createdtransactionid as NSString?, ModifiedTransactionId: modifiedtransactionid as NSString?, isblock: isblocked as NSString?, recid: recid as NSString?)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "EscalationReason", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetNoOrderReasion()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "EscalationReason", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetNoOrderReasion()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GetNoOrderReasion(){
        let url = getNorderReasonData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
//                    self.deleteNoOrderReasonMaster()
                    for i in 0..<listarray.count{
                        
                        let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                        let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as! NSObject).description)
                        let reasondescription = String (((listarray[i] as AnyObject).value(forKey:"reasondescription") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as! NSObject).description)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                          self.updatenoOrderreason(reasoncode: reasoncode, reasondescription: reasondescription, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, isblock: isblocked, recid: recid)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "NoOrderReasonMaster", status: "success", datetime: self.getTodaydatetime())
                    
                }
                self.updateprogress()
                self.URL_GETUSERHIERARCHY()
            }
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "NoOrderReasonMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GETUSERHIERARCHY()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    //USERHIERARCHY
    
    func URL_GETUSERHIERARCHY(){
        Alamofire.request(constant.Base_url + constant.URL_GETUSERHIERARCHYConst()).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteUSERHIERARCHY()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let usertype = String (((listarray[i] as AnyObject).value(forKey:"usertype") as? Int)!)
                        let employeecode = String (((listarray[i] as AnyObject).value(forKey:"employeecode") as! NSObject).description)
                        let empname = String (((listarray[i] as AnyObject).value(forKey:"empname") as! NSObject).description)
                        self.insertUSERHIERARCHY(usercode: usercode as NSString, usertype: usertype as NSString, employeecode: employeecode as NSString, empname: empname as NSString)
                        
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "USERHIERARCHY", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GETProductCurrentday()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "USERHIERARCHY", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GETProductCurrentday()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    //Product current day
    
    func URL_GETProductCurrentday(){
        
        self.deleteproductday()
        
        Alamofire.request(constant.Base_url + constant.URL_GETProductCurrentdayConst()).validate().responseJSON {
            response in
            print("URL_GETProductCurrentday===============")
            print(constant.Base_url + constant.URL_GETProductCurrentdayConst())
            switch response.result {
                
            case .success(let value):
                print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let itemgroupid = String (((listarray[i] as AnyObject).value(forKey:"itemgroupid") as! NSObject).description)
                        let transactiondate = String (((listarray[i] as AnyObject).value(forKey:"transactiondate") as! NSObject).description)
                        
                        let base = Baseactivity()
                        var stmt1: OpaquePointer?
                        let q = "select * from ProductDay where itemgroupid='\(itemgroupid)'and isdate='\(base.getdate())'"
                        
                        if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
                            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                            print("error preparing get: \(errmsg)")
                            return
                        }
                        
                        if sqlite3_step(stmt1) != SQLITE_ROW
                        {
                            self.insertProductDay(dataareaid: dataareaid as NSString, itemgroupid: itemgroupid as NSString, usercode: usercode as NSString, pddate: transactiondate as NSString, post: "0", isapprove: "1")
                            
                        }
                    }
                }
                
                Alamofire.request(constant.Base_url + constant.URL_GETProductDayConst()).validate().responseJSON {
                    response in
                    print("URL_GETProductDayConst================================")
                    print(constant.Base_url + constant.URL_GETProductDayConst())
                    switch response.result {
                    case .success(let value):   print("success=======\(value)")
                    if  let json = response.result.value{
                        let listarray : NSArray = json as! NSArray
                        if listarray.count > 0 {
                            for i in 0..<listarray.count{
                                let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                                let itemgroupid = String (((listarray[i] as AnyObject).value(forKey:"itemgroupid") as! NSObject).description)
                                let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                                let pddate = String (((listarray[i] as AnyObject).value(forKey:"pddate") as! NSObject).description)
                                let base = Baseactivity()
                                var stmt1: OpaquePointer?
                                let q = "select * from ProductDay where itemgroupid='\(itemgroupid)'and isdate='\(base.getdate())'"
                                
                                if sqlite3_prepare_v2(Databaseconnection.dbs, q, -1, &stmt1, nil) != SQLITE_OK{
                                    let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                                    print("error preparing get: \(errmsg)")
                                    return
                                }
                                //                                        self.URL_GETUserCurrentCity()
                                if sqlite3_step(stmt1) != SQLITE_ROW
                                {
                                    self.insertProductDay(dataareaid: dataareaid as NSString, itemgroupid: itemgroupid as NSString, usercode: usercode as NSString, pddate: pddate as NSString, post: "2", isapprove: "1")
                                }
                            }}
                        self.updateprogress()
                        
                    }
                    break
                        
                    case .failure(let error):  print("error===========\(error)")
                    self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                        break
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    
                    self.updatelog(tablename: "ProductDay", status: "success", datetime: self.getTodaydatetime())
                }
            }
            self.updateprogress()
            self.URL_GETUserCurrentCity()
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "ProductDay", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GETUserCurrentCity()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_GETUserCurrentCity(){
        Alamofire.request(constant.Base_url + constant.URL_GETUserCurrentCityConst()).validate().responseJSON {
            response in
            self.deleteUserCurrentCity()
            
            switch response.result {
                
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let submittime = String (((listarray[i] as AnyObject).value(forKey:"submittime") as! NSObject).description)
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        
                        self.insertUserCurrentCity(date: submittime as NSString , city: cityid as NSString, isblocked: isblocked as NSString, post: "2")
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "UserCurrentCity", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GETDealerConvert()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "UserCurrentCity", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GETDealerConvert()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    //DEALERCONVERT
    func URL_GETDealerConvert(){
        
        let url = getDealerConvertData()
        
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
//                self.deletesubdealers()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let submitdate = String (((listarray[i] as AnyObject).value(forKey:"submitdate") as! NSObject).description)
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Int)!)
                        let approvedby = String (((listarray[i] as AnyObject).value(forKey: "approvedby") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let expsale = String (((listarray[i] as AnyObject).value(forKey:"expsale") as? Double)!)
                        let expdiscount = String (((listarray[i] as AnyObject).value(forKey:"expdiscount") as? Double)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                          self.updateDealerConvertData(customercode: customercode, expectedsale: expsale, expectedDiscount: expdiscount, dataareaid: dataareaid, recid: recid, submitdate: submitdate, status: status, approvedby: approvedby, siteid: siteid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2")
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "subdealers", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_Objectionmaster()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "subdealers", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_Objectionmaster()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_Objectionmaster(){
        let url = getObjectionMasterData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
//                    self.deleteObjectionMaster()
                    for i in 0..<listarray.count{
                        
                        let objectioncode = String (((listarray[i] as AnyObject).value(forKey:"objectioncode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let objectiondesc = String (((listarray[i] as AnyObject).value(forKey:"objectiondesc") as! NSObject).description)
                        
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as! NSObject).description)
                        
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                         self.updateObjectionMasterData(objectioncode: objectioncode, objectiondesc: objectiondesc, isblocked: isblocked, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, status: status)
        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "ObjectionMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_feedbacktype()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "ObjectionMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_feedbacktype()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func  URL_feedbacktype(){
        Alamofire.request(constant.Base_url + constant.URL_feedbacktype).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deletefeedbacktype()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        let typecode = String (((listarray[i] as AnyObject).value(forKey:"typecode") as! NSObject).description)
                        let feedbacK_TYPE = String (((listarray[i] as AnyObject).value(forKey:"feedbacK_TYPE") as! NSObject).description)
                        
                        self.insertfeedbacktype(typecode: typecode as NSString, feedbacK_TYPE: feedbacK_TYPE as NSString)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "feedbacktype", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_Getattandence()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "feedbacktype", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_Getattandence()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_Getattandence(){
        Alamofire.request(constant.Base_url + constant.URL_GetattandenceConst()).validate().responseJSON {
            response in
            print("GetAttendance=="+constant.Base_url + constant.URL_GetattandenceConst())
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteAttendance()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let attnid = String (((listarray[i] as AnyObject).value(forKey:"attnid") as? Int)!)
                        let attndate = String (((listarray[i] as AnyObject).value(forKey:"attndate") as! NSObject).description)
                        let latitude = String (((listarray[i] as AnyObject).value(forKey:"latitude") as? Double)!)
                        let longitude = String (((listarray[i] as AnyObject).value(forKey:"longitude") as? Double)!)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        
                        self.insertattendance(usercode: usercode as NSString, status: attnid as  NSString, lat: latitude as NSString, lon: longitude as NSString, attendancedate: attndate as NSString, post: "2", usertype: "", dataareaid: dataareaid as NSString, isblocked: isblocked as NSString)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "Attendance", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_getcompetitor()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "Attendance", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_getcompetitor()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
  
    func URL_GetUserPriceList(){
        let url = getpricetabledata()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):
                
                print("price lit success=======\(value)")
            if  let json = response.result.value{

                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let srl = String (((listarray[i] as AnyObject).value(forKey:"srl") as? Int)!)
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let pricegroupid = String (((listarray[i] as AnyObject).value(forKey:"pricegroupid") as! NSObject).description)
                        let itemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as! NSObject).description)
                        let price = String (((listarray[i] as AnyObject).value(forKey:"price") as? Double)!)
                        let uom = String (((listarray[i] as AnyObject).value(forKey:"uom") as! NSObject).description)
                        let mrp = String (((listarray[i] as AnyObject).value(forKey:"mrp") as? Double)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        
                        self.updatepricelist(srl: srl, datareaid: dataareaid, pricegroupid: pricegroupid, itemid: itemid, uom: uom, price: price, mrp: mrp, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "UserPriceList", status: "success", datetime: self.getTodaydatetime())
                }
            }
            UserDefaults.standard.set(true,forKey: "usertaxsetuploaded")
                print("event fired===========")
            SwiftEventBus.post("gottaxsetup")
           
            break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "UserPriceList",status: error.localizedDescription, datetime: self.getTodaydatetime())
            SwiftEventBus.post("gopricefailure")
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_getcompetitor(){
        let url = getcompetitortabledata()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            print("MasterURL="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
             //   self.deleteCOMPETITORDETAIL()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let compititorid = String (((listarray[i] as AnyObject).value(forKey:"compititorid") as! NSObject).description)
                        let compititorname = String (((listarray[i] as AnyObject).value(forKey:"compititorname") as! NSObject).description)
                        let itemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as? Int)!)
                        let itemname = String (((listarray[i] as AnyObject).value(forKey:"itemname") as! NSObject).description).replacingOccurrences(of: "'s", with: "").replacingOccurrences(of: "/",  with: "").replacingOccurrences(of: ",", with: "")
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let isapproved = String (((listarray[i] as AnyObject).value(forKey:"isapproved") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)

                        
                        self.insertcompetitor(dataareaid: dataareaid, compititorid: compititorid, compititorname: compititorname, itemid: itemid, itemname: itemname, post: "2", isblocked: isblocked, status: status, isapproved: isapproved, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "COMPETITORDETAIL", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_getusercompetitor()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "COMPETITORDETAIL",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_getusercompetitor()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_getusercompetitor(){
        let compURL = getuserCompetitorURL()
        Alamofire.request(constant.Base_url + compURL).validate().responseJSON {
            response in
            print("MasterURL="+constant.Base_url + compURL)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
             //   self.deleteCOMPETITORDETAILPOST()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let compitemid = String (((listarray[i] as AnyObject).value(forKey:"compitemid") as? Int)!)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let monthlysale = String (((listarray[i] as AnyObject).value(forKey:"monthlysale") as? Double)!)
                        let reasonid = String (((listarray[i] as AnyObject).value(forKey:"reasonid") as! NSObject).description)
                        let saleqty = String (((listarray[i] as AnyObject).value(forKey:"saleqty") as? Double)!)
                        let ispreffered = String (((listarray[i] as AnyObject).value(forKey:"ispreffered") as? Bool)!)
                        let preffindex = String (((listarray[i] as AnyObject).value(forKey:"preffindex") as? Double)!)
                        let compititorid = String (((listarray[i] as AnyObject).value(forKey:"compititorid") as! NSObject).description)
                        let compititordesc = String (((listarray[i] as AnyObject).value(forKey:"compititordesc") as! NSObject).description).replacingOccurrences(of: "", with: "-")
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        // let preferred = String (((listarray[i] as AnyObject).value(forKey:"preferred Type") as! NSObject).description)
                        
                        self.insertusercompetitor(DATAAREAID: dataareaid, CUSTOMERCODE: customercode, ITEMID: compitemid, SITEID: siteid, USERCODE: UserDefaults.standard.string(forKey: "usercode")!, post: "2", Competitorid: compititorid, reasonid: reasonid, qty: saleqty, sale: monthlysale, ispreffered: ispreffered, preffindex: preffindex, brandname: compititordesc, isblocked: isblocked, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "COMPETITORDETAILPOST", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_userDR()
            }
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "COMPETITORDETAILPOST",status: error.localizedDescription, datetime: self.getTodaydatetime())
            
            self.URL_userDR()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_userDR(){
        
        let url = getUserDRCUSTLinkingData()
        
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            print("MasterURL="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
//                self.deleteuserDRCustLinking()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let drcode = String (((listarray[i] as AnyObject).value(forKey:"drcode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let ispurchaseing = String (((listarray[i] as AnyObject).value(forKey:"ispurchaseing") as? Bool)!)
                        let ispriscription = String (((listarray[i] as AnyObject).value(forKey:"ispriscription") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        
                        self.updateUserDrcustlinking1(dataareaid: dataareaid, siteid: siteid, customercode: customercode, drcode: drcode, isblocked: isblocked, ispurchaseing: ispurchaseing, ispriscription: ispriscription, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2")
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "userDRCustLinking", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_Getpdffile()
            }
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "userDRCustLinking",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_Getpdffile()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_Getpdffile(){
        Alamofire.request(constant.Base_url + constant.URL_GetpdffileConst()).validate().responseJSON {
            response in
            
            switch response.result {
            case .success(let value): print("success==========> \(value)")
            
            self.deleteCircular()
            
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let sno = String (((listarray[i] as AnyObject).value(forKey:"s.no") as? Int)!)
                        let filename = String (((listarray[i] as AnyObject).value(forKey:"filename") as! NSObject).description)
                        let filetype = String (((listarray[i] as AnyObject).value(forKey:"filetype") as! NSObject).description)
                        let filepath = String (((listarray[i] as AnyObject).value(forKey:"filepath") as! NSObject).description)
                        let description = String(((listarray[i] as AnyObject).value(forKey:"description") as! NSObject).description)
                        let territorycode = String (((listarray[i] as AnyObject).value(forKey:"territorycode") as! NSObject).description)
                        let sectorcode = String (((listarray[i] as AnyObject).value(forKey:"sectorcode") as! NSObject).description)
                        let pocketcode = String (((listarray[i] as AnyObject).value(forKey:"pocketcode") as! NSObject).description)
                        let uploaddate = String(((listarray[i] as AnyObject).value(forKey:"uploaddate") as! NSObject).description)
                        let uploadtime = String (((listarray[i] as AnyObject).value(forKey:"uploadtime") as! NSObject).description)
                        
                        self.insertCircular(sno: sno, filename: filename, type: filetype, url: filepath, description: description, uploaddate: uploaddate, uploadtime: uploadtime)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "Circular", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_getpendingsubdealer()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.URL_getpendingsubdealer()
            self.updatelog(tablename: "Circular",status: error as? String, datetime: self.getTodaydatetime())
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    //get pendingsubdealer
    func URL_getpendingsubdealer(){
        Alamofire.request(constant.Base_url + constant.URL_getpendingsubdealerConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deletePendingsubdealer()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let customername = String (((listarray[i] as AnyObject).value(forKey:"customername") as! NSObject).description)
                        let distributorcode = String (((listarray[i] as AnyObject).value(forKey:"distributorcode") as! NSObject).description)
                        let distributorname = String (((listarray[i] as AnyObject).value(forKey:"distributorname") as! NSObject).description)
                        let expsale = String (((listarray[i] as AnyObject).value(forKey:"expsale") as? Double)!)
                        let expdiscount = String (((listarray[i] as AnyObject).value(forKey:"expdiscount") as? Double)!)
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let submitdate = String (((listarray[i] as AnyObject).value(forKey:"submitdate") as! NSObject).description)
                        let type = String (((listarray[i] as AnyObject).value(forKey:"type") as! NSObject).description)
                        let conV_REQUEST = String (((listarray[i] as AnyObject).value(forKey:"conV_REQUEST") as! NSObject).description)
                        let username = String (((listarray[i] as AnyObject).value(forKey:"username") as! NSObject).description)
                        let linkedemployee = String (((listarray[i] as AnyObject).value(forKey:"linkedemployee") as! NSObject).description)
                        
                        self.insertPendingsubdealer(recid: recid, customercode: customercode, customername: customername, distributorcode: distributorcode, distributorname: distributorname, expsale: expsale, expdiscount: expdiscount, usercode: usercode, submitdate: submitdate, type: type, conV_REQUEST: conV_REQUEST, username: username)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "Pendingsubdealer", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_getuserdrmaster()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "Pendingsubdealer",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_getuserdrmaster()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_getuserdrmaster(){
        
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from DRMASTER"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
            
            //  0&MODIFIEDTRANSACTIONID=0&ISMOBILE=1
        }
        Alamofire.request(constant.Base_url + constant.URL_getuserdrmasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified! + "&ISMOBILE=1" ).validate().responseJSON {
            response in
            print("MasterURL="+constant.Base_url + constant.URL_getuserdrmasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified! + "&ISMOBILE=1")
            switch response.result {
            case .success(let value): print("success==========> \(value)")
            
            //  self.deleteDRMASTER()
            
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let drcode = String (((listarray[i] as AnyObject).value(forKey:"drcode") as! NSObject).description)
                        let drname = String (((listarray[i] as AnyObject).value(forKey:"drname") as! NSObject).description)
                        let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let alternateno = String(((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let city = String(((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let dob = String (((listarray[i] as AnyObject).value(forKey:"dob") as! NSObject).description)
                        let doa = String (((listarray[i] as AnyObject).value(forKey:"doa") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let ispurchaseing = String (((listarray[i] as AnyObject).value(forKey:"ispurchaseing") as? Bool)!)
                        let ispriscription = String(((listarray[i] as AnyObject).value(forKey:"ispriscription") as? Bool)!)
                        let drspecialization = String (((listarray[i] as AnyObject).value(forKey:"drspecialization") as! NSObject).description)
                        let createdTransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int64)!)
                        let modifiedTransationid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int64)!)
                        let purchaseamt = String(((listarray[i] as AnyObject).value(forKey:"purchaseamt") as? Double)!)
                        let noofprescription = String (((listarray[i] as AnyObject).value(forKey:"noofprescription") as? Double)!)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let isbuying = String(((listarray[i] as AnyObject).value(forKey:"isbuying") as? Bool)!)
                        let drtype = String (((listarray[i] as AnyObject).value(forKey:"drtype") as! NSObject).description)
                        let custrefcode = String (((listarray[i] as AnyObject).value(forKey:"custrefcode") as! NSObject).description)
                        let salepersoncode = String (((listarray[i] as AnyObject).value(forKey:"salepersoncode") as! NSObject).description)
                        
                        self.insertDRmaster(dataareaid: dataareaid, drcode: drcode, drname: drname, mobileno: mobileno, alternateno: alternateno, emailid: emailid, address: address, pincode: pincode, city: city, stateid: stateid, dob: dob == "1900-01-01T00:00:00" ? "" : dob, doa: doa == "1900-01-01T00:00:00" ? "" : doa, isblocked: isblocked, ispurchaseing: ispurchaseing, ispriscription: ispriscription, CREATEDTRANSACTIONID: createdTransactionid, MODIFIEDTRANSACTIONID: modifiedTransationid, POST : "2", drspecialization: drspecialization, purchaseamt: purchaseamt, noofprescription: noofprescription, siteid: siteid, isbuying: isbuying, drtype: drtype, custrefcode: custrefcode, salepersoncode: salepersoncode)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "DRMASTER", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_HospitalMaster()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "DRMASTER",status: error as? String, datetime: self.getTodaydatetime())
            self.URL_HospitalMaster()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
                
            }}}
    
    func URL_HospitalMaster(){
        
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast(createdTransactionId as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(modifiedTransactionId as int)),'0')as MODIFIEDTRANSACTIONID from HospitalMaster"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
            
        }
        
        Alamofire.request(constant.Base_url + constant.URL_HospitalMasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
            
            switch response.result {
            case .success(let value): print("success==========> \(value)")
            
           // self.deleteHospitalMaster()
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{

                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let type = String (((listarray[i] as AnyObject).value(forKey:"type") as? Int)!)
                        let hoscode = String (((listarray[i] as AnyObject).value(forKey:"hoscode") as! NSObject).description)
                        let mobileno = String(((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let hosname = String(((listarray[i] as AnyObject).value(forKey:"hosname") as! NSObject).description)
                        let alternateno = String (((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String(((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        let purchasemgr = String (((listarray[i] as AnyObject).value(forKey:"purchasemgr") as! NSObject).description)
                        let authorisedperson = String (((listarray[i] as AnyObject).value(forKey:"authorisedperson") as! NSObject).description)
                        let degisnation = String (((listarray[i] as AnyObject).value(forKey:"degisnation") as! NSObject).description)
                        let bedcount = String(((listarray[i] as AnyObject).value(forKey:"bedcount") as? Double)!)
                        let category = String (((listarray[i] as AnyObject).value(forKey:"category") as! NSObject).description)
                        let sector = String (((listarray[i] as AnyObject).value(forKey:"sector") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let hospitaltype = String(((listarray[i] as AnyObject).value(forKey:"hospitaltype") as! NSObject).description)
                        let ispurchase = String (((listarray[i] as AnyObject).value(forKey:"ispurchase") as? Bool)!)
                        let purchmgrmobileno = String (((listarray[i] as AnyObject).value(forKey:"purchmgrmobileno") as! NSObject).description)
                        let authpersonmobileno = String (((listarray[i] as AnyObject).value(forKey:"authpersonmobileno") as! NSObject).description)
                        let monthlypurchase = String (((listarray[i] as AnyObject).value(forKey:"monthlypurchase") as? Double)!)
                        let custrefcode = String (((listarray[i] as AnyObject).value(forKey:"custrefcode") as! NSObject).description)
                        let salepersoncode = String (((listarray[i] as AnyObject).value(forKey:"salepersoncode") as! NSObject).description)
                        
                        self.insertHospitalMaster(DATAAREAID: dataareaid, TYPE: type, HOSCODE: hoscode, HOSNAME: hosname, MOBILENO: mobileno, ALTNUMBER: alternateno, EMAILID: emailid, CityID: cityid, ADDRESS: address, PINCODE: pincode, STATEID: stateid, ISBLOCKED: isblocked, CREATEDTRANSACTIONID: createdtransactionid, MODIFIEDTRANSACTIONID: modifiedtransactionid, POST: "2", PURCHASEMGR: purchasemgr, AUTHORISEDPERSON: authorisedperson, PURCHMGRMOBILENO: purchmgrmobileno, AUTHPERSONMOBILENO: authpersonmobileno, DEGISNATION: degisnation, BEDCOUNT: bedcount, CATEGORY: category, SITEID: siteid, HOSPITALTYPE: hospitaltype, ISPURCHASE: ispurchase, monthlypurchase: monthlypurchase, custrefcode: custrefcode, salepersoncode: salepersoncode)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "HospitalMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_HospitalDRLinking()
            }
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "HospitalMaster",status: error as? String, datetime: self.getTodaydatetime())
            self.URL_HospitalDRLinking()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_HospitalDRLinking(){

        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from HospitalDRLinking"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
            // + created! + "&MODIFIEDTRANSACTIONID=" + modified!
        }
        
        Alamofire.request(constant.Base_url + constant.URL_HospitalDRLinkingConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
             print("MasterURL="+constant.Base_url + constant.URL_HospitalDRLinkingConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let drcode = String (((listarray[i] as AnyObject).value(forKey:"drcode") as! NSObject).description)
                        let hospitalcode = String (((listarray[i] as AnyObject).value(forKey:"hospitalcode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int64)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int64)!)
                        
                        self.insertHospitalDRLinking(dataareaid: dataareaid, drcode: drcode, hospitalcode: hospitalcode, isblocked: isblocked, RECID: "", CREATEDBY: UserDefaults.standard.string(forKey: "usercode"), post: "2", CREATEDTRANSACTIONID: createdtransactionid, ModifiedTransactionId: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "HospitalDRLinking", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_Hospitaltype()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "HospitalDRLinking",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_Hospitaltype()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_Hospitaltype(){
        Alamofire.request(constant.Base_url + constant.URL_HospitaltypeConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteHospitaltype()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let typeid = String (((listarray[i] as AnyObject).value(forKey:"typeid") as! NSObject).description)
                        let typedesc = String (((listarray[i] as AnyObject).value(forKey:"typedesc") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int8)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int8)!)
                        
                        self.insertHospitalType(dataareaid: dataareaid, typeid: typeid, typedesc: typedesc, isblocked: isblocked, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "Hospitaltype", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_DRSpecialization()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "Hospitaltype",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_DRSpecialization()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_DRSpecialization(){
        Alamofire.request(constant.Base_url + constant.URL_DRSpecializationConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteDRSpecialization()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let sno = String (((listarray[i] as AnyObject).value(forKey:"s.no") as? Int8)!)
                        let typeid = String (((listarray[i] as AnyObject).value(forKey:"typeid") as! NSObject).description)
                        let typedesc = String (((listarray[i] as AnyObject).value(forKey:"typedesc") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as! NSObject).description)
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int8)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int8)!)
                        let drtypeid = String (((listarray[i] as AnyObject).value(forKey:"drtypeid") as! NSObject).description)
                        
                        
                        self.insertDRSpecialization(sno: sno, typeid: typeid, typedesc: typedesc, isblocked: isblocked, status: status, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid,drtypeid : drtypeid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "DRSpecialization", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetHospitalSpecialization()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "DRSpecialization",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetHospitalSpecialization()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GetHospitalSpecialization(){
        let url = getHospitalSpecializationData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
//                self.deletehospitalspecialization()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let typeid = String (((listarray[i] as AnyObject).value(forKey:"typeid") as! NSObject).description)
                        let typedesc = String (((listarray[i] as AnyObject).value(forKey:"typedesc") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as! NSObject).description)
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int8)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int8)!)
                        
                          self.updateHospitalSpecializationData(dataareaid: dataareaid, typeid: typeid, typedesc: typedesc, isblocked: isblocked, status: status, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)

                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "hospitalspecialization", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_DRType()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "hospitalspecialization",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_DRType()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_DRType(){
        let url = getDRTYPEDATA()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                //self.deleteDRType()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let sno = String (((listarray[i] as AnyObject).value(forKey:"s.no") as? Int8)!)
                        let typeid = String (((listarray[i] as AnyObject).value(forKey:"typeid") as! NSObject).description)
                        let typedesc = String (((listarray[i] as AnyObject).value(forKey:"typedesc") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as! NSObject).description)
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int8)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int8)!)
                        let ismandatory = String (((listarray[i] as AnyObject).value(forKey:"ismandatory") as? Bool)!)
                        
                        self.updateDRTYPEDATA(sno: sno, typeid: typeid, typedesc: typedesc, isblocked: isblocked, status: status, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, ismandatory: ismandatory)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "DRType", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GETUSERMYPERFORMANCE()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "DRType",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GETUSERMYPERFORMANCE()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    //
    
    func URL_GETUSERMYPERFORMANCE(){
        Alamofire.request(constant.Base_url + constant.URL_GETUSERMYPERFORMANCEConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteUSERMYPERFORMANCE()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let total = String (((listarray[i] as AnyObject).value(forKey:"total") as? Int32)!)
                        let tynorp = String (((listarray[i] as AnyObject).value(forKey:"tynorp") as? Int32)!)
                        let tynorn = String (((listarray[i] as AnyObject).value(forKey:"tynorn") as? Int32)!)
                        let ptarget = String (((listarray[i] as AnyObject).value(forKey:"ptarget") as? Double)!)
                        let pachivement = String (((listarray[i] as AnyObject).value(forKey:"pachivement") as? Double)!)
                        let starget = String (((listarray[i] as AnyObject).value(forKey:"starget") as? Double)!)
                        let sachivement = String (((listarray[i] as AnyObject).value(forKey:"sachivement") as? Double)!)
                        
                        self.insertMyperformance(usercode: usercode, total: total, tynorp: tynorp, tynorn: tynorn, ptarget: ptarget, pachivement: pachivement, starget: starget, sachivement: sachivement)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "Hospitaltype", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetUserNoOrderPerformance()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "Hospitaltype",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetUserNoOrderPerformance()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    func URL_GetUserNoOrderPerformance(){
        Alamofire.request(constant.Base_url + constant.URL_GetUserNoOrderPerformanceConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteUserNoOrderPerformance()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let reasondescription = String (((listarray[i] as AnyObject).value(forKey:"reasondescription") as! NSObject).description)
                        let noofcount = String (((listarray[i] as AnyObject).value(forKey:"noofcount") as? Int8)!)
                        
                        
                        self.insertUserNoOrderPerformance(usercode: usercode, reasondescription: reasondescription, noofcount: noofcount)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "Hospitaltype", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetReasonMaster()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "Hospitaltype",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetReasonMaster()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}

    func URL_GetReasonMaster(){
        
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast(CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTRANSACTIONID as int)),'0')as ModifiedTransactionId from VW_PREFERREDREASONMASTER"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
            
        }
        
        Alamofire.request(constant.Base_url + constant.URL_GetReasonMasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
             //   self.deleteprereasonmaster()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let reasonid = String (((listarray[i] as AnyObject).value(forKey:"reasonid") as! NSObject).description)
                        let reasonremarks = String (((listarray[i] as AnyObject).value(forKey:"reasonremarks") as! NSObject).description)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                       
                       
                        self.insertpreresionmaster(dataareaid: dataareaid ,reasonid: reasonid, reasonremarks: reasonremarks, CREATEDTRANSACTIONID: createdtransactionid, ModifiedTRANSACTIONID: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "VW_PREFERREDREASONMASTER", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetCusthospitalLinking()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "VW_PREFERREDREASONMASTER",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetCusthospitalLinking()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GetCusthospitalLinking(){
        let url = getCustHospitalLinkingData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            print("MasterURL="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                //                self.deleteCUSTHOSPITALLINKING()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let hospitalcode = String (((listarray[i] as AnyObject).value(forKey:"hospitalcode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        
                        self.updateCustHospitalLinkingData(dataareaid: dataareaid, siteid: siteid, customercode: customercode, hospitalcode: hospitalcode, isblocked: isblocked, createdtransactionid:createdtransactionid , modifiedtransactionid: modifiedtransactionid, post: "2")
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "CUSTHOSPITALLINKING", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_Getsalelinkcity()
            }
                break
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "CUSTHOSPITALLINKING",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_Getsalelinkcity()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_Getsalelinkcity(){
        Alamofire.request(constant.Base_url + constant.URL_GetsalelinkcityConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deletesalelinkcity()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let usertype = String (((listarray[i] as AnyObject).value(forKey:"usertype") as? Int)!)
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let locationtype = String (((listarray[i] as AnyObject).value(forKey:"locationtype") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        
                        
                        self.insertsalelinkcity(usercode: usercode, usertype: usertype, cityid: cityid, locationtype: locationtype, isblocked: isblocked, createdid: createdtransactionid, modifiedid: modifiedtransactionid, stateid: stateid)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "salelinkcity", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetUserDistributorList()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "salelinkcity",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetUserDistributorList()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GetUserDistributorList(){
        Alamofire.request(constant.Base_url + constant.URL_GetUserDistributorListConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteUserdistributorlist()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{

                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as! NSObject).description)
                        let salepercent = String (((listarray[i] as AnyObject).value(forKey:"salepercent") as? Double)!)
                        let isdisplay = String (((listarray[i] as AnyObject).value(forKey:"isdisplay") as? Bool)!)
                        
                        self.insertUserdistributorlist(siteid: siteid, usercode: usercode, salepercent: salepercent, isdisplay: isdisplay)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "USERDISTRIBUTORLIST", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
                self.URL_GetTrainingDetail()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "USERDISTRIBUTORLIST",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetTrainingDetail()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func URL_GetTrainingDetail(){
        Alamofire.request(constant.Base_url + constant.URL_GetTrainingDetailConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteTrainingdetail()
                self.deleteusertrainings()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{

                        var post: String!
                        let trainingid = String (((listarray[i] as AnyObject).value(forKey:"trainingid") as! NSObject).description)
                        let trainingdate = String (((listarray[i] as AnyObject).value(forKey:"trainingdate") as! NSObject).description)
                        let trainedby = String (((listarray[i] as AnyObject).value(forKey:"trainedby") as! NSObject).description)
                        let trainedto = String (((listarray[i] as AnyObject).value(forKey:"trainedto") as! NSObject).description)
                        let trainingstarttime = String (((listarray[i] as AnyObject).value(forKey:"trainingstarttime") as! NSObject).description)
                        var trainingendtime = String (((listarray[i] as AnyObject).value(forKey:"trainingendtime") as! NSObject).description)
                        let remarks = String (((listarray[i] as AnyObject).value(forKey:"remarks") as! NSObject).description)
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as! NSObject).description)
                        let trainedtoname = String (((listarray[i] as AnyObject).value(forKey:"trainedtoname") as! NSObject).description)
                        
                        if trainingendtime == "<null>" && trainingstarttime != "" && status == "0"
                        {
                            post = "1"
                            trainingendtime = ""
                        }
                        else if trainingstarttime != "" && trainingendtime != "<null>" && status == "1"
                        {
                            post = "2"
                        }
                        else
                        {
                            post = "0"
                        }
                       
                        self.inserttariningdetail(TRAININGID: trainingid, DATAAREAID: "7200", TRAININGDATE: trainingdate, TRAINEDTO: trainedto, TRAININGSTARTTIME: trainingstarttime, TRAININGENDTIME: trainingendtime, REMARKS: remarks, USERCODE: trainedby, USERTYPE: "", ISMOBILE: "1", POST: post, status: status,Trainedtoname: trainedtoname)
                        
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "TrainingDetail", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
//                self.URL_GETUSERTAXSETUP()
                self.alert.dismiss(animated: true, completion: {
                    //  self.callback()
                    if self.alertbool {
                        SwiftEventBus.post("downloaded")
//                        self.gotohome()
                        SwiftEventBus.post("refreshdashboard")
                    }
                    else
                    {
                        SwiftEventBus.post("logincall")
                    }
                    
                })
            }
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "TrainingDetail", status: error.localizedDescription, datetime: self.getTodaydatetime())
            //            self.callback()
            
            self.alert.dismiss(animated: true, completion: {
                //  self.callback()
                if self.alertbool {
                    SwiftEventBus.post("downloaded")
//                    self.gotohome()
                }
                else
                {
                    SwiftEventBus.post("logincall")
                }
            })
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            
            }
            
        }
        
    }
    func URL_GetTrainingDetailbck(){
        Alamofire.request(constant.Base_url + constant.URL_GetTrainingDetailConst()).validate().responseJSON {
            response in
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteTrainingdetail()
                self.deleteusertrainings()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        var post: String!
                        let trainingid = String (((listarray[i] as AnyObject).value(forKey:"trainingid") as! NSObject).description)
                        let trainingdate = String (((listarray[i] as AnyObject).value(forKey:"trainingdate") as! NSObject).description)
                        let trainedby = String (((listarray[i] as AnyObject).value(forKey:"trainedby") as! NSObject).description)
                        let trainedto = String (((listarray[i] as AnyObject).value(forKey:"trainedto") as! NSObject).description)
                        let trainingstarttime = String (((listarray[i] as AnyObject).value(forKey:"trainingstarttime") as! NSObject).description)
                        var trainingendtime = String (((listarray[i] as AnyObject).value(forKey:"trainingendtime") as! NSObject).description)
                        let remarks = String (((listarray[i] as AnyObject).value(forKey:"remarks") as! NSObject).description)
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as! NSObject).description)
                        let trainedtoname = String (((listarray[i] as AnyObject).value(forKey:"trainedtoname") as! NSObject).description)
                        
                        if trainingendtime == "<null>" && trainingstarttime != "" && status == "0"
                        {
                            post = "1"
                            trainingendtime = ""
                        }
                        else if trainingstarttime != "" && trainingendtime != "<null>" && status == "1"
                        {
                            post = "2"
                        }
                        else
                        {
                            post = "0"
                        }
                        
                        self.inserttariningdetail(TRAININGID: trainingid, DATAAREAID: "7200", TRAININGDATE: trainingdate, TRAINEDTO: trainedto, TRAININGSTARTTIME: trainingstarttime, TRAININGENDTIME: trainingendtime, REMARKS: remarks, USERCODE: trainedby, USERTYPE: "", ISMOBILE: "1", POST: post, status: status,Trainedtoname: trainedtoname)
                        
                    }
                    self.updatelog(tablename: "TrainingDetail", status: "success", datetime: self.getTodaydatetime())
                    SwiftEventBus.post("trainingdone")
                }
            }
                break
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "TrainingDetail",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
            SwiftEventBus.post("trainingdonenot")
                break
            }}}
    
    func URL_GETUSERTAXSETUP(){
         let url = getUserTaxSetupData()
//        constant.URL_GETUSERTAXSETUPConst() = "GETUSERTAXSETUP?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")!
//        getUserTaxSetupData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            print("kkkk")
            switch response.result {
            case .success(let value):
                print("success=======\(value)")
            if  let json = response.result.value{
 
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let srl = String (((listarray[i] as AnyObject).value(forKey:"srl") as? Int)!)
                        let hsncode = String (((listarray[i] as AnyObject).value(forKey:"hsncode") as! NSObject).description)
                        let itemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as! NSObject).description)
                        let fromstateid = String (((listarray[i] as AnyObject).value(forKey:"fromstateid") as! NSObject).description)
                        let tostateid = String (((listarray[i] as AnyObject).value(forKey:"tostateid") as! NSObject).description)
                        let taxserialno = String (((listarray[i] as AnyObject).value(forKey:"taxserialno") as? Int)!)
                        let taxcomponentid = String (((listarray[i] as AnyObject).value(forKey:"taxcomponentid") as! NSObject).description)
                        let taxper = String (((listarray[i] as AnyObject).value(forKey:"taxper") as? Double)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as! NSObject).description)
                        
                        self.updateUserTaxSetupData(srl: srl, hsncode: hsncode, dataareaid: "", fromstateid: fromstateid, tostateid: tostateid, taxserialno: taxserialno, taxcomponentid: taxcomponentid, taxper: taxper, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "usertaxsetup", status: "success", datetime: self.getTodaydatetime())
                }
            }
                print("pricelist called===========")
                self.URL_GetUserPriceList()
                break

            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "usertaxsetup", status: error.localizedDescription, datetime: self.getTodaydatetime())
            SwiftEventBus.post("nottaxsetup")
                break
            }
        }
    }
    func callback(){
        
    }
    
    func getDRTYPEDATA() -> String{
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from DRType"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW)
        {
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            print("URL_DRType = \(constant.URL_DRTypeConst())")
            
            return constant.URL_DRTypeConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else {
            return constant.URL_DRTypeConst()
        }
    }
    
    func updateDRTYPEDATA(sno: String,typeid: String, typedesc: String, isblocked: String,status: String,createdtransactionid: String, modifiedtransactionid: String, ismandatory: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from DRType  where typeid ='\(typeid)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            print("data being updated in Table DRTYPE ")
            
            let query = "update DRType set sno ='\(sno)',typedesc ='\(typedesc)',status ='\(status)', isblocked ='\(isblocked)',createdtransactionid ='\(createdtransactionid)', modifiedtransactionid ='\(modifiedtransactionid)',ismandatory ='\(ismandatory)' where typeid ='\(typeid)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("data not updated in Table DRTYPE" )
                return
            }
        }
        else {
            print("data inserted in Table DRTYPEDATA  ")
            self.insertDRType(sno: sno, typeid: typeid, typedesc: typedesc, isblocked: isblocked, status: status, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, ismandatory: ismandatory)
        }

    }
    func getUserDRCUSTLinkingData() -> String
    {
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from userDRCustLinking"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
          }
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            if(AppDelegate.isDebug){
            print("URL_userDR = \(constant.URL_userDRConst())")
            }
            return constant.URL_userDRConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
            
        }else{
            return constant.URL_userDRConst()
        }
    }
    
    func updateUserDrcustlinking1(dataareaid: String? ,siteid: String?,customercode: String? ,drcode: String? ,isblocked: String? ,ispurchaseing: String?,ispriscription: String? ,createdtransactionid: String?,modifiedtransactionid: String?,post: String?)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from userDRCustLinking where customercode = '\(customercode!)'and drcode = '\(drcode!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        
        let query = "update userDRCustLinking set dataareaid = '\(dataareaid!)' , siteid = '\(siteid!)' ,isblocked = '\(isblocked!)'  ,ispurchaseing = '\(ispurchaseing!)' ,ispriscription = '\(ispriscription!)' ,createdtransactionid = '\(createdtransactionid!)' ,modifiedtransactionid = '\(modifiedtransactionid!)' ,post = '\(post!)' where customercode = '\(customercode!)'and drcode = '\(drcode!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table Userdrlinking ")
            return
            }}
        else{
            self.insertuserDR(dataareaid: dataareaid, siteid: siteid, customercode: customercode, drcode: drcode, isblocked: isblocked, ispurchaseing: ispurchaseing,ispriscription: ispriscription ,createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2")
        }
    }

    
    func updateUserDrcustlinking(dataareaid: String? ,siteid: String?,customercode: String? ,drcode: String? ,isblocked: String? ,ispurchaseing: String?,ispriscription: String? ,createdtransactionid: String?,modifiedtransactionid: String?,post: String?)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from userDRCustLinking where customercode = '\(customercode!)'and drcode = '\(drcode!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        
        let query = "update userDRCustLinking set dataareaid = '\(dataareaid!)' , siteid = '\(siteid!)' ,isblocked = '\(isblocked!)'  ,ispurchaseing = '\(ispurchaseing!)' ,ispriscription = '\(ispriscription!)' ,createdtransactionid = '\(createdtransactionid!)' ,modifiedtransactionid = '\(modifiedtransactionid!)' ,post = '\(post!)' where customercode = '\(customercode!)'and drcode = '\(drcode!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table Userdrlinking ")
            return
            }}
        else{
            self.insertuserDR(dataareaid: dataareaid, siteid: siteid, customercode: customercode, drcode: drcode, isblocked: isblocked, ispurchaseing: ispurchaseing,ispriscription: ispriscription ,createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "0")
        }
    }
    
    func getDealerConvertData() -> String {
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from SubDealers"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
      
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            
            print("URL_GETDealerConvert = \(constant.URL_GETDealerConvertConst())")
            return constant.URL_GETDealerConvertConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_GETDealerConvertConst()
        }
    }
    func updateDealerConvertData(customercode: String, expectedsale: String, expectedDiscount: String, dataareaid: String, recid: String, submitdate: String, status: String, approvedby: String, siteid: String, createdtransactionid: String, modifiedtransactionid: String, post: String)
    {
        
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from subdealers  where customercode = '\(customercode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        let query = "update subdealers set expectedsale = '\(expectedsale)',expectedDiscount = '\(expectedDiscount)',dataareaid = '\(dataareaid)',recid = '\(recid)',submitdate = '\(submitdate)',status = '\(status)',approvedby = '\(approvedby)',siteid = '\(siteid)',createdtransactionid = '\(createdtransactionid)',modifiedtransactionid = '\(modifiedtransactionid)',post = '\(post)' where customercode = '\(customercode)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting Table DealerConvertData ")
            return
            }}
        else{
            self.insertsubdealers(customercode: customercode as NSString, expectedsale: expectedsale as NSString, expectedDiscount: expectedDiscount as NSString, dataareaid: dataareaid as NSString, recid: recid as NSString, submitdate: submitdate as NSString, status: status as NSString, approvedby: approvedby as NSString, siteid: siteid as NSString, createdtransactionid: createdtransactionid as NSString, modifiedtransactionid: modifiedtransactionid as NSString, post: "2")
        }
    }
    func getUserLinkCityData() -> String{
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from UserLinkCity"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
      
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            print("URL_userlinkedcity = \(constant.URL_userlinkedcityConst())")
            
            return constant.URL_userlinkedcityConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }else{
            return constant.URL_userlinkedcityConst()
        }
        
    }
    func updateUserLinkCityData(cityid: String ,locationtype: String ,dataareaid: String,isblocked: String ,createdtransactionid: String ,modifiedtransactionid: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from UserLinkCity where cityid ='\(cityid)' and locationtype ='\(locationtype)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        
        let query = " update UserLinkCity dataareaid ='\(dataareaid)',isblocked ='\(isblocked)',createdtransactionid ='\(createdtransactionid)',modifiedtransactionid ='\(modifiedtransactionid)' where cityid ='\(cityid)' and locationtype ='\(locationtype)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting Table UserLinkCityData ")
            return
            }}
        else
        {
            self.insertuserlinkedcity(cityid: cityid as NSString, locationtype: locationtype as NSString, dataareaid: dataareaid as NSString, isblocked: isblocked as NSString, createdtransactionid: createdtransactionid as NSString, modifiedtransactionid: modifiedtransactionid as NSString)
        }
    }
    func getNorderReasonData() -> String{
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from NoOrderReasonMaster"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
      
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            print("URL_GetNoOrderReasion = \(constant.URL_GetNoOrderReasionConst())")
            
            return constant.URL_GetNoOrderReasionConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_GetNoOrderReasionConst()
        }
    }
    func updatenoOrderreason(reasoncode: String ,reasondescription: String ,createdtransactionid: String,modifiedtransactionid: String ,isblock: String ,recid: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from NoOrderReasonMaster where reasoncode ='\(reasoncode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        
        let query =  "update NoOrderReasonMaster set recid ='\(recid)', reasondescription ='\(reasondescription)' ,createdtransactionid ='\(createdtransactionid)', modifiedtransactionid ='\(modifiedtransactionid)' , isblock ='\(isblock)' where reasoncode ='\(reasoncode)'  "
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table NoorderReason  ")
            return
            }}
            
        else
        {
            self.insertnoorder(reasoncode: reasoncode as NSString, reasondescription: reasondescription as NSString, createdtransactionid: createdtransactionid as NSString, modifiedtransactionid: modifiedtransactionid as NSString, isblock: isblock as NSString, recid: recid as NSString)
        }
        print("Update Table NoOrderReasonMaster  Successfully")
    }
    
    func getEscalationReasonData() -> String{
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from EscalationReason"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
    
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            print("URL_getreasonmaster = \(constant.URL_getescalationreasonConst())")
            
            return constant.URL_getescalationreasonConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_getescalationreasonConst()
        }
    }
    func updateEscalationReasonData(reasoncode: String ,reasondescription: String ,createdtransationid: String ,modifiedtransactionid: String ,isblock: String,recid: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from EscalationReason where reasoncode ='\(reasoncode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        
        let query = "update EscalationReason set reasondescription ='\(reasondescription)',CREATEDTRANSACTIONID ='\(createdtransationid)',ModifiedTransactionId ='\(modifiedtransactionid)',isblock ='\(isblock)', recid ='\(recid)' where  reasoncode ='\(reasoncode)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting Table EscalationReasonData  ")
            return
            }}
        else{
            self.insertreasonmaster(reasoncode: reasoncode as NSString, reasondescription: reasondescription as NSString, createdtransationid: createdtransationid as NSString, modifiedtransactionid: modifiedtransactionid as NSString, isblock: isblock as NSString, recid: recid as NSString)
        }
    }
    func getHospitalSpecializationData() -> String{
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from hospitalspecialization"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
  
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            
            print("URL_GetHospitalSpecialization = \(constant.URL_GetHospitalSpecializationConst())")
            return constant.URL_GetHospitalSpecializationConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_GetHospitalSpecializationConst()
        }
    }
    func updateHospitalSpecializationData(dataareaid: String,typeid: String, typedesc: String, isblocked: String,status: String,createdtransactionid: String, modifiedtransactionid: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from hospitalspecialization where typeid ='\(typeid)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        let query = "update hospitalspecialization set dataareaid ='\(dataareaid)',typedesc ='\(typedesc)',isblocked ='\(isblocked)', status ='\(status)', createdtransactionid ='\(createdtransactionid)', modifiedtransactionid ='\(modifiedtransactionid)' where typeid ='\(typeid)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting Table hospitalspecialization  ")
            return
            }}
        else
        {
            self.inserthospitalspecialization(dataareaid: dataareaid, typeid: typeid, typedesc: typedesc, isblocked: isblocked, status: status, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
        }
    }
    
    func getObjectionMasterData() -> String {
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from ObjectionMaster"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
       
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            print("URL_Objectionmaster = \(constant.URL_ObjectionmasterConst())")
            return constant.URL_ObjectionmasterConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_ObjectionmasterConst()
        }
    }
    func updateObjectionMasterData(objectioncode: String, objectiondesc: String, isblocked: String, createdtransactionid: String,modifiedtransactionid: String,status: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from ObjectionMaster where objectioncode ='\(objectioncode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        let query = "update ObjectionMaster set objectiondesc ='\(objectiondesc)',createdtransactionid ='\(createdtransactionid)',modifiedtransactionid ='\(modifiedtransactionid)',status ='\(status)',isblocked ='\(isblocked)' where objectioncode ='\(objectioncode)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting Table ObjectionMasterData")
            return
            }}
        else
        {
            self.insertObjectionmaster(objectioncode: objectioncode as NSString, objectiondesc: objectiondesc as NSString, isblocked: isblocked as NSString, createdtransactionid: createdtransactionid as NSString, modifiedtransactionid: modifiedtransactionid as NSString, status: status as NSString)
        }
    }
    
    func getretailermasterdata() -> String{
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from RetailerMaster"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
        }

        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            if(AppDelegate.isDebug){
            print("retailer = \(constant.URL_retailermasterConst())")
            }
            return constant.URL_retailermasterConst()  + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)&ISMOBILE=1"
           
        }
        else{
            return constant.URL_retailermasterConst()
        }
    }
    func getCustHospitalLinkingData() -> String{
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from CUSTHOSPITALLINKING"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
        }
        }

        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            if(AppDelegate.isDebug){
            print("URL_GetCusthospitalLinking = \(constant.URL_GetCusthospitalLinkingConst())")
            }
            return constant.URL_GetCusthospitalLinkingConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)&ISMOBILE=1"
        }
        else{
            return constant.URL_GetCusthospitalLinkingConst() + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0&ISMOBILE=1"
        }
    }
    
    func getuserCompetitorURL() -> String{
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (createdtransactionid as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(modifiedtransactionid as int)),'0')as ModifiedTransactionId from COMPETITORDETAILPOST"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
        }
        }

        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            if(AppDelegate.isDebug){
                print("getuserCompetitorURL = \(constant.URL_getusercompetitorConst())")
            }
            return constant.URL_getusercompetitorConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return  constant.URL_getusercompetitorConst() + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
        }
    }
    
    
    func updateCustHospitalLinkingData(dataareaid: String,siteid: String, customercode: String, hospitalcode: String, isblocked: String, createdtransactionid: String, modifiedtransactionid: String, post: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from CUSTHOSPITALLINKING where CUSTOMERCODE ='\(customercode)' and HOSPITALCODE ='\(hospitalcode)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
        let query = "update CUSTHOSPITALLINKING set DATAAREAID ='\(dataareaid)', SITEID ='\(siteid)', ISBLOCKED ='\(isblocked)', CREATEDTRANSACTIONID ='\(createdtransactionid)',modifiedtransactionid ='\(modifiedtransactionid)',post ='\(post)' where CUSTOMERCODE ='\(customercode)' and HOSPITALCODE ='\(hospitalcode)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting Table CustHospitalLinkingData")
            return
            }}
        else
        {
            self.insertCUSTHOSPITALLINKING(dataareaid: dataareaid, siteid: siteid, customercode: customercode, hospitalcode: hospitalcode, isblocked: isblocked, createdtransactionid: "2", modifiedtransactionid: "0", post: post)
        }
    }
    func updateUserTaxSetupData(srl: String, hsncode: String, dataareaid: String, fromstateid: String, tostateid: String, taxserialno: String, taxcomponentid: String, taxper: String,createdtransactionid: String, modifiedtransactionid: String)
    {
        var stmt1: OpaquePointer? = nil
        
        let q = "select * from usertaxsetup where hsncode = '\(hsncode)' and fromstateid = '\(fromstateid)' and tostateid = '\(tostateid)' and taxserialno = '\(taxserialno)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update usertaxsetup set srl = '\(srl)' , dataareaid = '\(dataareaid)',taxcomponentid = '\(taxcomponentid)',taxper = '\(taxper)' ,createdtransactionid = '\(createdtransactionid)',modifiedtransactionid = '\(modifiedtransactionid)' where hsncode = '\(hsncode)' and fromstateid = '\(fromstateid)' and tostateid = '\(tostateid)' and taxserialno = '\(taxserialno)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("data not updated in Table DRTYPE" )
                return
            }
        }
        else {
            print("inserting in Table UserTaxSetupData ")
            self.insertTaxSetup(srl: srl as NSString, hsncode: hsncode as NSString, dataareaid: "" as NSString , fromstateid: fromstateid as NSString, tostateid: tostateid as NSString, taxserialno: taxserialno as NSString, taxcomponentid: taxcomponentid as NSString, taxper: taxper as NSString, createdtransactionid: createdtransactionid as NSString, modifiedtransactionid: modifiedtransactionid as NSString)
        }
        
    }
    func getUserTaxSetupData() -> String{
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from usertaxsetup"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
           
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            
          return  constant.URL_GETUSERTAXSETUPConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)&ISMOBILE=1"
            
        }
        else{
            return  constant.URL_GETUSERTAXSETUPConst()
        }
    }
    
    func getpricetabledata() -> String{
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(modifiedtransactionId as int)),'0')as ModifiedTransactionId from UserPriceList"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            
            print("URL_GetUserPriceList = \(constant.URL_GetUserPriceListConst())")
            
            return constant.URL_GetUserPriceListConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_GetUserPriceListConst()
        }
    }
    
    func getcompetitortabledata() -> String{
        
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (createdtransactionid as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(modifiedtransactionId as int)),'0')as ModifiedTransactionId from COMPETITORDETAIL"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
            if(AppDelegate.isDebug){
            print("URL_getcompetitor = \(constant.URL_getcompetitorConst())")
            }
            return constant.URL_getcompetitorConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_getcompetitorConst() + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0"
        }
    }

    
    func updatepricelist(srl: String , datareaid: String, pricegroupid: String ,itemid: String,uom: String ,price: String, mrp: String,createdtransactionid: String,modifiedtransactionid: String){
        var stmt1: OpaquePointer? = nil
        let q = "select * from UserPriceList where pricegroupid = '\(pricegroupid)' and itemid = '\(itemid)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update UserPriceList set srl = '\(srl)',dataareaid = '\(datareaid)', pricegroupid = '\(pricegroupid)',itemid = '\(itemid)', price = '\(price)', uom = '\(uom)', mrp = '\(mrp)',createdtransactionid = '\(createdtransactionid)',modifiedtransactionid = '\(modifiedtransactionid)' where pricegroupid = '\(pricegroupid)' and itemid = '\(itemid)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("data not updated in Table UserPriceList" )
                return
            }
        }
            
        else {
            self.insertPriceList(srl: srl, dataareaid: datareaid, pricegroupid: pricegroupid, itemid: itemid, price: price, uom: uom, mrp: mrp, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
        }
    }
    func getitemmasterdata() -> String{
        var stmt1:OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from ItemMaster"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
       
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 0))
            let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 1))
             print("ItemMaster = \(constant.URL_ITEMMASTERConst)")
            
            return constant.URL_ITEMMASTERConst() + "&CREATEDTRANSACTIONID=\(CREATEDTRANSACTIONID)&MODIFIEDTRANSACTIONID=\(MODIFIEDTRANSACTIONID)"
        }
        else{
            return constant.URL_ITEMMASTERConst()
        }
    }

    func updateitemmaster(itemgroup: String, itemsubgroup: String, itemgroupid: String, itemid: String, itemname: String, itemmrp: String, itempacksize: String, itemvarriantsize: String, uom: String, barcode: String, createdTransactionId: String, modifiedTransactionId: String, hsncode: String, isexempt: String, isblocked: String, ispcsapply: String, itembuyergroupid: String){
        var stmt1: OpaquePointer? = nil
        let q = "select * from ItemMaster where itemid = '\(itemid)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "update ItemMaster set itemgroup = '\(itemgroup)' ,itemsubgroup = '\(itemsubgroup)',itemgroupid = '\(itemgroupid)',itemid = '\(itemid)',itemname = '\(itemname)',itemmrp = '\(itemmrp)',itempacksize = '\(itempacksize)',itemvarriantsize = '\(itemvarriantsize)',uom = '\(uom)',barcode = '\(barcode)',createdTransactionId = '\(createdTransactionId)',modifiedTransactionId= '\(modifiedTransactionId)',hsncode= '\(hsncode)',isexempt= '\(isexempt)',isblocked= '\(isblocked)',ispcsapply= '\(ispcsapply)',itembuyergroupid= '\(itembuyergroupid)' where itemid = '\(itemid)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("data not updated in Table ItemMaster" )
                return
            }
        }
        else {
            self.insertItemmaster(itemgroup: itemgroup , itemsubgroup: itemsubgroup , itemgroupid: itemgroupid  , itemid: itemid , itemname: itemname , itemmrp: itemmrp , itempacksize: itempacksize , itemvarriantsize: itemvarriantsize , uom: uom , barcode: barcode , createdTransactionId: createdTransactionId , modifiedTransactionId: modifiedTransactionId , hsncode: hsncode , isexempt: isexempt , isblocked: isblocked , ispcsapply: ispcsapply , itembuyergroupid: itembuyergroupid )
        }
    }
    
    func retailermaster1(){
        let url = getretailermasterdata()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
           
            response in
            print("MasterURL==="+constant.Base_url + url)
            print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {

                    for i in 0..<listarray.count{
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let customername = String (((listarray[i] as AnyObject).value(forKey:"customername") as! NSObject).description)
                        let customertype = String (((listarray[i] as AnyObject).value(forKey:"customertype") as! NSObject).description)
                        let contactperson = String (((listarray[i] as AnyObject).value(forKey:"contactperson") as! NSObject).description)
                        let mobilecustcode = String (((listarray[i] as AnyObject).value(forKey:"mobilecustcode") as! NSObject).description)
                        let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let alternateno = String (((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        var gstno = String (((listarray[i] as AnyObject).value(forKey:"gstno")  as! NSObject).description)
                        if gstno == "<null>"{
                            gstno = ""
                        }
                        let gstregistrationdate = String (((listarray[i] as AnyObject).value(forKey:"gstregistrationdate") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let salepersonid = String (((listarray[i] as AnyObject).value(forKey:"salepersonid") as! NSObject).description)
                        let keycustomer = String (((listarray[i] as AnyObject).value(forKey:"keycustomer") as? Bool)!)
                        let isorthopositive = String (((listarray[i] as AnyObject).value(forKey:"isorthopositive") as? Bool)!)
                        let sizeofretailer = String (((listarray[i] as AnyObject).value(forKey:"sizeofretailer") as! NSObject).description)
                        let category = String (((listarray[i] as AnyObject).value(forKey:"category") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let latitude = String (((listarray[i] as AnyObject).value(forKey:"latitude") as! NSObject).description)
                        let longitude = String (((listarray[i] as AnyObject).value(forKey:"longitude") as! NSObject).description)
                        let orthopedicsale = String (((listarray[i] as AnyObject).value(forKey:"orthopedicsale") as? Double)!)
                        let avgsale = String (((listarray[i] as AnyObject).value(forKey:"avgsale") as? Double)!)
                        let prefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedbrand") as! NSObject).description)
                        let secprefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedbrand") as! NSObject).description)
                        let secprefferedsale = String (((listarray[i] as AnyObject).value(forKey:"secprefferedsale") as! NSObject).description)
                        let prefferedsale = String (((listarray[i] as AnyObject).value(forKey:"prefferedsale") as! NSObject).description)
                        let prefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"prefferedreasonid") as! NSObject).description)
                        let secprefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"secprefferedreasonid") as! NSObject).description)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int32)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int32)!)
                        let referencecode = String (((listarray[i] as AnyObject).value(forKey:"referencecode") as! NSObject).description)
                        let storeimage = String (((listarray[i] as AnyObject).value(forKey:"storeimage") as? Int32)!)
                        let stockimage = String (((listarray[i] as AnyObject).value(forKey:"stockimage") as? Int32)!)
                        let prefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedothbrand") as! NSObject).description)
                        let secprefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedothbrand") as! NSObject).description)
                        
                        self.updateretailermaster1(customercode: customercode, customername: customername, customertype: customertype, contactperson: contactperson, mobilecustcode: mobilecustcode, mobileno: mobileno, alternateno: alternateno, emailid: emailid, address: address, pincode: pincode, city: city, stateid: stateid, gstno: gstno, gstregistrationdate: gstregistrationdate, siteid: siteid, salepersonid: salepersonid, keycustomer: keycustomer, isorthopositive: isorthopositive, sizeofretailer: sizeofretailer, category: category, isblocked: isblocked, pricegroup: pricegroup, dataareaid: dataareaid, latitude: latitude, longitude: longitude, orthopedicsale: orthopedicsale, avgsale: avgsale, prefferedbrand: prefferedbrand, secprefferedbrand: secprefferedbrand, secprefferedsale: secprefferedsale, prefferedsale: prefferedsale, prefferedreasonid: prefferedreasonid, secprefferedreasonid: secprefferedreasonid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2", referencecode: referencecode, lastvisited: "", storeimage: storeimage, stockimage: stockimage, prefferedothbrand: prefferedothbrand, secprefferedothbrand: secprefferedothbrand)
                    }
                    self.updatelog(tablename: "RetailerMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.custHospitallinking1()
            }
            break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "RetailerMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.custHospitallinking1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }
         }
    }
    
    func custHospitallinking1(){
        let url = getCustHospitalLinkingData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                //                self.deleteCUSTHOSPITALLINKING()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let hospitalcode = String (((listarray[i] as AnyObject).value(forKey:"hospitalcode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        
                        self.updateCustHospitalLinkingData(dataareaid: dataareaid, siteid: siteid, customercode: customercode, hospitalcode: hospitalcode, isblocked: isblocked, createdtransactionid:"2" , modifiedtransactionid: "0", post: "2")
                    }
                    self.updatelog(tablename: "CUSTHOSPITALLINKING", status: "success", datetime: self.getTodaydatetime())
                }
                self.objectionmaster1()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "CUSTHOSPITALLINKING",status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.objectionmaster1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    func objectionmaster1(){
        let url = getObjectionMasterData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    //                    self.deleteObjectionMaster()
                    for i in 0..<listarray.count{
                        
                        let objectioncode = String (((listarray[i] as AnyObject).value(forKey:"objectioncode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let objectiondesc = String (((listarray[i] as AnyObject).value(forKey:"objectiondesc") as! NSObject).description)
                        
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as! NSObject).description)
                        
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                        self.updateObjectionMasterData(objectioncode: objectioncode, objectiondesc: objectiondesc, isblocked: isblocked, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, status: status)
                        
                    }
                    self.updatelog(tablename: "ObjectionMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.escalationReason1()
            }
            break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "ObjectionMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.escalationReason1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    
    func escalationReason1(){
        let url = getEscalationReasonData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
             print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
                
            case .success(let value):
                if constant.isDebug {
                    print("success=======\(value)")
                }
                if  let json = response.result.value{
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        //                        self.deleteEscalationReason()
                        for i in 0..<listarray.count{
                            let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                            let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as! NSObject).description)
                            let reasondescription = String (((listarray[i] as AnyObject).value(forKey:"reasondescription") as! NSObject).description).replacingOccurrences(of: "'", with: "")
                            let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                            let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                            //let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Bool)!)
                            let isblock = String (((listarray[i] as AnyObject).value(forKey:"isblock") as! NSObject).description)
                            
                            self.updateEscalationReasonData(reasoncode: reasoncode, reasondescription: reasondescription, createdtransationid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, isblock: isblock, recid: recid)
                        }
                        self.updatelog(tablename: "EscalationReason", status: "success", datetime: self.getTodaydatetime())
                    }
                    self.noOrderReason1()
                }
                
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "EscalationReason", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.noOrderReason1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    
    func noOrderReason1(){
        let url = getNorderReasonData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
             print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                        let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as! NSObject).description)
                        let reasondescription = String (((listarray[i] as AnyObject).value(forKey:"reasondescription") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as! NSObject).description)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                        self.updatenoOrderreason(reasoncode: reasoncode, reasondescription: reasondescription, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, isblock: isblocked, recid: recid)
                        
                    }
                    self.updatelog(tablename: "NoOrderReasonMaster", status: "success", datetime: self.getTodaydatetime())
                    
                }
                self.userlinkCity1()
            }
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "NoOrderReasonMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.userlinkCity1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    
    func userlinkCity1(){
        let url = getUserLinkCityData()
        
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
             print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    //  self.deleteUserLinkCity()
                    for i in 0..<listarray.count{
                        
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let locationtype = String (((listarray[i] as AnyObject).value(forKey:"locationtype") as! NSObject).description)
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                        self.updateUserLinkCityData(cityid: cityid, locationtype: locationtype, dataareaid: dataareaid, isblocked: isblocked, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                    }
                    constant.taxUpdate = false
                    self.updatelog(tablename: "UserLinkCity", status: "success", datetime: self.getTodaydatetime())
                }
                self.dealerConvertdata1()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "UserLinkCity", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.dealerConvertdata1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    
    func dealerConvertdata1(){
        let url = getDealerConvertData()
        
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
             print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                //                self.deletesubdealers()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let submitdate = String (((listarray[i] as AnyObject).value(forKey:"submitdate") as! NSObject).description)
                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Int)!)
                        let approvedby = String (((listarray[i] as AnyObject).value(forKey: "approvedby") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let expsale = String (((listarray[i] as AnyObject).value(forKey:"expsale") as? Double)!)
                        let expdiscount = String (((listarray[i] as AnyObject).value(forKey:"expdiscount") as? Double)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey: "modifiedtransactionid") as? Int)!)
                        
                        self.updateDealerConvertData(customercode: customercode, expectedsale: expsale, expectedDiscount: expdiscount, dataareaid: dataareaid, recid: recid, submitdate: submitdate, status: status, approvedby: approvedby, siteid: siteid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2")
                        
                    }
                    self.updatelog(tablename: "subdealers", status: "success", datetime: self.getTodaydatetime())
                }
               self.drmaster1()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "subdealers", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.drmaster1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    func drmaster1(){
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from DRMASTER"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
        }
        Alamofire.request(constant.Base_url + constant.URL_getuserdrmasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified! + "&ISMOBILE=1" ).validate().responseJSON {
            response in
 
            
            switch response.result {
            case .success(let value): print("success==========> \(value)")
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let drcode = String (((listarray[i] as AnyObject).value(forKey:"drcode") as! NSObject).description)
                        let drname = String (((listarray[i] as AnyObject).value(forKey:"drname") as! NSObject).description)
                        let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let alternateno = String(((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let city = String(((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let dob = String (((listarray[i] as AnyObject).value(forKey:"dob") as! NSObject).description)
                        let doa = String (((listarray[i] as AnyObject).value(forKey:"doa") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let ispurchaseing = String (((listarray[i] as AnyObject).value(forKey:"ispurchaseing") as? Bool)!)
                        let ispriscription = String(((listarray[i] as AnyObject).value(forKey:"ispriscription") as? Bool)!)
                        let drspecialization = String (((listarray[i] as AnyObject).value(forKey:"drspecialization") as! NSObject).description)
                        let purchaseamt = String(((listarray[i] as AnyObject).value(forKey:"purchaseamt") as? Double)!)
                        let noofprescription = String (((listarray[i] as AnyObject).value(forKey:"noofprescription") as? Double)!)
                        let createdTransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int64)!)
                        let modifiedTransationid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int64)!)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let isbuying = String(((listarray[i] as AnyObject).value(forKey:"isbuying") as? Bool)!)
                        let drtype = String (((listarray[i] as AnyObject).value(forKey:"drtype") as! NSObject).description)
                        let custrefcode = String (((listarray[i] as AnyObject).value(forKey:"custrefcode") as! NSObject).description)
                        let salepersoncode = String (((listarray[i] as AnyObject).value(forKey:"salepersoncode") as! NSObject).description)
                        
                        self.insertDRmaster1(dataareaid: dataareaid, drcode: drcode, drname: drname, mobileno: mobileno, alternateno: alternateno, emailid: emailid, address: address, pincode: pincode, city: city, stateid: stateid, dob: dob == "1900-01-01T00:00:00" ? "" : dob, doa: doa == "1900-01-01T00:00:00" ? "" : doa, isblocked: isblocked, ispurchaseing: ispurchaseing, ispriscription: ispriscription, CREATEDTRANSACTIONID: createdTransactionid, MODIFIEDTRANSACTIONID: modifiedTransationid, POST : "2", drspecialization: drspecialization, purchaseamt: purchaseamt, noofprescription: noofprescription, siteid: siteid, isbuying: isbuying, drtype: drtype, custrefcode: custrefcode, salepersoncode: salepersoncode)
                    }
                    self.updatelog(tablename: "DRMASTER", status: "success", datetime: self.getTodaydatetime())
                }
                self.hospitalMaster1()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "DRMASTER",status: error as? String, datetime: self.getTodaydatetime())
            self.hospitalMaster1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    func hospitalMaster1(){
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast(createdTransactionId as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(modifiedTransactionId as int)),'0')as MODIFIEDTRANSACTIONID from HospitalMaster"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
            
        }
        
        Alamofire.request(constant.Base_url + constant.URL_HospitalMasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
//            print("Masterurl==="+constant.Base_url + constant.URL_HospitalMaster + created! + "&MODIFIEDTRANSACTIONID=" + modified!)
//            print("RetailerListApi==="+constant.Base_url + constant.URL_HospitalMaster + created! + "&MODIFIEDTRANSACTIONID=" + modified!)

            switch response.result {
            case .success(let value): print("success==========> \(value)")
            
            // self.deleteHospitalMaster()
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let type = String (((listarray[i] as AnyObject).value(forKey:"type") as? Int)!)
                        let hoscode = String (((listarray[i] as AnyObject).value(forKey:"hoscode") as! NSObject).description)
                        let mobileno = String(((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let hosname = String(((listarray[i] as AnyObject).value(forKey:"hosname") as! NSObject).description)
                        let alternateno = String (((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String(((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        let purchasemgr = String (((listarray[i] as AnyObject).value(forKey:"purchasemgr") as! NSObject).description)
                        let authorisedperson = String (((listarray[i] as AnyObject).value(forKey:"authorisedperson") as! NSObject).description)
                        let degisnation = String (((listarray[i] as AnyObject).value(forKey:"degisnation") as! NSObject).description)
                        let bedcount = String(((listarray[i] as AnyObject).value(forKey:"bedcount") as? Double)!)
                        let category = String (((listarray[i] as AnyObject).value(forKey:"category") as! NSObject).description)
                        let sector = String (((listarray[i] as AnyObject).value(forKey:"sector") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let hospitaltype = String(((listarray[i] as AnyObject).value(forKey:"hospitaltype") as! NSObject).description)
                        let ispurchase = String (((listarray[i] as AnyObject).value(forKey:"ispurchase") as? Bool)!)
                        let purchmgrmobileno = String (((listarray[i] as AnyObject).value(forKey:"purchmgrmobileno") as! NSObject).description)
                        let authpersonmobileno = String (((listarray[i] as AnyObject).value(forKey:"authpersonmobileno") as! NSObject).description)
                        let monthlypurchase = String (((listarray[i] as AnyObject).value(forKey:"monthlypurchase") as? Double)!)
                        let custrefcode = String (((listarray[i] as AnyObject).value(forKey:"custrefcode") as! NSObject).description)
                        let salepersoncode = String (((listarray[i] as AnyObject).value(forKey:"salepersoncode") as! NSObject).description)
                        
                        self.insertHospitalMaster1(DATAAREAID: dataareaid, TYPE: type, HOSCODE: hoscode, HOSNAME: hosname, MOBILENO: mobileno, ALTNUMBER: alternateno, EMAILID: emailid, CityID: cityid, ADDRESS: address, PINCODE: pincode, STATEID: stateid, ISBLOCKED: isblocked, CREATEDTRANSACTIONID: createdtransactionid, MODIFIEDTRANSACTIONID: modifiedtransactionid, POST: "2", PURCHASEMGR: purchasemgr, AUTHORISEDPERSON: authorisedperson, PURCHMGRMOBILENO: purchmgrmobileno, AUTHPERSONMOBILENO: authpersonmobileno, DEGISNATION: degisnation, BEDCOUNT: bedcount, CATEGORY: category, SITEID: siteid, HOSPITALTYPE: hospitaltype, ISPURCHASE: ispurchase, monthlypurchase: monthlypurchase, custrefcode: custrefcode, salepersoncode: salepersoncode)
                    }
                    self.updatelog(tablename: "HospitalMaster", status: "success", datetime: self.getTodaydatetime())
                }
               self.superdealer1()
            }
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "HospitalMaster",status: error as? String, datetime: self.getTodaydatetime())
            self.superdealer1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    func superdealer1(){
        Alamofire.request(constant.Base_url + constant.URL_GETUSERDISTRIBUTORConst()).validate().responseJSON {
            response in
             print("RetailerListApi==="+constant.Base_url + constant.URL_GETUSERDISTRIBUTORConst())
            switch response.result {
                
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                self.deleteUSERDISTRIBUTOR ()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let sitename = String (((listarray[i] as AnyObject).value(forKey:"sitename") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let mobile = String (((listarray[i] as AnyObject).value(forKey:"mobile") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let statename = String (((listarray[i] as AnyObject).value(forKey:"statename") as! NSObject).description)
                        let salespersoncode = String (((listarray[i] as AnyObject).value(forKey:"salespersoncode") as! NSObject).description)
                        let gstinno = String (((listarray[i] as AnyObject).value(forKey:"gstinno") as! NSObject).description)
                        let email = String (((listarray[i] as AnyObject).value(forKey:"email") as! NSObject).description)
                        let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                        let plantcode = String (((listarray[i] as AnyObject).value(forKey:"plantcode") as! NSObject).description)
                        let plantstateid = String (((listarray[i] as AnyObject).value(forKey:"plantstateid") as! NSObject).description)
                         let isdisplay = String (((listarray[i] as AnyObject).value(forKey:"isdisplay") as? Bool)!)
                        
                        let distributortype = String (((listarray[i] as AnyObject).value(forKey:"distributortype") as! NSObject).description)
                        
                        self.insertgetUSERDISTRIBUTOR(siteid: siteid as NSString, sitename: sitename as NSString, address: address as NSString, city: city as NSString, mobile: mobile as NSString, stateid: stateid as NSString, statename: statename as NSString, salespersoncode: salespersoncode as NSString, gstinno: gstinno as NSString, email: email as NSString, pricegroup: pricegroup as NSString, plantcode: plantcode as NSString, plantstateid: plantstateid as NSString,isdisplay: isdisplay as NSString, distributortype: distributortype)
                    }
                    self.updatelog(tablename: "USERDISTRIBUTOR", status: "success", datetime: self.getTodaydatetime())
                }
            }
//            SwiftEventBus.post("downloadedSync")
            SwiftEventBus.post("downloadedSyncSuperDealer")

            break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "USERDISTRIBUTOR", status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
          //            SwiftEventBus.post("downloadedSync")
            SwiftEventBus.post("downloadedSyncSuperDealer")
             break
            }
        }
    }
    func URL_GETUSERTAXSETUPCOUNT(){
              Alamofire.request(constant.Base_url + constant.URL_GETUSERTAXSETUPCOUNTConst()).validate().responseJSON {
                  response in
                  
                  switch response.result {
                  case .success(let value):
                      print("success=======\(value)")
                  if  let json = response.result.value{
                   var taxdb : Int64 = 0
                      let listarray : NSArray = json as! NSArray
                      if listarray.count > 0 {
                          for i in 0..<listarray.count{
                           
                           let taxapicount = Int (((listarray[i] as AnyObject).value(forKey:"countno") as! Int))
                           AppDelegate.taxapi = taxapicount
                           
                           
                           var stmt1: OpaquePointer?
                           let query = "select count(*) from usertaxsetup"
                           if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
                               let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                               print("error preparing get: \(errmsg)")
                               return
                           }
                           //127 cast as int, 53
                           while(sqlite3_step(stmt1) == SQLITE_ROW){
                               taxdb = Int64(sqlite3_column_int(stmt1, 0))
                           }
                          }
                      }
                  }
                      print("URL_GETUSERTAXSETUPCOUNT called===========")
                      break
                  case .failure(let error):
                   AppDelegate.taxapi = 0
                   print("error===========\(error)")
                  self.URL_GetUserPriceListCount()
                  }
              }
           self.URL_GetUserPriceListCount()
          }
       
       func URL_GetUserPriceListCount(){
              Alamofire.request(constant.Base_url + constant.URL_GetUserPriceListcountConst()).validate().responseJSON {
                  response in
                  switch response.result {
                  case .success(let value):
                      
                   if  let json = response.result.value{
                                    var pricedb : Int64 = 0
                                       let listarray : NSArray = json as! NSArray
                                       if listarray.count > 0 {
                                           for i in 0..<listarray.count {
                                             
                                            let priceapicount = Int (((listarray[i] as AnyObject).value(forKey:"countno") as! Int))
                                            AppDelegate.priceapi = priceapicount
                                              
                                            var stmt1: OpaquePointer?
                                            let query = "select count(*) from UserPriceList"
                                            if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
                                                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                                                print("error preparing get: \(errmsg)")
                                                return
                                            }
                                           
                                            while(sqlite3_step(stmt1) == SQLITE_ROW){
                                                pricedb = Int64(sqlite3_column_int(stmt1, 0))
                                            }
                                           }
                                       }
                                   }
                
                  break
                      
                  case .failure(let error):  print("error===========\(error)")
                  AppDelegate.priceapi = 0
                   self.URL_GETUSERTAXSETUP()
               }}
           self.URL_GETUSERTAXSETUP()
           
       }
    
    func retailermaster2(){
           let url = getretailermasterdata()
           Alamofire.request(constant.Base_url + url).validate().responseJSON {
              
               response in
               if(AppDelegate.isDebug){
               print("MasterURL==="+constant.Base_url + url)
               print("RetailerListApi==="+constant.Base_url + url)
               }
               switch response.result {
               case .success(let value):
                if(AppDelegate.isDebug){
                print("success=======\(value)")
                }
               if  let json = response.result.value{
                   let listarray : NSArray = json as! NSArray
                   if listarray.count > 0 {
                    AppDelegate.isDataCount = false
                    
                    for i in 0..<listarray.count{
                           let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                           let customername = String (((listarray[i] as AnyObject).value(forKey:"customername") as! NSObject).description)
                           let customertype = String (((listarray[i] as AnyObject).value(forKey:"customertype") as! NSObject).description)
                           let contactperson = String (((listarray[i] as AnyObject).value(forKey:"contactperson") as! NSObject).description)
                           let mobilecustcode = String (((listarray[i] as AnyObject).value(forKey:"mobilecustcode") as! NSObject).description)
                           let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                           let alternateno = String (((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                           let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                           let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                           let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                           let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                           let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                           var gstno = String (((listarray[i] as AnyObject).value(forKey:"gstno")  as! NSObject).description)
                           if gstno == "<null>"{
                               gstno = ""
                           }
                           let gstregistrationdate = String (((listarray[i] as AnyObject).value(forKey:"gstregistrationdate") as! NSObject).description)
                           let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                           let salepersonid = String (((listarray[i] as AnyObject).value(forKey:"salepersonid") as! NSObject).description)
                           let keycustomer = String (((listarray[i] as AnyObject).value(forKey:"keycustomer") as? Bool)!)
                           let isorthopositive = String (((listarray[i] as AnyObject).value(forKey:"isorthopositive") as? Bool)!)
                           let sizeofretailer = String (((listarray[i] as AnyObject).value(forKey:"sizeofretailer") as! NSObject).description)
                           let category = String (((listarray[i] as AnyObject).value(forKey:"category") as! NSObject).description)
                           let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                           let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                           let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                           let latitude = String (((listarray[i] as AnyObject).value(forKey:"latitude") as! NSObject).description)
                           let longitude = String (((listarray[i] as AnyObject).value(forKey:"longitude") as! NSObject).description)
                           let orthopedicsale = String (((listarray[i] as AnyObject).value(forKey:"orthopedicsale") as? Double)!)
                           let avgsale = String (((listarray[i] as AnyObject).value(forKey:"avgsale") as? Double)!)
                           let prefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedbrand") as! NSObject).description)
                           let secprefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedbrand") as! NSObject).description)
                           let secprefferedsale = String (((listarray[i] as AnyObject).value(forKey:"secprefferedsale") as! NSObject).description)
                           let prefferedsale = String (((listarray[i] as AnyObject).value(forKey:"prefferedsale") as! NSObject).description)
                           let prefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"prefferedreasonid") as! NSObject).description)
                           let secprefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"secprefferedreasonid") as! NSObject).description)
                           let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int32)!)
                           let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int32)!)
                           let referencecode = String (((listarray[i] as AnyObject).value(forKey:"referencecode") as! NSObject).description)
                           let storeimage = String (((listarray[i] as AnyObject).value(forKey:"storeimage") as? Int32)!)
                           let stockimage = String (((listarray[i] as AnyObject).value(forKey:"stockimage") as? Int32)!)
                           let prefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedothbrand") as! NSObject).description)
                           let secprefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedothbrand") as! NSObject).description)
                           
                           self.updateretailermaster1(customercode: customercode, customername: customername, customertype: customertype, contactperson: contactperson, mobilecustcode: mobilecustcode, mobileno: mobileno, alternateno: alternateno, emailid: emailid, address: address, pincode: pincode, city: city, stateid: stateid, gstno: gstno, gstregistrationdate: gstregistrationdate, siteid: siteid, salepersonid: salepersonid, keycustomer: keycustomer, isorthopositive: isorthopositive, sizeofretailer: sizeofretailer, category: category, isblocked: isblocked, pricegroup: pricegroup, dataareaid: dataareaid, latitude: latitude, longitude: longitude, orthopedicsale: orthopedicsale, avgsale: avgsale, prefferedbrand: prefferedbrand, secprefferedbrand: secprefferedbrand, secprefferedsale: secprefferedsale, prefferedsale: prefferedsale, prefferedreasonid: prefferedreasonid, secprefferedreasonid: secprefferedreasonid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2", referencecode: referencecode, lastvisited: "", storeimage: storeimage, stockimage: stockimage, prefferedothbrand: prefferedothbrand, secprefferedothbrand: secprefferedothbrand)
                       }
                       self.updatelog(tablename: "RetailerMaster", status: "success", datetime: self.getTodaydatetime())
                   }
                   self.drmaster2()
               }
               break
                   
               case .failure(let error):
                if(AppDelegate.isDebug){
                print("error===========\(error)")
                }
               self.updatelog(tablename: "RetailerMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
               self.drmaster2()
               self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                   break
               }
            }
       }
    
    func custHospitallinking2(){
        let url = getCustHospitalLinkingData()
        Alamofire.request(constant.Base_url + url).validate().responseJSON {
            response in
            print("RetailerListApi==="+constant.Base_url + url)
            switch response.result {
            case .success(let value):   print("success=======\(value)")
            if  let json = response.result.value{
                //                self.deleteCUSTHOSPITALLINKING()
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                        let hospitalcode = String (((listarray[i] as AnyObject).value(forKey:"hospitalcode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        
                        self.updateCustHospitalLinkingData(dataareaid: dataareaid, siteid: siteid, customercode: customercode, hospitalcode: hospitalcode, isblocked: isblocked, createdtransactionid:"2" , modifiedtransactionid: "0", post: "2")
                    }
                    self.updatelog(tablename: "CUSTHOSPITALLINKING", status: "success", datetime: self.getTodaydatetime())
                }
                self.objectionmaster1()
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "CUSTHOSPITALLINKING",status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.objectionmaster1()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    
    func drmaster2(){
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from DRMASTER"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
        }
        
        Alamofire.request(constant.Base_url + constant.URL_getuserdrmasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified! + "&ISMOBILE=1" ).validate().responseJSON {
            response in

            
            switch response.result {
            case .success(let value):
                if(AppDelegate.isDebug){
                print("success==========> \(value)")
                }
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    
                    AppDelegate.isDataCount = false

                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let drcode = String (((listarray[i] as AnyObject).value(forKey:"drcode") as! NSObject).description)
                        let drname = String (((listarray[i] as AnyObject).value(forKey:"drname") as! NSObject).description)
                        let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let alternateno = String(((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let city = String(((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let dob = String (((listarray[i] as AnyObject).value(forKey:"dob") as! NSObject).description)
                        let doa = String (((listarray[i] as AnyObject).value(forKey:"doa") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let ispurchaseing = String (((listarray[i] as AnyObject).value(forKey:"ispurchaseing") as? Bool)!)
                        let ispriscription = String(((listarray[i] as AnyObject).value(forKey:"ispriscription") as? Bool)!)
                        let drspecialization = String (((listarray[i] as AnyObject).value(forKey:"drspecialization") as! NSObject).description)
                        let purchaseamt = String(((listarray[i] as AnyObject).value(forKey:"purchaseamt") as? Double)!)
                        let noofprescription = String (((listarray[i] as AnyObject).value(forKey:"noofprescription") as? Double)!)
                        let createdTransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int64)!)
                        let modifiedTransationid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int64)!)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let isbuying = String(((listarray[i] as AnyObject).value(forKey:"isbuying") as? Bool)!)
                        let drtype = String (((listarray[i] as AnyObject).value(forKey:"drtype") as! NSObject).description)
                        let custrefcode = String (((listarray[i] as AnyObject).value(forKey:"custrefcode") as! NSObject).description)
                        let salepersoncode = String (((listarray[i] as AnyObject).value(forKey:"salepersoncode") as! NSObject).description)
                        
                        self.insertDRmaster1(dataareaid: dataareaid, drcode: drcode, drname: drname, mobileno: mobileno, alternateno: alternateno, emailid: emailid, address: address, pincode: pincode, city: city, stateid: stateid, dob: dob == "1900-01-01T00:00:00" ? "" : dob, doa: doa == "1900-01-01T00:00:00" ? "" : doa, isblocked: isblocked, ispurchaseing: ispurchaseing, ispriscription: ispriscription, CREATEDTRANSACTIONID: createdTransactionid, MODIFIEDTRANSACTIONID: modifiedTransationid, POST : "2", drspecialization: drspecialization, purchaseamt: purchaseamt, noofprescription: noofprescription, siteid: siteid, isbuying: isbuying, drtype: drtype, custrefcode: custrefcode, salepersoncode: salepersoncode)
                    }
                    self.updatelog(tablename: "DRMASTER", status: "success", datetime: self.getTodaydatetime())
                }
                self.hospitalMaster2()
            }
            
                break
                
            case .failure(let error):
                if(AppDelegate.isDebug){
                print("error===========\(error)")
                }
            self.updatelog(tablename: "DRMASTER",status: error as? String, datetime: self.getTodaydatetime())
            self.hospitalMaster2()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    func hospitalMaster2(){
        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast(createdTransactionId as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(modifiedTransactionId as int)),'0')as MODIFIEDTRANSACTIONID from HospitalMaster"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
            
        }
        
        Alamofire.request(constant.Base_url + constant.URL_HospitalMasterConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
//            print("Masterurl==="+constant.Base_url + constant.URL_HospitalMaster() + created! + "&MODIFIEDTRANSACTIONID=" + modified!)
//            print("RetailerListApi==="+constant.Base_url + constant.URL_HospitalMaster() + created! + "&MODIFIEDTRANSACTIONID=" + modified!)

            switch response.result {
            case .success(let value):
                if(AppDelegate.isDebug){
                print("success==========> \(value)")
                }
            // self.deleteHospitalMaster()
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    AppDelegate.isDataCount = false

                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let type = String (((listarray[i] as AnyObject).value(forKey:"type") as? Int)!)
                        let hoscode = String (((listarray[i] as AnyObject).value(forKey:"hoscode") as! NSObject).description)
                        let mobileno = String(((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                        let hosname = String(((listarray[i] as AnyObject).value(forKey:"hosname") as! NSObject).description)
                        let alternateno = String (((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                        let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                        let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                        let pincode = String(((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as! NSObject).description)
                        let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        let purchasemgr = String (((listarray[i] as AnyObject).value(forKey:"purchasemgr") as! NSObject).description)
                        let authorisedperson = String (((listarray[i] as AnyObject).value(forKey:"authorisedperson") as! NSObject).description)
                        let degisnation = String (((listarray[i] as AnyObject).value(forKey:"degisnation") as! NSObject).description)
                        let bedcount = String(((listarray[i] as AnyObject).value(forKey:"bedcount") as? Double)!)
                        let category = String (((listarray[i] as AnyObject).value(forKey:"category") as! NSObject).description)
                        let sector = String (((listarray[i] as AnyObject).value(forKey:"sector") as! NSObject).description)
                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                        let hospitaltype = String(((listarray[i] as AnyObject).value(forKey:"hospitaltype") as! NSObject).description)
                        let ispurchase = String (((listarray[i] as AnyObject).value(forKey:"ispurchase") as? Bool)!)
                        let purchmgrmobileno = String (((listarray[i] as AnyObject).value(forKey:"purchmgrmobileno") as! NSObject).description)
                        let authpersonmobileno = String (((listarray[i] as AnyObject).value(forKey:"authpersonmobileno") as! NSObject).description)
                        let monthlypurchase = String (((listarray[i] as AnyObject).value(forKey:"monthlypurchase") as? Double)!)
                        let custrefcode = String (((listarray[i] as AnyObject).value(forKey:"custrefcode") as! NSObject).description)
                        let salepersoncode = String (((listarray[i] as AnyObject).value(forKey:"salepersoncode") as! NSObject).description)
                        
                        self.insertHospitalMaster1(DATAAREAID: dataareaid, TYPE: type, HOSCODE: hoscode, HOSNAME: hosname, MOBILENO: mobileno, ALTNUMBER: alternateno, EMAILID: emailid, CityID: cityid, ADDRESS: address, PINCODE: pincode, STATEID: stateid, ISBLOCKED: isblocked, CREATEDTRANSACTIONID: createdtransactionid, MODIFIEDTRANSACTIONID: modifiedtransactionid, POST: "2", PURCHASEMGR: purchasemgr, AUTHORISEDPERSON: authorisedperson, PURCHMGRMOBILENO: purchmgrmobileno, AUTHPERSONMOBILENO: authpersonmobileno, DEGISNATION: degisnation, BEDCOUNT: bedcount, CATEGORY: category, SITEID: siteid, HOSPITALTYPE: hospitaltype, ISPURCHASE: ispurchase, monthlypurchase: monthlypurchase, custrefcode: custrefcode, salepersoncode: salepersoncode)
                    }
                    self.updatelog(tablename: "HospitalMaster", status: "success", datetime: self.getTodaydatetime())
                }
                self.URL_HospitalDRLinking2()
            }
              break
                
            case .failure(let error):
                if(AppDelegate.isDebug){
                print("error===========\(error)")
                }
            self.updatelog(tablename: "HospitalMaster",status: error as? String, datetime: self.getTodaydatetime())
            self.URL_HospitalDRLinking2()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}
    }
    func retailermaster3(){
              let url = getretailermasterdata()
              Alamofire.request(constant.Base_url + url).validate().responseJSON {
                 
                  response in
                  print("MasterURL==="+constant.Base_url + url)
                  print("RetailerListApi==="+constant.Base_url + url)
                  switch response.result {
                  case .success(let value):
                    print("success=======\(value)")
                  if  let json = response.result.value{
                      let listarray : NSArray = json as! NSArray
                      if listarray.count > 0 {

                          for i in 0..<listarray.count{
                              let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                              let customername = String (((listarray[i] as AnyObject).value(forKey:"customername") as! NSObject).description)
                              let customertype = String (((listarray[i] as AnyObject).value(forKey:"customertype") as! NSObject).description)
                              let contactperson = String (((listarray[i] as AnyObject).value(forKey:"contactperson") as! NSObject).description)
                              let mobilecustcode = String (((listarray[i] as AnyObject).value(forKey:"mobilecustcode") as! NSObject).description)
                              let mobileno = String (((listarray[i] as AnyObject).value(forKey:"mobileno") as! NSObject).description)
                              let alternateno = String (((listarray[i] as AnyObject).value(forKey:"alternateno") as! NSObject).description)
                              let emailid = String (((listarray[i] as AnyObject).value(forKey:"emailid") as! NSObject).description)
                              let address = String (((listarray[i] as AnyObject).value(forKey:"address") as! NSObject).description)
                              let pincode = String (((listarray[i] as AnyObject).value(forKey:"pincode") as! NSObject).description)
                              let city = String (((listarray[i] as AnyObject).value(forKey:"city") as! NSObject).description)
                              let stateid = String (((listarray[i] as AnyObject).value(forKey:"stateid") as! NSObject).description)
                              var gstno = String (((listarray[i] as AnyObject).value(forKey:"gstno")  as! NSObject).description)
                              if gstno == "<null>"{
                                  gstno = ""
                              }
                              let gstregistrationdate = String (((listarray[i] as AnyObject).value(forKey:"gstregistrationdate") as! NSObject).description)
                              let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                              let salepersonid = String (((listarray[i] as AnyObject).value(forKey:"salepersonid") as! NSObject).description)
                              let keycustomer = String (((listarray[i] as AnyObject).value(forKey:"keycustomer") as? Bool)!)
                              let isorthopositive = String (((listarray[i] as AnyObject).value(forKey:"isorthopositive") as? Bool)!)
                              let sizeofretailer = String (((listarray[i] as AnyObject).value(forKey:"sizeofretailer") as! NSObject).description)
                              let category = String (((listarray[i] as AnyObject).value(forKey:"category") as! NSObject).description)
                              let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                              let pricegroup = String (((listarray[i] as AnyObject).value(forKey:"pricegroup") as! NSObject).description)
                              let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                              let latitude = String (((listarray[i] as AnyObject).value(forKey:"latitude") as! NSObject).description)
                              let longitude = String (((listarray[i] as AnyObject).value(forKey:"longitude") as! NSObject).description)
                              let orthopedicsale = String (((listarray[i] as AnyObject).value(forKey:"orthopedicsale") as? Double)!)
                              let avgsale = String (((listarray[i] as AnyObject).value(forKey:"avgsale") as? Double)!)
                              let prefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedbrand") as! NSObject).description)
                              let secprefferedbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedbrand") as! NSObject).description)
                              let secprefferedsale = String (((listarray[i] as AnyObject).value(forKey:"secprefferedsale") as! NSObject).description)
                              let prefferedsale = String (((listarray[i] as AnyObject).value(forKey:"prefferedsale") as! NSObject).description)
                              let prefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"prefferedreasonid") as! NSObject).description)
                              let secprefferedreasonid = String (((listarray[i] as AnyObject).value(forKey:"secprefferedreasonid") as! NSObject).description)
                              let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int32)!)
                              let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int32)!)
                              let referencecode = String (((listarray[i] as AnyObject).value(forKey:"referencecode") as! NSObject).description)
                              let storeimage = String (((listarray[i] as AnyObject).value(forKey:"storeimage") as? Int32)!)
                              let stockimage = String (((listarray[i] as AnyObject).value(forKey:"stockimage") as? Int32)!)
                              let prefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"prefferedothbrand") as! NSObject).description)
                              let secprefferedothbrand = String (((listarray[i] as AnyObject).value(forKey:"secprefferedothbrand") as! NSObject).description)
                              
                              self.updateretailermaster1(customercode: customercode, customername: customername, customertype: customertype, contactperson: contactperson, mobilecustcode: mobilecustcode, mobileno: mobileno, alternateno: alternateno, emailid: emailid, address: address, pincode: pincode, city: city, stateid: stateid, gstno: gstno, gstregistrationdate: gstregistrationdate, siteid: siteid, salepersonid: salepersonid, keycustomer: keycustomer, isorthopositive: isorthopositive, sizeofretailer: sizeofretailer, category: category, isblocked: isblocked, pricegroup: pricegroup, dataareaid: dataareaid, latitude: latitude, longitude: longitude, orthopedicsale: orthopedicsale, avgsale: avgsale, prefferedbrand: prefferedbrand, secprefferedbrand: secprefferedbrand, secprefferedsale: secprefferedsale, prefferedsale: prefferedsale, prefferedreasonid: prefferedreasonid, secprefferedreasonid: secprefferedreasonid, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2", referencecode: referencecode, lastvisited: "", storeimage: storeimage, stockimage: stockimage, prefferedothbrand: prefferedothbrand, secprefferedothbrand: secprefferedothbrand)
                          }
                          self.updatelog(tablename: "RetailerMaster", status: "success", datetime: self.getTodaydatetime())
                      }
                    if(AppDelegate.isFromRetailer){
                        SwiftEventBus.post("downloadedSyncRetailer")
                    }
                    else{
                        SwiftEventBus.post("downloadedSync")
                    }
                    
                  }
                  break
                      
                  case .failure(let error):  print("error===========\(error)")
                  self.updatelog(tablename: "RetailerMaster", status: error.localizedDescription, datetime: self.getTodaydatetime())
                  
                  if(AppDelegate.isFromRetailer){
                      SwiftEventBus.post("downloadedSyncRetailer")
                  }
                  else{
                      SwiftEventBus.post("downloadedSync")
                  }
                  self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                      break
                  }
               }
          }
        func URL_userDR2(){
            
            let url = getUserDRCUSTLinkingData()
            
            Alamofire.request(constant.Base_url + url).validate().responseJSON {
                response in
                if(AppDelegate.isDebug){
                print("MasterURL="+constant.Base_url + url)
                }
                switch response.result {
                case .success(let value):   print("success=======\(value)")
                if  let json = response.result.value{
    //                self.deleteuserDRCustLinking()
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        for i in 0..<listarray.count{
                            AppDelegate.isDataCount = false

                            let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                            let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                            let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                            let drcode = String (((listarray[i] as AnyObject).value(forKey:"drcode") as! NSObject).description)
                            let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                            let ispurchaseing = String (((listarray[i] as AnyObject).value(forKey:"ispurchaseing") as? Bool)!)
                            let ispriscription = String (((listarray[i] as AnyObject).value(forKey:"ispriscription") as? Bool)!)
                            let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int64)!)
                            let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int64)!)
                            
                            self.updateUserDrcustlinking1(dataareaid: dataareaid, siteid: siteid, customercode: customercode, drcode: drcode, isblocked: isblocked, ispurchaseing: ispurchaseing, ispriscription: ispriscription, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid, post: "2")
                        }
                        Loginvc.flagcount = Loginvc.flagcount + 1
                        
                        self.updatelog(tablename: "userDRCustLinking", status: "success", datetime: self.getTodaydatetime())
                    }
              //      self.updateprogress()
                    self.URL_getcompetitor2()
                }
                    break
                    
                case .failure(let error):
                    if(AppDelegate.isDebug){
                    print("error===========\(error)")
                    }
                self.updatelog(tablename: "userDRCustLinking",status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.URL_getcompetitor2()
                self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                    break
                }}}
    
    func URL_HospitalDRLinking2(){

        var stmt1: OpaquePointer?
        let query = "select ifnull(max(cast (CREATEDTRANSACTIONID as int)),'0') as CREATEDTRANSACTIONID,ifnull(max(cast(ModifiedTransactionId as int)),'0')as ModifiedTransactionId from HospitalDRLinking"
        var created: String? = "0"
        var modified: String? = "0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        //127 cast as int, 53
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            created = String(cString: sqlite3_column_text(stmt1, 0))//0 index
            modified = String(cString: sqlite3_column_text(stmt1, 1))//1 index
            // + created! + "&MODIFIEDTRANSACTIONID=" + modified!
        }
        
        Alamofire.request(constant.Base_url + constant.URL_HospitalDRLinkingConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!).validate().responseJSON {
            response in
            if(AppDelegate.isDebug){
             print("MasterURL="+constant.Base_url + constant.URL_HospitalDRLinkingConst() + created! + "&MODIFIEDTRANSACTIONID=" + modified!)
            }
            switch response.result {
            case .success(let value):
                if(AppDelegate.isDebug){
                print("success=======\(value)")
                }
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    AppDelegate.isDataCount = false

                    for i in 0..<listarray.count{
                        
                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                        let drcode = String (((listarray[i] as AnyObject).value(forKey:"drcode") as! NSObject).description)
                        let hospitalcode = String (((listarray[i] as AnyObject).value(forKey:"hospitalcode") as! NSObject).description)
                        let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int64)!)
                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int64)!)
                        
                        self.insertHospitalDRLinking(dataareaid: dataareaid, drcode: drcode, hospitalcode: hospitalcode, isblocked: isblocked, RECID: "", CREATEDBY: UserDefaults.standard.string(forKey: "usercode"), post: "2", CREATEDTRANSACTIONID: createdtransactionid, ModifiedTransactionId: modifiedtransactionid)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    
                    self.updatelog(tablename: "HospitalDRLinking", status: "success", datetime: self.getTodaydatetime())
                }
            //    self.updateprogress()
                self.URL_GetCusthospitalLinking2()
            }
            
                break
                
            case .failure(let error):
                if(AppDelegate.isDebug){
                print("error===========\(error)")
                }
            self.updatelog(tablename: "HospitalDRLinking",status: error.localizedDescription, datetime: self.getTodaydatetime())
            self.URL_GetCusthospitalLinking2()
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}

        func URL_GetCusthospitalLinking2(){
            let url = getCustHospitalLinkingData()
            Alamofire.request(constant.Base_url + url).validate().responseJSON {
                
                response in
                if(AppDelegate.isDebug){
                print("MasterURL="+constant.Base_url + url)
                }
                switch response.result {
                case .success(let value):   print("success=======\(value)")
                if  let json = response.result.value{
    //                self.deleteCUSTHOSPITALLINKING()
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        AppDelegate.isDataCount = false

                        for i in 0..<listarray.count{
                            
                            let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                            let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                            let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                            let hospitalcode = String (((listarray[i] as AnyObject).value(forKey:"hospitalcode") as! NSObject).description)
                            let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                            let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                            let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                                                        
                            self.updateCustHospitalLinkingData(dataareaid: dataareaid, siteid: siteid, customercode: customercode, hospitalcode: hospitalcode, isblocked: isblocked, createdtransactionid:createdtransactionid , modifiedtransactionid: modifiedtransactionid, post: "2")
                        }
                        Loginvc.flagcount = Loginvc.flagcount + 1
                        
                        self.updatelog(tablename: "CUSTHOSPITALLINKING", status: "success", datetime: self.getTodaydatetime())
                    }
                   // self.updateprogress()
                    self.URL_userDR2()
                }
                
                    break
                    
                case .failure(let error):
                    if(AppDelegate.isDebug){
                    print("error===========\(error)")
                    }
                self.updatelog(tablename: "CUSTHOSPITALLINKING",status: error.localizedDescription, datetime: self.getTodaydatetime())
                self.URL_userDR2()
                self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                    break
                }}}
      func URL_getcompetitor2(){
          let url = getcompetitortabledata()
           Alamofire.request(constant.Base_url + url).validate().responseJSON {
               response in
            if(AppDelegate.isDebug){
               print("MasterURL="+constant.Base_url + url)
            }
               switch response.result {
               case .success(let value):
                if(AppDelegate.isDebug){
                print("success=======\(value)")
                }
               if  let json = response.result.value{
             //      self.deleteCOMPETITORDETAIL()
                   let listarray : NSArray = json as! NSArray
                   if listarray.count > 0 {
                    AppDelegate.isDataCount = false

                       for i in 0..<listarray.count{
                           
                           let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                           let compititorid = String (((listarray[i] as AnyObject).value(forKey:"compititorid") as! NSObject).description)
                           let compititorname = String (((listarray[i] as AnyObject).value(forKey:"compititorname") as! NSObject).description)
                           let itemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as? Int)!)
                           let itemname = String (((listarray[i] as AnyObject).value(forKey:"itemname") as! NSObject).description).replacingOccurrences(of: "'s", with: "").replacingOccurrences(of: "/",  with: "").replacingOccurrences(of: ",", with: "")
                           let status = String (((listarray[i] as AnyObject).value(forKey:"status") as! NSObject).description)
                           let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                           let isapproved = String (((listarray[i] as AnyObject).value(forKey:"isapproved") as? Bool)!)
                          let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                           let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)

                           
                           self.insertcompetitor(dataareaid: dataareaid, compititorid: compititorid, compititorname: compititorname, itemid: itemid, itemname: itemname, post: "2", isblocked: isblocked, status: status, isapproved: isapproved, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                       }
                       Loginvc.flagcount = Loginvc.flagcount + 1
                       
                       self.updatelog(tablename: "COMPETITORDETAIL", status: "success", datetime: self.getTodaydatetime())
                   }
                   self.URL_getusercompetitor2()
               }
               
                   break
                   
               case .failure(let error):
                if(AppDelegate.isDebug){
                print("error===========\(error)")
                }
               self.updatelog(tablename: "COMPETITORDETAIL",status: error.localizedDescription, datetime: self.getTodaydatetime())
               self.URL_getusercompetitor2()
               self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                   break
               }}}
       func URL_getusercompetitor2(){
        let compURL = getuserCompetitorURL()
        Alamofire.request(constant.Base_url + compURL).validate().responseJSON {
               response in
            if(AppDelegate.isDebug){
               print("MasterURL="+constant.Base_url + compURL)
            }
               switch response.result {
               case .success(let value):   print("success=======\(value)")
               if  let json = response.result.value{
               //    self.deleteCOMPETITORDETAILPOST()
                   let listarray : NSArray = json as! NSArray
                   if listarray.count > 0 {
                    AppDelegate.isDataCount = false

                       for i in 0..<listarray.count{
                           
                           let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as! NSObject).description)
                           let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as! NSObject).description)
                           let compitemid = String (((listarray[i] as AnyObject).value(forKey:"compitemid") as? Int)!)
                           let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as! NSObject).description)
                           let monthlysale = String (((listarray[i] as AnyObject).value(forKey:"monthlysale") as? Double)!)
                           let reasonid = String (((listarray[i] as AnyObject).value(forKey:"reasonid") as! NSObject).description)
                           let saleqty = String (((listarray[i] as AnyObject).value(forKey:"saleqty") as? Double)!)
                           let ispreffered = String (((listarray[i] as AnyObject).value(forKey:"ispreffered") as? Bool)!)
                           let preffindex = String (((listarray[i] as AnyObject).value(forKey:"preffindex") as? Double)!)
                           let compititorid = String (((listarray[i] as AnyObject).value(forKey:"compititorid") as! NSObject).description)
                           let compititordesc = String (((listarray[i] as AnyObject).value(forKey:"compititordesc") as! NSObject).description).replacingOccurrences(of: "", with: "-")
                           let isblocked = String (((listarray[i] as AnyObject).value(forKey:"isblocked") as? Bool)!)
                           let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                           let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                        // let preferred = String (((listarray[i] as AnyObject).value(forKey:"preferred Type") as! NSObject).description)
                        
                           self.insertusercompetitor(DATAAREAID: dataareaid, CUSTOMERCODE: customercode, ITEMID: compitemid, SITEID: siteid, USERCODE: UserDefaults.standard.string(forKey: "usercode")!, post: "2", Competitorid: compititorid, reasonid: reasonid, qty: saleqty, sale: monthlysale, ispreffered: ispreffered, preffindex: preffindex, brandname: compititordesc, isblocked: isblocked, createdtransactionid: createdtransactionid, modifiedtransactionid: modifiedtransactionid)
                       }
                       Loginvc.flagcount = Loginvc.flagcount + 1
                       self.updatelog(tablename: "COMPETITORDETAILPOST", status: "success", datetime: self.getTodaydatetime())
                   }
                
                       if(AppDelegate.isFromRetailer){
                       SwiftEventBus.post("downloadedSyncRetailer")
                   }
                   else{
                       SwiftEventBus.post("downloadedSync")
                   }

               }
                   break
                   
               case .failure(let error):
                if(AppDelegate.isDebug){
                print("error===========\(error)")
                }
               self.updatelog(tablename: "COMPETITORDETAILPOST",status: error.localizedDescription, datetime: self.getTodaydatetime())

               if(AppDelegate.isFromRetailer){
                   SwiftEventBus.post("downloadedSyncRetailer")
               }
               else{
                   SwiftEventBus.post("downloadedSync")
               }

               self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                   break
               }}}
    

}

