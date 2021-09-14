//
//  Postapi.swift
//  tynorios
//
//  Created by Acxiom Consulting on 03/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import Alamofire
import SQLite3
import UIKit
import SwiftEventBus

public class Postapi: Baseactivity
{
    var stat : NSString?
    var counter: Float = 0;
    var alertbool: Bool!
    var loadershow: Bool! = false;
    var totalapi: Float = 0;
    var progressView: UIProgressView?
    var alert : UIAlertController!
    //    var per: Float = 0;
    
    func setprogress(title: String){
        
        alert = UIAlertController(title: title, message: " ", preferredStyle: .alert)
        //let progressColor = UIColor(red: 138.0 / 255.0, green: 17.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
        counter = 0;
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        //        progressView?.center = alert.view.center
        progressView!.frame = CGRect(x: 10, y: 60, width: 250, height: 5)
        progressView?.progressTintColor = UIColor.blue
        progressView?.trackTintColor = UIColor(red: 154.0 / 255.0, green: 154.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
        alert.view.addSubview(progressView!)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 15, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        progressView?.setProgress(0.0, animated: true)
        alert.view.addSubview(loadingIndicator)
        //   UIApplication.shared.keyWindow!.addSubview(self.alert.view)
        present(alert, animated: true, completion: nil)
        
    }
    @objc func updateprogress(){
        self.counter = self.counter + 1
        let per = (self.counter/self.totalapi)
        self.progressView?.setProgress(per, animated: true)
        print("***\n\nPercentage progress =====> \t \(per*100) \t\(self.counter)\n\n***")
    }
    
    
    func postDownload(){
        posthospitalMaster()
    }
    
    func postRemainingApis(){
        postPrimaryOrder()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
            if(AppDelegate.isFromMiStock){
                SwiftEventBus.post("retailerdatapostedNew")
            }
            else{
                SwiftEventBus.post("retailerdataposted")
            }
            AppDelegate.issync = 0
        }
    }
    
   
    
    func postRemaining(){
        postPrimaryOrder()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
            if(AppDelegate.isFromMiStock){
                SwiftEventBus.post("retailerdatapostedNew")
            }
            else{
                SwiftEventBus.post("retailerdataposted")
            }
            AppDelegate.issync = 0
        }
    }
    
    
    func postall (loadingbool: Bool)
    {
        self.loadershow = loadingbool
        if loadershow {
            self.totalapi = 19
            self.setprogress(title: "Uploading...")
        }
        else {
            self.showloader(title: "Uploading...")
        }
        posthospitalMaster() //check
        postExpense() //check
        postAttendence()
        postPrimaryOrder() //check
        postNoOrderReason()
        postObjectionEntry()
        self.alert.dismiss(animated: true, completion: {
            SwiftEventBus.post("uploaded")
        })
    }
    
    func postdealerconversion()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            
            var stmt1:OpaquePointer?
            let queryString = "SELECT * FROM subdealers WHERE post = '0'"
            //let URL_postinsalon = Constants.BASE_URL + Constants.URL_Postinsalon
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
               if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                //String(cString: sqlite3_column_text(stmt, 1))
                let CUSTOMERCODE = String(cString: sqlite3_column_text(stmt1, 0))
                let EXPSALE = String(cString: sqlite3_column_text(stmt1, 1))
                let EXPDISCOUNT = String(cString: sqlite3_column_text(stmt1, 2))
                let DATAAREAID = String(cString: sqlite3_column_text(stmt1, 3))
                let USERCODE = UserDefaults.standard.string(forKey: "usercode")!
                let SUBMITDATE = String(cString: sqlite3_column_text(stmt1, 5))
                if(AppDelegate.isDebug){
                print("\n")
                }
                let parameters: [String: AnyObject] = [
                    "CUSTOMERCODE" : CUSTOMERCODE as AnyObject,
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    "EXPSALE" : EXPSALE as AnyObject,
                    "EXPDISCOUNT" : EXPDISCOUNT as AnyObject,
                    "USERCODE" : USERCODE as AnyObject,
                    "SUBMITDATE" : SUBMITDATE as AnyObject,
                    
                ]
                var a = self.json(from: parameters)
                if(AppDelegate.isDebug){
                print("SubDealerConversionPost ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostSubDealer, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .responseJSON { response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                            case .success :
                                //self.showtoast(controller: self, message: "Upload Status: Success", seconds: 2.0)
                                self.updatesubdealerconversion(pkey: CUSTOMERCODE)
                                self.postLog(tablename: "subdealers", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Sub Dealer Conversion")
                                
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                //     self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                break
                                
                            case .failure(let error):
                                //                                self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                                self.postLog(tablename: "subdealers", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Sub Dealer Conversion")
                                
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //      self.showtoast(controller: self, message: "Data is not Uploaded", seconds: 1.0)
                                break
                            }
                    }
                }
                //            DispatchQueue.main.async {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //
                //                    // stop animating now that background task is finished
                //
                //                    self.view.isUserInteractionEnabled = true
                //                    print("loader deactivated")
                //                    self.showtoast(controller: self, message: "Data is Uploaded", seconds: 1.0)
                //                }
                //            }
                //           }
            }
        }
            
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    // escalation
    //    func postTraining()
    //    {
    //        view.isUserInteractionEnabled = false
    //        print("loader activated")
    //
    //        var stmt1:OpaquePointer?
    //
    //        let queryString = "Select * from TrainingDetail where post = '0'"
    //        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
    //            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
    //            print("error preparing get: \(errmsg)")
    //            return
    //        }
    //
    //        while(sqlite3_step(stmt1) == SQLITE_ROW){
    //            var url: URL!
    //
    //            let stringurl:String = constant.Base_url + "POSTTraining"
    //            url = URL(string: stringurl)
    //
    //            var request = URLRequest(url: url)
    //            request.httpMethod = "POST"
    //            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //            var body: [String: AnyObject] = [:]
    //
    //            let tid = String(cString: sqlite3_column_text(stmt1, 0))
    //            body = [
    //                "TRAININGID" :  String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
    //                "DATAAREAID" :  UserDefaults.standard.string(forKey: "dataareaid")! as AnyObject,
    //                "TRAINEDBY" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
    //                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
    //                "TRAINEDTO" :  String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
    //                "TRAININGSTARTTIME" :  String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
    //                "TRAININGENDTIME" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
    //                "REMARKS" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
    //                "USERCODE" :  UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
    //                "USERTYPE" :  UserDefaults.standard.string(forKey: "usertype")! as AnyObject,
    //                "ISMOBILE" :  "1" as AnyObject
    //            ]
    //
    //            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
    //            print(body)
    //
    //            DispatchQueue.main.async {
    //                Alamofire.request(request).responseJSON { response in
    //
    //                    switch (response.result) {
    //                    case .success:
    //                        self.updatetraining(trainingid:tid)
    //                        self.postLog(tablename: "Training", logstat: "success", syncdate: self.getTodaydatetime(), logid: "TrainingDetail")
    //
    //                        self.view.isUserInteractionEnabled = true
    //                        print("loader deactivated")
    //                        //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
    //                        if self.loadershow {
    //                            self.updateprogress()
    //                        }
    //                        break
    //
    //
    //                    case .failure(let error):
    //
    //                        self.postLog(tablename: "Training", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "TrainingDetail")
    //
    //                        self.view.isUserInteractionEnabled = true
    //                        print("loader deactivated")
    //                        //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
    //
    //                        break
    //
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func postStartTraining()
    {
        view.isUserInteractionEnabled = false
        print("loader activated")
        
        var stmt1:OpaquePointer?
        
        let queryString = "select * from TrainingDetail where post = '0'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var url: URL!
            
            let stringurl:String = constant.Base_url + "POSTTraining"
            url = URL(string: stringurl)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var body: [String: AnyObject] = [:]
            
            let tid = String(cString: sqlite3_column_text(stmt1, 0))
            body = [
                "TRAININGID" :  String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "DATAAREAID" :  UserDefaults.standard.string(forKey: "dataareaid")! as AnyObject,
                "TRAINEDBY" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "TRAINEDTO" :  String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "TRAININGSTARTTIME" :  String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "TRAININGENDTIME" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "REMARKS" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
                "USERCODE" :  UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "USERTYPE" :  UserDefaults.standard.string(forKey: "usertype")! as AnyObject,
                "ISMOBILE" :  "1" as AnyObject
            ]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
            
            var a = self.json(from: body)
            print("postStartTraining ====> \(a!)")
            print(body)
            
            Alamofire.request(request).responseJSON { response in
                
                switch (response.result) {
                case .success:
                    self.updatestarttraining(trainingid: tid)
                    self.postLog(tablename: "Training", logstat: "success", syncdate: self.getTodaydatetime(), logid: "TrainingDetail")
                    SwiftEventBus.post("startpost")
                    
                    self.view.isUserInteractionEnabled = true
                    print("loader deactivated")
                    
                    break
                    
                case .failure(let error):
                    
                    self.postLog(tablename: "Training", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "TrainingDetail")
                    SwiftEventBus.post("startpostnot")
                    self.view.isUserInteractionEnabled = true
                    print("loader deactivated")
                    //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                    
                    break
                }
            }
        }
    }
    
    func postEndTraining()
    {
        view.isUserInteractionEnabled = false
        self.showloader(title: "Uploading...")
        print("loader activated")
        
        var stmt1:OpaquePointer?
        
        let queryString = "Select * from TrainingDetail where post = '1'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var url: URL!
            
            let stringurl:String = constant.Base_url + "POSTTraining"
            url = URL(string: stringurl)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var body: [String: AnyObject] = [:]
            let execute = Executeapi()
            let tid = String(cString: sqlite3_column_text(stmt1, 0))
            body = [
                "TRAININGID" :  String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "DATAAREAID" :  UserDefaults.standard.string(forKey: "dataareaid")! as AnyObject,
                "TRAINEDBY" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "TRAININGDATE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "TRAINEDTO" :  String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "TRAININGSTARTTIME" :  String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "TRAININGENDTIME" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "REMARKS" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
                "USERCODE" :  UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "USERTYPE" :  UserDefaults.standard.string(forKey: "usertype")! as AnyObject,
                "ISMOBILE" :  "1" as AnyObject
            ]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
            var a = self.json(from: body)
            print("postEndTraining ====> \(a!)")
            print(body)
            
            DispatchQueue.main.async {
                Alamofire.request(request).responseJSON { response in
                    
                    switch (response.result) {
                    case .success:
                        self.updateendtraining(trainingid: tid)
                        self.postLog(tablename: "Training", logstat: "success", syncdate: self.getTodaydatetime(), logid: "TrainingDetail")
                        execute.URL_GetTrainingDetailbck()
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        
                        break
                        
                    case .failure(let error):
                        
                        self.postLog(tablename: "Training", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "TrainingDetail")
                        
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        
                        
                        break
                    }
                }
            }
        }
    }
    
    func postmarketescalation()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            var stmt1:OpaquePointer?
            let queryString = "SELECT * FROM MarketEscalationActivity WHERE post = '0'"
            //let URL_postinsalon = Constants.BASE_URL + Constants.URL_Postinsalon
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            //        DispatchQueue.global(qos: .userInitiated).async {
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                //String(cString: sqlite3_column_text(stmt, 1))
                let escalationCode = String(cString: sqlite3_column_text(stmt1, 0))
                let date = String(cString: sqlite3_column_text(stmt1, 1))
                let reason = String(cString: sqlite3_column_text(stmt1, 3))
                let detail = String(cString: sqlite3_column_text(stmt1, 4))
                let latitude = String(cString: sqlite3_column_text(stmt1, 6))
                let longitude = String(cString: sqlite3_column_text(stmt1, 7))
                let datareaid = String(cString: sqlite3_column_text(stmt1, 8))
                let customercode = String(cString: sqlite3_column_text(stmt1, 9))
                let siteid = String(cString: sqlite3_column_text(stmt1, 10))
                let createdby = String(cString: sqlite3_column_text(stmt1, 11))
                if(AppDelegate.isDebug){
                print("\n")
                }
                let parameters: [String: AnyObject] = [
                    "ESCALATIONID" : escalationCode as AnyObject,
                    "SUBMITTIME" : date as AnyObject,
                    "REASONCODE" : reason as AnyObject,
                    "REMARKS" : detail as AnyObject,
                    "ISMOBILE" : "1" as AnyObject,
                    "LATITUDE" : latitude as AnyObject,
                    "LONGITUDE" : longitude as AnyObject,
                    "DATAAREAID" : datareaid as AnyObject,
                    "CUSTOMERCODE" : customercode as AnyObject,
                    "SITEID" : siteid as AnyObject,
                    "USERCODE" : createdby as AnyObject
                ]
                var a = self.json(from: parameters)
                if(AppDelegate.isDebug){
                print("EscalationRemarksPost ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostMarketEscalation, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                            case .success(let value) :
                                //self.showtoast(controller: self, message: "Upload Status: Success", seconds: 2.0)
                                self.updatemarketescalation(escalationcode: escalationCode)
                                self.postLog(tablename: "MarketEscalationActivity", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Escalation Marking")
                            if(AppDelegate.isDebug){
                                print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                break
                                
                            case .failure(let error):
                                //                                self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                                self.postLog(tablename: "MarketEscalationActivity", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Escalation Marking")
                                
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                                if(AppDelegate.isDebug){
                                print("error=========> \(error)")
                                }
                                    break
                            }
                    }
                    
                }
                //            DispatchQueue.main.async {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //
                //                    // stop animating now that background task is finished
                //
                //                    self.view.isUserInteractionEnabled = true
                //                    print("loader deactivated")
                //                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                //                }
                //            }
                //            }
                
            }
            
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func postSubdealerConvert()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            view.isUserInteractionEnabled = false
            print("loader activated")
            
            var stmt1:OpaquePointer?
            let queryString = "SELECT * FROM InsertSubDealerRequest WHERE post = '0'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                //String(cString: sqlite3_column_text(stmt, 1))
                let dataareaid = String(cString: sqlite3_column_text(stmt1, 0))
                let status = String(cString: sqlite3_column_text(stmt1, 1))
                let expdiscount = String(cString: sqlite3_column_text(stmt1, 2))
                let recid = String(cString: sqlite3_column_text(stmt1, 3))
                let usercode = String(cString: sqlite3_column_text(stmt1, 4))
                let rejectreason = String(cString: sqlite3_column_text(stmt1, 5))
                let customercode = String(cString: sqlite3_column_text(stmt1, 7))
                
                print("\n")
                
                let parameters: [String: AnyObject] = [
                    "RECID" : recid as AnyObject,
                    "USERCODE" : usercode as AnyObject,
                    "DATAAREAID" : dataareaid as AnyObject,
                    "REJECTREASON" : rejectreason as AnyObject,
                    "STATUS" : status as AnyObject,
                    "EXPDISCOUNT" : expdiscount as AnyObject,
                ]
                var a = self.json(from: parameters)
                print("InsertSubDealerConversion ====> \(a!)")
                
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_postSubDealerRequest, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            
                            self.stat = response.result.description as NSString
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            switch response.result {
                                
                            case .success(let value) :
                                //self.showtoast(controller: self, message: "Upload Status: Success", seconds: 2.0)
                                
                                self.postLog(tablename: "InsertSubDealerRequest", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Insert SubDealer")
                                self.updateSubDealerconvert(customercode: customercode)
                                SwiftEventBus.post("subdealerPost")
                                
                                print("value ==========> \(value)")
                                
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                break
                                
                            case .failure(let error):
                                //                                self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                                self.postLog(tablename: "InsertSubDealerRequest", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Insert SubDealer")
                                SwiftEventBus.post("subdealerPost")
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                                
                                print("error=========> \(error)")
                                break
                            }
                    }
                    
                }
            }
            
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    
    func postCompetitorDetail()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            var stmt1:OpaquePointer?
            
            var i:Int32 = 0
            var j:Int32 = 0
             
            let queryString = "select * from COMPETITORDETAIL where post='0'"
            
            i = self.getcursorcount(query: "COMPETITORDETAIL WHERE post = '0'")
            
            if(i>0){
            
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW)
            {
                let dataareaid = String(cString: sqlite3_column_text(stmt1, 0))
                let competitorid = String(cString: sqlite3_column_text(stmt1, 1))
                let itemname = String(cString: sqlite3_column_text(stmt1, 4))
                let itemid = String(cString: sqlite3_column_text(stmt1, 3))
                let usercode = UserDefaults.standard.string(forKey: "usercode")

                if(AppDelegate.isDebug){
                    print("\n")
                }
                
                //MARK:- increasing iteration counter
                j += 1;
                
                let parameters: [String: AnyObject] = [
                    "DATAAREAID" : dataareaid as AnyObject,
                    "ITEMDESC" : itemname as AnyObject,
                    "COMPITITORID" : competitorid as AnyObject,
                    "USERCODE" : usercode as AnyObject,
                ]
                var a = json(from: parameters)
                if(AppDelegate.isDebug){
                print("\("COMPITITORDETAILSPost==="+a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_postCompetitorDetail, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                            case .success(let value) :
                                if (response.response?.statusCode == 200){
                                if  let json = response.result.value{
                                    let listarray : NSArray = json as! NSArray
                                    if listarray.count > 0 {
                                        for i in 0..<listarray.count{
                                            let olditemid = itemid
                                            let newitemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as? Int)!)
                                            self.updateCompetitorDetails(olditemid: olditemid, newitemid: newitemid)
                                        }
                                    }
                                    if self.loadershow {
                                        self.updateprogress()
                                    }
                                }
                                self.postLog(tablename: "COMPETITORDETAIL", logstat: "success", syncdate: self.getTodaydatetime(), logid: "COMPETITORDETAIL")
                                }
                                if(AppDelegate.isDebug){
                                print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                    print("loader deactivated")
                                }
                                break
                                
                            case .failure(let error):
                                self.postLog(tablename: "COMPETITORDETAIL", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "COMPETITOR DETAIL")
                                if(AppDelegate.isDebug){
                                print("error=========> \(error)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                break
                            }
                            
                            //MARK:- cxhecking to call next postapi
                              if (i == j){
                                self.postCompetitorDetailPost3()
                                if(AppDelegate.isDebug){
                                print("next post call ======> ")
                                }
                                
                            }
                    }
                }
            }
            }
            else if (i==0){
                self.postCompetitorDetailPost3()
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    
    func postCompetitorDetailPost3()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            var stmt1:OpaquePointer?
            let queryString = "select * from COMPETITORDETAILPOST where post='0' "
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW)
            {
                let dataareaid = String(cString: sqlite3_column_text(stmt1, 0))
                let itemid = String(cString: sqlite3_column_text(stmt1, 2))
                let customercode = String(cString: sqlite3_column_text(stmt1, 1))
                let usercode = String(cString: sqlite3_column_text(stmt1, 4))
                let siteid = String(cString: sqlite3_column_text(stmt1, 3))
                var monthlysale = String(cString: sqlite3_column_text(stmt1, 9))
                if monthlysale == ""{
                    monthlysale = "0"
                }
                var qty = String(cString: sqlite3_column_text(stmt1, 8))
                if qty == ""{
                    qty = "0"
                }
                let ispreffered = String(cString: sqlite3_column_text(stmt1, 10))
                var reasonid = String(cString: sqlite3_column_text(stmt1, 7))
                if reasonid == ""{
                    reasonid = "-1"
                }
                var preffindex = String(cString: sqlite3_column_text(stmt1, 11))
                if preffindex == ""{
                    preffindex = "-1"
                }
                var brandname = String(cString: sqlite3_column_text(stmt1, 12))
                if brandname == ""{
                    brandname = "."
                }
                if(AppDelegate.isDebug){
                print("\n")
                }
                
                let parameters: [String: AnyObject] = [
                    "DATAAREAID" : dataareaid as AnyObject,
                    "ITEMID" : itemid as AnyObject,
                    "CUSTOMERCODE" : customercode as AnyObject,
                    "SITEID" : siteid as AnyObject,
                    "USERCODE" : usercode as AnyObject,
                    "MONTHLYSALE" : monthlysale as AnyObject,
                    "SALEQTY" : qty as AnyObject,
                    "ISPREFFERED" : ispreffered as AnyObject,
                    "REASONID" : reasonid as AnyObject,
                    "PREFFINDEX" : preffindex as AnyObject,
                    "COMPITITORDESC" : brandname as AnyObject,
                ]
                
                var a = json(from: parameters)
                if(AppDelegate.isDebug){
                print("\("CustCompititorDetailsPost3==="+a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_postCompetitorDetailPost3, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                            case .success(let value) :
                                if (response.response?.statusCode == 200){
                                self.updateCompetitorDetailsPost3(itemid: itemid, customercode: customercode)
                                self.postLog(tablename: "COMPETITORDETAILPOST", logstat: "success", syncdate: self.getTodaydatetime(), logid: "COMPETITORDETAILPOST")
                                }
                                if(AppDelegate.isDebug){
                                    print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                break
                                
                            case .failure(let error):
                                self.postLog(tablename: "COMPETITORDETAILPOST", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "COMPETITORDETAILPOST")
                                
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                print("error=========> \(error)")
                                }
                                break
                            }
                    }
                }
            }
            
            
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
        
    }
    
    
    
    func postObjectionEntry()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            
            var stmt1:OpaquePointer?
            
            let queryString = "SELECT * FROM ObjectionEntry WHERE post = '0'"
            //let URL_postinsalon = Constants.BASE_URL + Constants.URL_Postinsalon
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            //        DispatchQueue.global(qos: .userInitiated).async {
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                
                //                DATAAREAID,OBJECTIONID,OBJECTIONCODE,CUSTOMERCODE,SITEID,SUBMITTIME,LATITUDE,LONGITUDE,REMARKS,USERCODE,ISMOBILE
                let DATAAREAID = String(cString: sqlite3_column_text(stmt1, 0))
                let OBJECTIONID = String(cString: sqlite3_column_text(stmt1, 1))
                let OBJECTIONCODE = String(cString: sqlite3_column_text(stmt1, 2))
                let CUSTOMERCODE = String(cString: sqlite3_column_text(stmt1, 3))
                let SITEID = String(cString: sqlite3_column_text(stmt1, 4))
                let SUBMITTIME = String(cString: sqlite3_column_text(stmt1, 5))
                let LATITUDE = String(cString: sqlite3_column_text(stmt1, 8))
                let LONGITUDE = String(cString: sqlite3_column_text(stmt1, 9))
                let REMARKS = String(cString: sqlite3_column_text(stmt1, 7))
                let USERCODE = String(cString: sqlite3_column_text(stmt1, 10))
                if(AppDelegate.isDebug){
                print("\n")
                }
                let parameters: [String: AnyObject] = [
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    "OBJECTIONID" : OBJECTIONID as AnyObject,
                    "OBJECTIONCODE" : OBJECTIONCODE as AnyObject,
                    "CUSTOMERCODE" : CUSTOMERCODE as AnyObject,
                    "SITEID" : SITEID as AnyObject,
                    "SUBMITTIME" : SUBMITTIME as AnyObject,
                    "LATITUDE" : LATITUDE as AnyObject,
                    "LONGITUDE" : LONGITUDE as AnyObject,
                    "REMARKS" : REMARKS as AnyObject,
                    "USERCODE" : USERCODE as AnyObject,
                    "ISMOBILE" : "1" as AnyObject
                    
                ]
                var a = self.json(from: parameters)
                if(AppDelegate.isDebug){
                print("INS_ObjectionEntry ====> \(a!)")
                }
                
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostObjection, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                            case .success(let value) :
                                self.updateObjectionEntry(ObjectionCode: OBJECTIONID)
                                self.postLog(tablename: "ObjectionEntry", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Objection Entry")
                                if(AppDelegate.isDebug){
                                print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                break
                                
                            case .failure(let error):
                                //                                self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                                self.postLog(tablename: "ObjectionEntry", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Objection Entry")
                                
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                                
                                print("error=========> \(error)")
                                }
                                    break
                            }
                    }
                    
                }
                //            DispatchQueue.main.async {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //
                //                    // stop animating now that background task is finished
                //
                //                    self.view.isUserInteractionEnabled = true
                //                    print("loader deactivated")
                //                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                //                }
                //            }
                //            }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    //post secondary order
    
    func postSecondaryOrder()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            var stmt1:OpaquePointer?
            
            let queryString = "SELECT * FROM SOHEADER WHERE post = '0' AND approved = '1'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                var url: URL!
                
                let stringurl:String = constant.Base_url + "INS_XMLSO?UserCode="+UserDefaults.standard.string(forKey: "usercode")!+"&DataAreaId=" + UserDefaults.standard.string(forKey: "dataareaid")!
                url = URL(string: stringurl)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //parameter array
                var indno : String =  String(cString: sqlite3_column_text(stmt1, 2))
                
                let body: [[String: [AnyObject]]] = [
                    self.getSecondaryJsonHeader(sono: String(cString: sqlite3_column_text(stmt1, 2))) ,
                    self.getSecondaryJsonLine(sono: String(cString: sqlite3_column_text(stmt1, 2)))
                ]
                if(AppDelegate.isDebug){
                print("hello =====")
                print(json(from: body))
                print("\n")
                }
                request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
                if(AppDelegate.isDebug){
                print(body)
                }
                var a = self.json(from: body)
                if(AppDelegate.isDebug){
                print("postSecondaryOrder ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(request).validate().responseJSON { response in
                        switch (response.result) {
                        case .success:
                            if  let json = response.result.value{
                                
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        let syssono:String =  String (((listarray[i] as AnyObject).value(forKey:"syssono") as? String)!)
                                        let sono:String =  String (((listarray[i] as AnyObject).value(forKey:"sono") as? String)!)
                                        self.updateSecondaryOrder(sono: sono,syssono: syssono)
                                        self.postLog(tablename: "SOHEADER", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Secondary Order")
                                    }
                                    SwiftEventBus.post("sorderlist")
                                    self.view.isUserInteractionEnabled = true
                                    if(AppDelegate.isDebug){
                                    print("loader deactivated")
                                    }
                                    //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                    if self.loadershow {
                                        self.updateprogress()
                                    }
                                }
                                else {
                                    self.showtoast(controller: self, message: "Data Upload Error", seconds: 1.5)
                                }
                            }
                            
                            break
                            
                            
                        case .failure(let error):
                            self.postLog(tablename: "SOHEADER", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Secondary Order")
                            
                            self.view.isUserInteractionEnabled = true
                           if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                            
                            break
                        }
                    }
                }
                //            DispatchQueue.main.async {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //
                //                    // stop animating now that background task is finished
                //
                //                    self.view.isUserInteractionEnabled = true
                //                    print("loader deactivated")
                //                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                //                }
                //            }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func getSecondaryJsonHeader(sono: String?) -> [String: [AnyObject]] {
        var stmt1:OpaquePointer?
        
        let queryString = "select  USERID  ,A.SITEID  , SONO  , SODATE  , A.CUSTOMERCODE  , A.APPAPPROVEDATE  , A.LATITUDE  , A.LONGITUDE  , ifnull(B.gstinno,'') as DISTGSTNO  ,ifnull(C.gstno,'') as CUSTGSTNO  ,ifnull( A.DISTCOMPOSITIONSCHEME,'') as DISTCOMPOSITIONSCHEME , C.address as BILLADDRESS  , C.stateid as BILLSTATEID  ,A.approved  ,A.post,'' as REMARK  from SOHEADER  A left outer join USERDISTRIBUTOR B on  A.SITEID = B.siteid left outer join RetailerMaster C on A.CUSTOMERCODE = C.CUSTOMERCODE where A.approved= 1 and A.post = 0 and A.SONO= '\(sono!)'"
        //let queryString = "select  USERID  ,A.SITEID  , SONO  , SODATE  , A.CUSTOMERCODE  , A.APPAPPROVEDATE  , A.LATITUDE  , A.LONGITUDE  , B.gstinno as DISTGSTNO  ,C.gstno as CUSTGSTNO  , A.DISTCOMPOSITIONSCHEME  , C.address as BILLADDRESS  , C.stateid as BILLSTATEID  ,A.approved  ,A.post,A.REMARK as REMARK from SOHEADER  A left outer join USERDISTRIBUTOR B on  A.SITEID = B.siteid\n left outer join RetailerMaster C on A.CUSTOMERCODE = C.CUSTOMERCODE where A.approved= 1 and A.post = 0 "
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var indentHeaderb: [String: AnyObject] = [:]
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            indentHeaderb = [
                "USERID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "SITEID" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "SONO" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "SODATE" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "CUSTOMERCODE" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "APPAPPROVEDATE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "LATITUDE" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
                "LONGITUDE" : String(cString: sqlite3_column_text(stmt1, 7)) as AnyObject,
                "DISTGSTNO" : String(cString: sqlite3_column_text(stmt1, 8)) as AnyObject,
                "CUSTGSTNO" : String(cString: sqlite3_column_text(stmt1, 9)) as AnyObject,
                "DISTCOMPOSITIONSCHEME" : String(cString: sqlite3_column_text(stmt1, 10)) as AnyObject,
                "BILLADDRESS" : String(cString: sqlite3_column_text(stmt1, 11)) as AnyObject,
                "BILLSTATEID" : String(cString: sqlite3_column_text(stmt1, 12)) as AnyObject,
                "REMARK" : String(cString: sqlite3_column_text(stmt1, 14)) as AnyObject,
            ]
        }
        var body: [AnyObject] = []
        body.append(indentHeaderb as AnyObject)
        let indentHeader: [String: [AnyObject]] = ["Header": body ]
        
        return indentHeader
    }
    
    func getSecondaryJsonLine(sono: String?) -> [String: [AnyObject]] {
        var indentLine: [String: [AnyObject]] = [:]
        
        var stmt1: OpaquePointer?
        
        let query = "select SITEID ,SONO,LINENO ,CUSTOMERCODE,ITEMID ,QTY,RATE,LINEAMOUNT , DISCPERC , DISCAMT , DISCTYPE   ,case when  SECPERC ='' then 0 else SECPERC end as SECPERC , SECAMT , TAXABLEAMOUNT, TAX1COMPONENT , TAX1PERC, TAX1AMT   , TAX2COMPONENT, TAX2PERC, TAX2AMT, AMOUNT  from SOLINE WHERE sono= '\(sono!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var count:Int! = 1
        var body: [AnyObject] = []
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var line: [String: AnyObject] = [:]
            
            line = [
                "SITEID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "SONO" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "LINENO" : count as AnyObject,
                "CUSTOMERCODE" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "ITEMID" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "QTY" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "RATE" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
                "LINEAMOUNT" : String(cString: sqlite3_column_text(stmt1, 7)) as AnyObject,
                "DISCPERC" : String(cString: sqlite3_column_text(stmt1, 8)) as AnyObject,
                "DISCAMT" : String(cString: sqlite3_column_text(stmt1, 9)) as AnyObject,
                "DISCTYPE" : String(cString: sqlite3_column_text(stmt1, 10)) as AnyObject,
                "SECPERC" : String(cString: sqlite3_column_text(stmt1, 11)) as AnyObject,
                "SECAMT" : String(cString: sqlite3_column_text(stmt1, 12)) as AnyObject,
                "TAXABLEAMOUNT" : String(cString: sqlite3_column_text(stmt1, 13)) as AnyObject,
                "TAX1COMPONENT" : String(cString: sqlite3_column_text(stmt1, 14)) as AnyObject,
                "TAX1PERC" : String(cString: sqlite3_column_text(stmt1, 15)) as AnyObject,
                "TAX1AMT" : String(cString: sqlite3_column_text(stmt1, 16)) as AnyObject,
                "TAX2COMPONENT" : String(cString: sqlite3_column_text(stmt1, 17)) as AnyObject,
                "TAX2PERC" : String(cString: sqlite3_column_text(stmt1, 18)) as AnyObject,
                "TAX2AMT" : String(cString: sqlite3_column_text(stmt1, 19)) as AnyObject,
                "AMOUNT" : String(cString: sqlite3_column_text(stmt1, 20)) as AnyObject,
            ]
            count = count + 1
            body.append(line as AnyObject)
        }
        
        indentLine = [
            "LINE" : body
        ]
        return indentLine
    }
    
    
    func postNoOrderReason()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            var stmt1:OpaquePointer?
            
            let queryString = "SELECT * FROM NoOrderRemarksPost WHERE post = '0'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            //        DispatchQueue.global(qos: .userInitiated).async {
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                
                let DATAAREAID = String(cString: sqlite3_column_text(stmt1, 0))
                let STATUSID = String(cString: sqlite3_column_text(stmt1, 1))
                let REASONCODE = String(cString: sqlite3_column_text(stmt1, 2))
                let CUSTOMERCODE = String(cString: sqlite3_column_text(stmt1, 3))
                let SITEID = String(cString: sqlite3_column_text(stmt1, 4))
                let SUBMITTIME = String(cString: sqlite3_column_text(stmt1, 5))
                let REMARKS = String(cString: sqlite3_column_text(stmt1, 6))
                let LATITUDE = String(cString: sqlite3_column_text(stmt1, 7))
                let LONGITUDE = String(cString: sqlite3_column_text(stmt1, 8))
                let USERCODE = String(cString: sqlite3_column_text(stmt1, 9))
                if(AppDelegate.isDebug){
                print("\n")
                }
                let parameters: [String: AnyObject] = [
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    "STATUSID" : STATUSID as AnyObject,
                    "REASONCODE" : REASONCODE as AnyObject,
                    "CUSTOMERCODE" : CUSTOMERCODE as AnyObject,
                    "SITEID" : SITEID as AnyObject,
                    "SUBMITTIME" : SUBMITTIME as AnyObject,
                    "LATITUDE" : LATITUDE as AnyObject,
                    "LONGITUDE" : LONGITUDE as AnyObject,
                    "REMARKS" : REMARKS as AnyObject,
                    "USERCODE" : USERCODE as AnyObject,
                    "ISMOBILE" : "1" as AnyObject
                    
                ]
                var a = self.json(from: parameters)
               if(AppDelegate.isDebug){
                print("NoOrderRemarksPost ====> \(a!)")
                }
                
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostNoOrderReason, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            
                            self.stat = response.result.description as NSString
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            switch response.result {
                            case .success(let value) :
                                self.updateNoOrderReason(STATUSID: STATUSID)
                                if(AppDelegate.isDebug){
                                print("value ==========> \(value)")
                                }
                                self.postLog(tablename: "NoOrderRemarksPost", logstat: "success", syncdate: self.getTodaydatetime(), logid: "No Order Remark")
                                
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                break
                                
                            case .failure(let error):
                                //                                self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                                self.postLog(tablename: "NoOrderRemarksPost", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "No Order Remark")
                                
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                                if(AppDelegate.isDebug){
                                print("error=========> \(error)")
                                }
                                break
                            }
                    }
                    
                }
                //            DispatchQueue.main.async {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //
                //                    // stop animating now that background task is finished
                //
                //                    self.view.isUserInteractionEnabled = true
                //                    print("loader deactivated")
                //                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                //                }
                //            }
                //            }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    
    func postFeedbacks()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            view.isUserInteractionEnabled = false
            if(AppDelegate.isDebug){
            print("loader activated")
            }
            var stmt1:OpaquePointer?
            
            let queryString = "SELECT * FROM complains WHERE post = '0'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                 if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            //        DispatchQueue.global(qos: .userInitiated).async {
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                
                
                let DATAAREAID = String(cString: sqlite3_column_text(stmt1, 1))
                let FEEDBACKTYPE = String(cString: sqlite3_column_text(stmt1, 2))
                let CATEGORY = String(cString: sqlite3_column_text(stmt1, 3))
                let SITEID = String(cString: sqlite3_column_text(stmt1, 4))
                let ITEMID = String(cString: sqlite3_column_text(stmt1, 5))
                let FEEDBACKDESC = String(cString: sqlite3_column_text(stmt1, 6))
                let SUBMITDATETIME = String(cString: sqlite3_column_text(stmt1, 7))
                let CUSTOMERCODE = String(cString: sqlite3_column_text(stmt1, 8))
                let USERCODE = String(cString: sqlite3_column_text(stmt1, 9))
                let LATITUDE = String(cString: sqlite3_column_text(stmt1, 11))
                let LONGITUDE = String(cString: sqlite3_column_text(stmt1, 12))
                let COMPID = String(cString: sqlite3_column_text(stmt1, 0))
                let image = String(cString: sqlite3_column_text(stmt1, 14))
                if(AppDelegate.isDebug){
                print("\n")
                }
                let parameters: [String: AnyObject] = [
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    "FEEDBACKTYPE" : FEEDBACKTYPE as AnyObject,
                    "CATEGORY" : CATEGORY as AnyObject,
                    "SITEID" : SITEID as AnyObject,
                    "ITEMID" : ITEMID as AnyObject,
                    "FEEDBACKDESC" : FEEDBACKDESC as AnyObject,
                    "SUBMITDATETIME" : SUBMITDATETIME as AnyObject,
                    "CUSTOMERCODE" : CUSTOMERCODE as AnyObject,
                    "LATITUDE" : LATITUDE as AnyObject,
                    "LONGITUDE" : LONGITUDE as AnyObject,
                    "USERCODE" : USERCODE as AnyObject,
                    "ISMOBILE" : "1" as AnyObject,
                    "PRIORITY" : "High" as AnyObject,
                    "IMAGE" : image as AnyObject
                ]
                
                var a = self.json(from: parameters)
                if(AppDelegate.isDebug){
                print("FeedBackSubmitPostVersion2 ====> \(a!)")
                }
                
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_FeedBackSubmitPostVersion2, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                                switch response.result {
                            case .success(let value) :
                                //  self.updateNoOrderReason(STATUSID: STATUSID)
                                self.updateComplains(compid: COMPID)
                                self.postLog(tablename: "complains", logstat: "success", syncdate: self.getTodaydatetime(), logid: "complains")
                                if(AppDelegate.isDebug){
                                print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                break
                                
                            case .failure(let error):
                                //                                self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                                self.postLog(tablename: "complains", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "complains")
                               if(AppDelegate.isDebug){
                                print("error=========> \(error)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                //        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                break
                            }
                    }
                    
                }
                //            DispatchQueue.main.async {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //
                //                    // stop animating now that background task is finished
                //
                //                    self.view.isUserInteractionEnabled = true
                //                    print("loader deactivated")
                //                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                //                }
                //            }
                //            }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func postAttendence()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            view.isUserInteractionEnabled = false
            
            print("loader activated")
            
            var stmt1:OpaquePointer?
            
            let queryString = "SELECT * FROM Attendance WHERE post = '0'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                let DATAAREAID = String(cString: sqlite3_column_text(stmt1, 7))
                let ATTNID = String(cString: sqlite3_column_text(stmt1, 1))
                let USERCODE = UserDefaults.standard.string(forKey: "usercode")!
                let ATTNDATE = String(cString: sqlite3_column_text(stmt1, 4))
                let LATITUDE = String(cString: sqlite3_column_text(stmt1, 2))
                let LONGITUDE = String(cString: sqlite3_column_text(stmt1, 3))
                let RECID = "1"
                let CREATEDBY = UserDefaults.standard.string(forKey: "usercode")!
                let CREATEDTRANSACTIONID = "0"
                
                print("\n")
                let parameters: [String: AnyObject] = [
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    "ATTNID" : ATTNID as AnyObject,
                    "USERCODE" : USERCODE as AnyObject,
                    "ATTNDATE" : ATTNDATE as AnyObject,
                    "LATITUDE" : LATITUDE as AnyObject,
                    "LONGITUDE" : LONGITUDE as AnyObject,
                    "RECID" : RECID as AnyObject,
                    "CREATEDBY" : CREATEDBY as AnyObject,
                    "CREATEDTRANSACTIONID" : CREATEDTRANSACTIONID as AnyObject,
                ]
                var a = self.json(from: parameters)
                print("AttendancePost ====> \(a!)")
                
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostAttendance, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON { response in
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            
                            self.stat = response.result.description as NSString
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            switch response.result {
                            case .success(let value) :
                                self.updateAttendance(attendancedate: ATTNDATE)
                                print("value ==========> \(value)")
                                
                                self.postLog(tablename: "Attendance", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Attendance")
                                SwiftEventBus.post("attndone")
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                break
                                
                            case .failure(let error):
                                
                                print("error=========> \(error)")
                                self.postLog(tablename: "Attendance", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Attendance")
                                SwiftEventBus.post("attnnotdone")
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                break
                            }
                    }
                }
                
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func postPrimaryOrder()
    {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            view.isUserInteractionEnabled = false
            print("loader activated")
            
            var stmt1:OpaquePointer?
            let queryString = "SELECT SITEID,INDENTNO,INDENTDATE,PLANTCODE,LATITUDE,LONGITUDE from PURCHINDENTHEADER WHERE POST = '0' and STATUS = '1'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                var url: URL!
                
                let stringurl:String = constant.Base_url + "INS_XMLPRIMARY?UserCode="+UserDefaults.standard.string(forKey: "usercode")!+"&DataAreaId=" + UserDefaults.standard.string(forKey: "dataareaid")!+"&ISMOBILE=1"
                url = URL(string: stringurl)
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //parameter array
                var indno : String =  String(cString: sqlite3_column_text(stmt1, 1))
                let body: [[String: [AnyObject]]] = [
                    self.getIndentJsonHeader(indentno: String(cString: sqlite3_column_text(stmt1, 1))) ,
                    self.getIndentJsonLine(indentno: String(cString: sqlite3_column_text(stmt1, 1)))
                ]
                print("hello =====")
                print(json(from: body))
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
                print(body)
                DispatchQueue.main.async {
                    Alamofire.request(request).responseJSON { response in
                        switch (response.result) {
                        case .success:
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        let sysindentno:String =  String (((listarray[i] as AnyObject).value(forKey:"sysindentno") as? String)!)
                                        let indentno:String =  String (((listarray[i] as AnyObject).value(forKey:"indentno") as? String)!)
                                        
                                        self.updatePrimaryOrder(indentid: indentno,sysindentid: sysindentno)
                                        self.postLog(tablename: "PURCHINDENTHEADER", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Primary Order")
                                    }
                                    SwiftEventBus.post("porderlist")
                                    self.view.isUserInteractionEnabled = true
                                    print("loader deactivated")
                                    //                                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                }
                                else {
                                    self.showtoast(controller: self, message: "Data Upload Error", seconds: 1.5)
                                }
                                //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                                if self.loadershow {
                                    self.updateprogress()
                                }
                                self.postSecondaryOrder()
                            }
                            
                            break
                            
                            
                        case .failure(let error):
                            self.postLog(tablename: "PURCHINDENTHEADER", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Primary Order")
                            
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                            // self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                            self.postSecondaryOrder()
                            break
                        }
                    }
                }
            }
        }
        else {
            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
        }
    }
    
    func getIndentJsonHeader(indentno: String?) -> [String: [AnyObject]] {
        var stmt1:OpaquePointer?
        
        let queryString = "SELECT SITEID,INDENTNO,INDENTDATE,PLANTCODE,ifnull(LATITUDE,'0'),ifnull(LONGITUDE,'0') from PURCHINDENTHEADER WHERE POST = '0' and STATUS = '1' and INDENTNO='\(indentno!)' "
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var indentHeaderb: [String: AnyObject] = [:]
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            indentHeaderb = [
                "SITEID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "INDENTNO" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "INDENTDATE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "PLANTCODE" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "LATITUDE" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "LONGITUDE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "REMARK" : "" as AnyObject
            ]
            
        }
        var body: [AnyObject] = []
        body.append(indentHeaderb as AnyObject)
        let indentHeader: [String: [AnyObject]] = ["Header": body ]
        
        return indentHeader
    }
    
    func getIndentJsonLine(indentno: String?) -> [String: [AnyObject]] {
        var indentLine: [String: [AnyObject]] = [:]
        
        var stmt1: OpaquePointer?
        
        let query = "select INDENTNO, SITEID, LINENO,ITEMID  , QUANTITY  as QTY , RATE   , LINEAMOUNT  , TAX1PER  as TAX1PERC, TAX1AMT,   TAX1COMPONENT, TAX2PER  as TAX2PERC , TAX2AMT, TAX2COMPONENT, AMOUNT from PURCHINDENTLINE WHERE INDENTNO= '\(indentno!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        var count:Int! = 1
        var body: [AnyObject] = []
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var line: [String: AnyObject] = [:]
            
            line = [
                "INDENTNO" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "SITEID" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "LINENO" : count as AnyObject,
                "ITEMID" : String(cString: sqlite3_column_text(stmt1, 3)) as AnyObject,
                "QTY" : String(cString: sqlite3_column_text(stmt1, 4)) as AnyObject,
                "RATE" : String(cString: sqlite3_column_text(stmt1, 5)) as AnyObject,
                "LINEAMOUNT" : String(cString: sqlite3_column_text(stmt1, 6)) as AnyObject,
                "TAX1PERC" : String(cString: sqlite3_column_text(stmt1, 7)) as AnyObject,
                "TAX1AMT" : String(cString: sqlite3_column_text(stmt1, 8)) as AnyObject,
                "TAX1COMPONENT" : String(cString: sqlite3_column_text(stmt1, 9)) as AnyObject,
                "TAX2PERC" : String(cString: sqlite3_column_text(stmt1, 10)) as AnyObject,
                "TAX2AMT" : String(cString: sqlite3_column_text(stmt1, 11)) as AnyObject,
                "TAX2COMPONENT" : String(cString: sqlite3_column_text(stmt1, 12)) as AnyObject,
                "AMOUNT" : String(cString: sqlite3_column_text(stmt1, 13)) as AnyObject,
            ]
            count = count + 1
            body.append(line as AnyObject)
        }
        
        indentLine = [
            "LINE" : body
        ]
        return indentLine
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func postProductOfTheDay()
    {
        view.isUserInteractionEnabled = false
        
        print("loader activated")
        var stmt1:OpaquePointer?
        
        //    let queryString = "Select * from ProductDay where post = '0' and isapprove = '1'"
        let queryString = "Select * from ProductDay where post = '0'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var url: URL!
            
            let stringurl:String = constant.Base_url + "POSTPRODUCTOFTHEDAY"
            url = URL(string: stringurl)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var body: [String: AnyObject] = [:]
            //  let uid = String(cString: sqlite3_column_text(stmt1, 3))
            let itemgroupId = String(cString: sqlite3_column_text(stmt1, 1))
            body = [
                "DATAAREAID" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject,
                "ITEMGROUPID" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "USERCODE" : String(cString: sqlite3_column_text(stmt1, 2)) as AnyObject,
                "TRANSACTIONDATE" : self.getTodaydatetime() as AnyObject
                
            ]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
            var a = self.json(from: body)
            print("POSTPRODUCTOFTHEDAY ====> \(a!)")
            print(body)
            DispatchQueue.main.async {
                Alamofire.request(request).responseJSON { response in
                    
                    switch (response.result) {
                    case .success:
                        self.postLog(tablename: "Productday", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Product of the day")
                        self.updateproductday(itemgroupId: itemgroupId)
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                        if self.loadershow {
                            self.updateprogress()
                        }
                        
                        SwiftEventBus.post("productdaySucess")
                        break
                        
                    case .failure(let error):
                        self.postLog(tablename: "Productday", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Product of the day")
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        

                        SwiftEventBus.post("productdayFailure")
                        break
                    }
                }
            }
            //        DispatchQueue.main.async {
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //
            //                // stop animating now that background task is finished
            //
            //                self.view.isUserInteractionEnabled = true
            //                print("loader deactivated")
            //                self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
            //            }
            //        }
        }
    }
    
    func postWorkingArea()
    {
        view.isUserInteractionEnabled = false
        
        print("loader activated")
        
        var stmt1:OpaquePointer?
        
        let queryString = "Select * from UserCurrentCity where post = '0' "
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            var url: URL!
            
            let stringurl:String = constant.Base_url + "POSTUserDaywiseWorkingCity"
            url = URL(string: stringurl)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var body: [String: AnyObject] = [:]
            
            var date:String = String(cString: sqlite3_column_text(stmt1, 0))
            body = [
                "dataareaid" :  UserDefaults.standard.string(forKey: "dataareaid")! as AnyObject,
                "usercode" :  UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "CITYID" : String(cString: sqlite3_column_text(stmt1, 1)) as AnyObject,
                "WORKDATE" : String(cString: sqlite3_column_text(stmt1, 0)) as AnyObject
            ]
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
            print(body)
            DispatchQueue.main.async {
                Alamofire.request(request).responseJSON { response in
                    
                    switch (response.result) {
                    case .success:
                        self.updateWorkDate(Date: date)
                        self.postLog(tablename: "UserCurrentCity", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Working Area")
                        
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                        if self.loadershow {
                            self.updateprogress()
                        }
                         
                        // self.workingPostSuccess()

                        SwiftEventBus.post("workingareaSucess")
                        break
                        
                        
                    case .failure(let error):
                        self.postLog(tablename: "UserCurrentCity", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Working Area")
                        
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                        SwiftEventBus.post("workingareaFailure")
                         self.workingPostError()
                        break
                    }
                }
            }
            //        DispatchQueue.main.async {
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //
            //                // stop animating now that background task is finished
            //
            //                self.view.isUserInteractionEnabled = true
            //                print("loader deactivated")
            //                self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
            //            }
            //        }
        }
    }
    
    public func workingPostSuccess(){
        
    }
    public func workingPostError(){
        
    }

    
    func postExpense()
    {
        
        view.isUserInteractionEnabled = false
        
        print("loader activated")
        
        var stmt1:OpaquePointer?
        
        let queryString = "SELECT * FROM Expense WHERE post = '0'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryString, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        //        DispatchQueue.global(qos: .userInitiated).async {\
        DispatchQueue.main.async {
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                //Expense(expenseid ,expensedate ,location ,da ,ta ,hotelexpense ,miscellanous ,expenseimage ,expenseimage2 ,expenseimage3 ,expenseimage4 ,post ,workingtype )
                let expenseid = String(cString: sqlite3_column_text(stmt1, 0))
                let expensedate = String(cString: sqlite3_column_text(stmt1, 1))
                let da = String(cString: sqlite3_column_text(stmt1, 3))
                let ta = String(cString: sqlite3_column_text(stmt1, 4))
                let hotelexpense = String(cString: sqlite3_column_text(stmt1, 5))
                let miscellanous = String(cString: sqlite3_column_text(stmt1, 6))
                let expenseimage = String(cString: sqlite3_column_text(stmt1, 7))
                let expenseimage2 = String(cString: sqlite3_column_text(stmt1, 8))
                let expenseimage3 = String(cString: sqlite3_column_text(stmt1, 9))
                let expenseimage4 = String(cString: sqlite3_column_text(stmt1, 10))
                let workingtype = String(cString: sqlite3_column_text(stmt1, 12))
                
                let USERCODE = UserDefaults.standard.string(forKey: "usercode")!
                print("\n")
                //EXPENSEID,USERCODE,DATAAREAID,WORKINGTYPE,EXPENSEDATE,TAAMT,DAAMT,HOTELAMT,MISCAMT,IMAGE,IMAGE2,IMAGE3,IMAGE4
                
                let parameters: [String: AnyObject] = [
                    "EXPENSEID" : expenseid as AnyObject,
                    "DATAAREAID" : UserDefaults.standard.string(forKey: "dataareaid")! as AnyObject,
                    "USERCODE" : USERCODE as AnyObject,
                    "WORKINGTYPE" : workingtype as AnyObject,
                    "EXPENSEDATE" : expensedate as AnyObject,
                    "TAAMT" : ta as AnyObject,
                    "DAAMT" : da as AnyObject,
                    "HOTELAMT" : hotelexpense as AnyObject,
                    "MISCAMT" : miscellanous as AnyObject,
                    "IMAGE" : expenseimage as AnyObject,
                    "IMAGE2" : expenseimage2 as AnyObject,
                    "IMAGE3" : expenseimage3 as AnyObject,
                    "IMAGE4" : expenseimage4 as AnyObject,
                    "SUBMITDATE" : self.getTodaydatetime() as AnyObject,
                ]
                var a = self.json(from: parameters)
                // print("body========> \n\(a)")
                Alamofire.request(constant.Base_url + constant.URL_PostExpense, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .validate()
                    .responseJSON { response in
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        
                        self.stat = response.result.description as NSString
                        print("status =========>>>>>\(String(describing: self.stat!))")
                        switch response.result {
                        case .success(let value) :
                            self.updateExpense(expenseid: expenseid)
                            self.postLog(tablename: "Expense", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Expense")
                            print("value ==========> \(value)")
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                            //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                            if self.loadershow {
                                self.updateprogress()
                            }
                            
                            break
                            
                        case .failure(let error):
                            //                            self.showtoast(controller: self, message: "Upload Status: \(error.localizedDescription)", seconds: 2.0)
                            self.postLog(tablename: "Expense", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Expense")
                            print("error=========> \(error.localizedDescription)")
                            
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                            //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                            
                            break
                        }
                }
                
            }
            //            DispatchQueue.main.async {
            //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //
            //                    // stop animating now that background task is finished
            //
            //                    self.view.isUserInteractionEnabled = true
            //                    print("loader deactivated")
            //                    self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
            //                }
            //            }
            //        }
        }
    }
    
    func getcursorcount(query: String) -> Int32{
        var stmt1: OpaquePointer?
        var i: Int32 = 0 ;
        let querystr = "SELECT count(*) FROM \(query)"
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt1, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
            }
            return -1
        }
        if (sqlite3_step(stmt1) == SQLITE_ROW) {
            i = sqlite3_column_int(stmt1, 0)
        }
        if(AppDelegate.isDebug){
            print ("row count -[ \(querystr) ===> \(i) ]-")
        }
        return i
    }
    
    func getcursorcountNew(query: String) -> Int32{
        var stmt1: OpaquePointer?
        var i: Int32 = 0 ;
        let querystr = "SELECT count(*) FROM \(query)"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt1, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
            }
            return -1
        }
        
        if (sqlite3_step(stmt1) == SQLITE_ROW) {
            i = sqlite3_column_int(stmt1, 0)
        }
        if(AppDelegate.isDebug){
            print ("row count -[ \(querystr) ===> \(i) ]-")
        }
        return i
    }
    
    func posthospitalMaster()
    {
        view.isUserInteractionEnabled = false
        print("loader activated")
        var stmt1: OpaquePointer?
        var i:Int32 = 0
        var j:Int32 = 0
        let query = "SELECT * FROM HospitalMaster WHERE post = '0'"
        //MARK:- getting cursor count
        i = self.getcursorcount(query: "HospitalMaster WHERE post = '0'")
        if(i>0){
            if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK
            {
                    let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                    print("error preparing get: \(errmsg)")
                        return
            }
            while (sqlite3_step(stmt1) == SQLITE_ROW) {
                let DATAAREAID = String(cString: sqlite3_column_text(stmt1, 0))
                let TYPE = String(cString: sqlite3_column_text(stmt1, 1))
                let HOSCODE = String(cString: sqlite3_column_text(stmt1, 2))
                let HOSNAME = String(cString: sqlite3_column_text(stmt1, 3))
                let MOBILENO = String(cString: sqlite3_column_text(stmt1, 4))
                let ALTNUMBER = String(cString: sqlite3_column_text(stmt1, 5)) == "" ? "--" : String(cString: sqlite3_column_text(stmt1, 5))
                let EMAILID = String(cString: sqlite3_column_text(stmt1, 6)) == "" ? "--" : String(cString: sqlite3_column_text(stmt1, 6))
                let CityID = String(cString: sqlite3_column_text(stmt1, 7))
                let ADDRESS = String(cString: sqlite3_column_text(stmt1, 8)) == "" ? "--" : String(cString: sqlite3_column_text(stmt1, 8))
                let PINCODE = String(cString: sqlite3_column_text(stmt1, 9)) == "" ? "--" : String(cString: sqlite3_column_text(stmt1, 9))
                let STATEID = String(cString: sqlite3_column_text(stmt1, 10))
                let ISBLOCKED = String(cString: sqlite3_column_text(stmt1, 11))
                 let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 12))
                 let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 13))
                 let PURCHASEMGR = String(cString: sqlite3_column_text(stmt1, 15)) == "" ? "--" : String(cString: sqlite3_column_text(stmt1, 15))
                 let AUTHORISEDPERSON = String(cString: sqlite3_column_text(stmt1, 16)) == "" ? "--" : String(cString: sqlite3_column_text(stmt1, 16))
                 let PURCHMGRMOBILENO = String(cString: sqlite3_column_text(stmt1, 17)) == "" ? "." : String(cString: sqlite3_column_text(stmt1, 17))
                 let AUTHPERSONMOBILENO = String(cString: sqlite3_column_text(stmt1, 18)) == "" ? "." : String(cString: sqlite3_column_text(stmt1, 18))
                 let DEGISNATION = String(cString: sqlite3_column_text(stmt1, 19)) == "" ? "--" : String(cString: sqlite3_column_text(stmt1, 19))
                 let BEDCOUNT = String(cString: sqlite3_column_text(stmt1, 20))
                 let CATEGORY = String(cString: sqlite3_column_text(stmt1, 21))
                 let SITEID = String(cString: sqlite3_column_text(stmt1, 22)) == "" ? "." : String(cString: sqlite3_column_text(stmt1, 22))
                 // let HOSPITALTYPE = String(cString: sqlite3_column_text(stmt1, 23))
                 let ISPURCHASE = String(cString: sqlite3_column_text(stmt1, 24))
                 let MONTHLYPURCHASE = String(cString: sqlite3_column_text(stmt1, 25)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 25))
                //MARK:- increasing iteration counter
//                 j += 1
                let parameters: [String: AnyObject] = [
                    "DATAAREAID" : DATAAREAID as AnyObject,
                    "TYPE" : TYPE as AnyObject,
                    "CODE" : HOSCODE as AnyObject,
                    "NAME" : HOSNAME as AnyObject,
                    "MOBILENO" : MOBILENO as AnyObject,
                    "ALTERNATENO" : ALTNUMBER as AnyObject,
                    "EMAILID" : EMAILID as AnyObject,
                    "CITYID" : CityID as AnyObject,
                    "ADDRESS" : ADDRESS as AnyObject,
                    "PINCODE" : PINCODE as AnyObject,
                    "ISMOBILE" : "1" as AnyObject,
                    "STATEID" : STATEID as AnyObject,
                    "USERCODE" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                    "PURCHASEMGR" : PURCHASEMGR as AnyObject,
                    "AUTHORISEDPERSON" : AUTHORISEDPERSON as AnyObject,
                    "DEGISNATION" : DEGISNATION as AnyObject,
                    "BEDCOUNT" : BEDCOUNT as AnyObject,
                    "CATEGORY" : CATEGORY as AnyObject,
                    "SITEID" : SITEID as AnyObject,
                    "SECTOR" : "--" as AnyObject,
                    "HOSPITALTYPE" : "-1" as AnyObject,
                    "ISPURCHASE" : ISPURCHASE as AnyObject,
                    "PURCHMGRMOBILENO" : PURCHMGRMOBILENO as AnyObject,
                    "AUTHPERSONMOBILENO" : AUTHPERSONMOBILENO as AnyObject,
                    "MONTHLYPURCHASE" : MONTHLYPURCHASE as AnyObject,
                ]
                var a = self.json(from: parameters)
                if(AppDelegate.isDebug){
                    print("HospitalMaster3 ====> \(a!)")
                }
                
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostHospitalMaster, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                         .responseJSON {
                            response in
                            if(AppDelegate.isDebug){
                                print("Response =========>>>>\(response.response as Any)")
                                print("Error ============>>>>\(response.error as Any)")
                                print("Data =============>>>>\(response.data as Any)")
                                print("Result =========>>>>>\(response.result)")
                            }
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                                print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                            case .success(let value) :
                                if  let json = response.result.value{
                                    let listarray : NSArray = json as! NSArray
                                    if listarray.count > 0 {
                                        for i in 0..<listarray.count{
                                              j += 1
                                            let oldid = HOSCODE
                                                    let newid = String (((listarray[i] as AnyObject).value(forKey:"syshoscode") as? String)!)
                                            self.updateHospitalMaster(oldhosid: oldid, newhosid: newid)
                                                                                                                                            }
                                                }
                                        if self.loadershow {
                                            self.updateprogress()
                                            }
                                }
                                self.postLog(tablename: "HospitalMaster", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Hospital Master")
                                if(AppDelegate.isDebug){
                                    print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                    print("loader deactivated")
                                }
                                break
                                        case .failure(let error):
                                    j += 1
                                    self.postLog(tablename: "HospitalMaster", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Hospital Master")
                                    if(AppDelegate.isDebug){
                                        print("error=========> \(error)")
                                    }
                                    self.view.isUserInteractionEnabled = true
                                    if(AppDelegate.isDebug){
                                        print("loader deactivated")
                                    }
                                break
                            }
                            //MARK:- cxhecking to call next postapi
                            if (i == j){
                                self.postDoctorMaster()
                                if(AppDelegate.isDebug){
                                    print("next post call ======> ")
                                }
                            }
                                }
                        }
                    }
        }
        else if (i==0){
            self.postDoctorMaster()
        }
    }
    
    func postDoctorMaster()
    {
        view.isUserInteractionEnabled = false
        print("loader activated")
        var stmt1: OpaquePointer?
        var i:Int32 = 0
        var j:Int32 = 0
        let query = "SELECT * FROM DRMASTER WHERE post = '0'"
        i = self.getcursorcount(query: "DRMASTER WHERE post = '0'")
        if(i>0){
            if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                 return
            }
            
            while (sqlite3_step(stmt1) == SQLITE_ROW) {
                let dataareaid = String(cString: sqlite3_column_text(stmt1, 0))
                let drcode = String(cString: sqlite3_column_text(stmt1, 1))
                let drname = String(cString: sqlite3_column_text(stmt1, 2))
                let mobileno = String(cString: sqlite3_column_text(stmt1, 3))
                let alternateno = String(cString: sqlite3_column_text(stmt1, 4))
                let emailid = String(cString: sqlite3_column_text(stmt1, 5))
                let address = String(cString: sqlite3_column_text(stmt1, 6))
                let pincode = String(cString: sqlite3_column_text(stmt1, 7))
                let city = String(cString: sqlite3_column_text(stmt1, 8))
                let stateid = String(cString: sqlite3_column_text(stmt1, 9))
                let dob = String(cString: sqlite3_column_text(stmt1, 10))
                let doa = String(cString: sqlite3_column_text(stmt1, 11))
                let isblocked = String(cString: sqlite3_column_text(stmt1, 12))
                let ispurchaseing = String(cString: sqlite3_column_text(stmt1, 13))
                let ispriscription = String(cString: sqlite3_column_text(stmt1, 14))
                let CREATEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 15))
                let MODIFIEDTRANSACTIONID = String(cString: sqlite3_column_text(stmt1, 16))
                let drspecialization = String(cString: sqlite3_column_text(stmt1, 18))
                let purchaseamt = String(cString: sqlite3_column_text(stmt1, 19)) == "" ? "0" : String(cString: sqlite3_column_text(stmt1, 19))
                let noofprescription = String(cString: sqlite3_column_text(stmt1, 20))
                let siteid = String(cString: sqlite3_column_text(stmt1, 21))
                let isbuying = String(cString: sqlite3_column_text(stmt1, 22))
                let drtype = String(cString: sqlite3_column_text(stmt1, 23))
               if(AppDelegate.isDebug){
                print("\n")
                }
                //MARK:- increasing iteration counter
//                j += 1;
                
                let parameters: [String: AnyObject] = [
                    "dataareaid" : dataareaid as AnyObject,
                    "drcode" : drcode as AnyObject,
                    "drname" : drname as AnyObject,
                    "mobileno" : mobileno as AnyObject,
                    "alternateno" : alternateno as AnyObject,
                    "emailid" : emailid as AnyObject,
                    "address" : address as AnyObject,
                    "pincode" : pincode as AnyObject,
                    "city" : city as AnyObject,
                    "stateid" : stateid as AnyObject,
                    "doa" : doa as AnyObject,
                    "dob" : dob as AnyObject,
                    "usercode" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                    "ispurchaseing" : ispurchaseing as AnyObject,
                    "ispriscription" : ispriscription as AnyObject,
                    "ISBUYING" : isbuying as AnyObject,
                    "SITEID" : siteid as AnyObject,
                    "NOOFPRESCRIPTION" : noofprescription as AnyObject,
                    "PURCHASEAMT" : purchaseamt as AnyObject,
                    "DRSPECIALIZATION" : drspecialization as AnyObject,
                    "DRTYPE" : drtype as AnyObject,
                ]
                var a = self.json(from: parameters)
                if(AppDelegate.isDebug){
                print("DoctorMasterPost2 ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostDoctorMaster, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON {
                            response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                                
                            case .success(let value) :
                                
                                if  let json = response.result.value{
                                    let listarray : NSArray = json as! NSArray
                                    if listarray.count > 0 {
                                        for i in 0..<listarray.count{
                                            j += 1;
                                            let oldid = drcode
                                            let newid = String (((listarray[i] as AnyObject).value(forKey:"sysdrcode") as? String)!)
                                            self.updateDoctorMaster(olddocid: oldid, newdocid: newid)
                                        }
                                    }
                                    if self.loadershow {
                                        self.updateprogress()
                                    }
                                }
                                self.postLog(tablename: "DRMASTER", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Doctor Master")
                             if(AppDelegate.isDebug){
                                print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                              if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                break
                                
                            case .failure(let error):
                                 j += 1;
                                self.postLog(tablename: "DRMASTER", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Doctor Master")
                                if(AppDelegate.isDebug){
                                print("error=========> \(error)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                break
                            }
                            
                            //MARK:- cxhecking to call next postapi
                      if (i == j){
                        self.postRetailerMaster()
                        if(AppDelegate.isDebug){
                      print("next post call ======> ")
                          }
                            }
                    }
                }
            }
        }
        else if (i==0){
            self.postRetailerMaster()
        }
        
    }
    
    func postOnDoctor()
    {
        self.postHospitalDrLinking()
        self.postCustHospitalLinking()
        self.postmiimage()
        self.postNoOrderReason()
        self.postSecondaryOrder()
        self.postmarketescalation()
        self.postFeedbacks()
        self.postCustDRLinking()
        self.postObjectionEntry()
        self.postdealerconversion()
        self.postCompetitorDetail()
      //  self.postCompetitorDetailPost3()
        
        if (AppDelegate.issync == 0){
            self.postRemainingApis()
        }else{
            self.postRemaining()
        }
    }
    
    // As per Android
    //    func postOnDoctor()
    //       {
    //
    //           self.postHospitalDrLinking()
    //           self.postCustHospitalLinking()   //Addded
    //           self.postCustDRLinking()
    //           self.postmiimage()
    //           self.postNoOrderReason()
    //           self.postCompetitorDetail()
    //           self.postCompetitorDetailPost3()
    //           self.postdealerconversion()
    //           self.postObjectionEntry()
    //           self.postmarketescalation()
    //           self.postFeedbacks()
    //           self.postSecondaryOrder()
    //           self.postAttendence()
    
    
    //           if (AppDelegate.issync == 0){
    //               self.postRemainingApis()
    //           }else{
    //               self.postRemaining()
    //           }
    //     }
    
    func postRetailerMaster()
    {
        
        view.isUserInteractionEnabled = false
        if(AppDelegate.isDebug){
        print("loader activated")
        }
        var stmt1: OpaquePointer?
        
        var i:Int32 = 0
        var j:Int32 = 0
        
        let query = "SELECT * FROM RetailerMaster WHERE post = '0'"
        
        
        i = self.getcursorcount(query: "RetailerMaster WHERE post = '0'")
        if(i>0){
            
            if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
                }
                return
            }
            
            while (sqlite3_step(stmt1) == SQLITE_ROW) {
                
                let customercode = String(cString: sqlite3_column_text(stmt1, 0))
                let customername = String(cString: sqlite3_column_text(stmt1, 1))
                let customertype = String(cString: sqlite3_column_text(stmt1, 2))
                let contactperson = String(cString: sqlite3_column_text(stmt1, 3))
                let mobilecustcode = String(cString: sqlite3_column_text(stmt1, 4))
                let mobileno = String(cString: sqlite3_column_text(stmt1, 5))
                let alternateno = String(cString: sqlite3_column_text(stmt1, 6))
                let emailid = String(cString: sqlite3_column_text(stmt1, 7))
                let address = String(cString: sqlite3_column_text(stmt1, 8))
                let pincode = String(cString: sqlite3_column_text(stmt1, 9))
                let city = String(cString: sqlite3_column_text(stmt1, 10))
                let stateid = String(cString: sqlite3_column_text(stmt1, 11))
                let gstno = String(cString: sqlite3_column_text(stmt1, 12))
                let gstregistrationdate = String(cString: sqlite3_column_text(stmt1, 13))
                let siteid = String(cString: sqlite3_column_text(stmt1, 14))
                let salepersonid = String(cString: sqlite3_column_text(stmt1, 15))
                let keycustomer = String(cString: sqlite3_column_text(stmt1, 16))
                let isorthopositive = String(cString: sqlite3_column_text(stmt1, 17))
                let sizeofretailer = String(cString: sqlite3_column_text(stmt1, 18))
                let category = String(cString: sqlite3_column_text(stmt1, 19))
                let isblocked = String(cString: sqlite3_column_text(stmt1, 20))
                let pricegroup = String(cString: sqlite3_column_text(stmt1, 21))
                let dataareaid = String(cString: sqlite3_column_text(stmt1, 22))
                let latitude = String(cString: sqlite3_column_text(stmt1, 23))
                let longitude = String(cString: sqlite3_column_text(stmt1, 24))
                let orthopedicsale = String(cString: sqlite3_column_text(stmt1, 25))
                let avgsale = String(cString: sqlite3_column_text(stmt1, 26))
                let prefferedbrand = String(cString: sqlite3_column_text(stmt1, 27))
                let secprefferedbrand = String(cString: sqlite3_column_text(stmt1, 28))
                let secprefferedsale = String(cString: sqlite3_column_text(stmt1, 29))
                let prefferedsale = String(cString: sqlite3_column_text(stmt1, 30))
                let prefferedreasonid = String(cString: sqlite3_column_text(stmt1, 31))
                let secprefferedreasonid = String(cString: sqlite3_column_text(stmt1, 32))
                let createdtransactionid = String(cString: sqlite3_column_text(stmt1, 33))
                let modifiedtransactionid = String(cString: sqlite3_column_text(stmt1, 34))
                let referencecode = String(cString: sqlite3_column_text(stmt1, 36))
                let lastvisited = String(cString: sqlite3_column_text(stmt1, 37))
                let storeimage = String(cString: sqlite3_column_text(stmt1, 38))
                let stockimage = String(cString: sqlite3_column_text(stmt1, 39))
                let prefferedothbrand = String(cString: sqlite3_column_text(stmt1, 40))
                let secprefferedothbrand = String(cString: sqlite3_column_text(stmt1, 41))
                
               if(AppDelegate.isDebug){
                print("\n")
                }
                //MARK:- increasing iteration counter
//                j += 1
                let parameters: [String: AnyObject] = [
                    "CUSTOMERCODE" : customercode as AnyObject,
                    "CUSTOMERNAME" : customername as AnyObject,
                    "CUSTOMERTYPE" : customertype as AnyObject,
                    "CONTACTPERSON" : contactperson as AnyObject,
                    "MOBILENO" : mobileno as AnyObject,
                    "ALTERNATENO" : alternateno as AnyObject,
                    "EMAILID" : emailid as AnyObject,
                    "ADDRESS" : address as AnyObject,
                    "PINCODE" : pincode as AnyObject,
                    "CITY" : city as AnyObject,
                    "STATEID" : stateid as AnyObject,
                    "GSTNO" : gstno as AnyObject,
                    "GSTREGISTRATIONDATE" : "1900-01-01" as AnyObject,
                    "SITEID" : siteid as AnyObject,
                    "SALEPERSONID" : salepersonid as AnyObject,
                    "KEYCUSTOMER" : keycustomer as AnyObject,
                    "ISORTHOPOSITIVE" : isorthopositive as AnyObject,
                    "SIZEOFRETAILER" : sizeofretailer as AnyObject,
                    "CATEGORY" : category as AnyObject,
                    "DATAAREAID" : UserDefaults.standard.string(forKey: "dataareaid") as AnyObject,
                    "LATITUDE" : latitude as AnyObject,
                    "LONGITUDE" : longitude as AnyObject,
                    "ORTHOPEDICSALE" : orthopedicsale as AnyObject,
                    "AVGSALE" : avgsale as AnyObject,
                    "PREFFEREDBRAND" : prefferedbrand as AnyObject,
                    "SECPREFFEREDBRAND" : secprefferedbrand as AnyObject,
                    "SECPREFFEREDSALE" : secprefferedsale as AnyObject,
                    "PREFFEREDSALE" : prefferedsale as AnyObject,
                    "PREFFEREDREASONID" : prefferedreasonid as AnyObject,
                    "SECPREFFEREDREASONID" : secprefferedreasonid as AnyObject,
                    "USERCODE" : UserDefaults.standard.string(forKey: "usercode") as AnyObject,
                    "ISMOBILE" : "1" as AnyObject,
                    "MOBILECUSTCODE" : customercode as AnyObject,
                    "REFERENCECODE" : referencecode as AnyObject,
                    "PREFFEREDOTHBRAND" : prefferedothbrand as AnyObject,
                    "SECPREFFEREDOTHBRAND" : secprefferedothbrand as AnyObject,
                ]
                var a = self.json(from: parameters)
                if(AppDelegate.isDebug){
                print("CustMasterPost ====> \(a!)")
                }
                DispatchQueue.main.async {
                    Alamofire.request(constant.Base_url + constant.URL_PostRetailerMaster, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .validate()
                        .responseJSON {
                            response in
                            if(AppDelegate.isDebug){
                            print("Response =========>>>>\(response.response as Any)")
                            print("Error ============>>>>\(response.error as Any)")
                            print("Data =============>>>>\(response.data as Any)")
                            print("Result =========>>>>>\(response.result)")
                            }
                            self.stat = response.result.description as NSString
                            if(AppDelegate.isDebug){
                            print("status =========>>>>>\(String(describing: self.stat!))")
                            }
                            switch response.result {
                            case .success(let value) :
                                if  let json = response.result.value{
                                    let listarray : NSArray = json as! NSArray
                                    if listarray.count > 0 {
                                        for i in 0..<listarray.count{
                                            j += 1
                                            let oldid = customercode
                                            let newid = String (((listarray[i] as AnyObject).value(forKey:"syscustomercode") as? String)!)
                                            self.updateRetailerMaster(oldcusid: oldid, newcusid: newid)
                                        }
                                    }
                                    if self.loadershow {
                                        self.updateprogress()
                                    }
                                }
                                self.postLog(tablename: "RetailerMaster", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Retailer Master")
                                if(AppDelegate.isDebug){
                                print("value ==========> \(value)")
                                }
                                self.view.isUserInteractionEnabled = true
                                if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                break
                            case .failure(let error):
                                j += 1
                                self.postLog(tablename: "RetailerMaster", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Retailer Master")
                                if(AppDelegate.isDebug){
                                print("error=========> \(error)")
                                }
                                self.view.isUserInteractionEnabled = true
                               if(AppDelegate.isDebug){
                                print("loader deactivated")
                                }
                                break
                            }
                            //MARK:- cxhecking to call next postapi
                            if (i == j){
                                self.postOnDoctor()
                                print("next post call ======> ")
                            }
                    }
                }
            }
        }
        else if (i==0){
            self.postOnDoctor()
        }
        
    }
    func postHospitalDrLinking()
    {
        view.isUserInteractionEnabled = false
        if(AppDelegate.isDebug){
        print("loader activated")
        }
        var i:Int32 = 0
        var j:Int32 = 0
        
        
        var stmt1: OpaquePointer?
        
        let query = "select  A.DATAAREAID,HOSPITALCODE,A.DRCODE,CREATEDBY  from HospitalDRLinking A inner join HospitalMaster B on A.hospitalcode = B.HOSCODE inner join DRMASTER C on A.drcode = C.drcode where  A.post='0' and B.post = '2' and C.POST='2' "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            
            
            let DATAAREAID = String(cString: sqlite3_column_text(stmt1, 0))
            let HOSPITALCODE = String(cString: sqlite3_column_text(stmt1, 1))
            let DRCODE = String(cString: sqlite3_column_text(stmt1, 2))
            if(AppDelegate.isDebug){
            print("\n")
            }
            //DATAAREAID,HOSPITALCODE,DRCODE,USERCODE,RECID,ISMOBILE
            let parameters: [String: AnyObject] = [
                "DATAAREAID" : DATAAREAID as AnyObject,
                "HOSPITALCODE" : HOSPITALCODE as AnyObject,
                "DRCODE" : DRCODE as AnyObject,
                "USERCODE" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "RECID" : "1" as AnyObject,
                "ISMOBILE" : "1" as AnyObject,
            ]
            
            var a = self.json(from: parameters)
            if(AppDelegate.isDebug){
            print("HOSPITALDRLINKING====> \(a!)")
            }
            DispatchQueue.main.async {
                Alamofire.request(constant.Base_url + constant.URL_PosthospitalDrlinking, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .validate()
                    .responseJSON {
                        response in
                        if(AppDelegate.isDebug){
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        }
                        self.stat = response.result.description as NSString
                        if(AppDelegate.isDebug){
                        print("status =========>>>>>\(String(describing: self.stat!))")
                        }
                        switch response.result {
                            
                        case .success(let value) :
                            
                            self.postLog(tablename: "HospitalDRLinking", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Hospital Doctor Linking")
                            if(AppDelegate.isDebug){
                            print("value ==========> \(value)")
                            }
                            self.view.isUserInteractionEnabled = true
                            if(AppDelegate.isDebug){
                                print("loader deactivated")
                                
                            }
                            //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                            if self.loadershow {
                                self.updateprogress()
                            }
                            self.UpdateHospitalDRLinking(hospitalcode: HOSPITALCODE, doccode: DRCODE)
                            break
                            
                        case .failure(let error):
                            //                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.postLog(tablename: "HospitalDRLinking", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Hospital Doctor Linking")
                            if(AppDelegate.isDebug){
                            print("error=========> \(error)")
                            }
                            self.view.isUserInteractionEnabled = true
                            if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                            
                            break
                        }
                        
                }
                
            }
            
        }
        
        
    }
    
    
    func postCustDRLinking()
    {
        view.isUserInteractionEnabled = false
        if(AppDelegate.isDebug){
        print("loader activated")
        }
        var stmt1: OpaquePointer?
        
        let query = "select distinct A.dataareaid,A.customercode,A.drcode,B.ispurchaseing ,B.ispriscription ,C.siteid from userDrCustLinking A  inner join DRMASTER B on A.drcode = B.drcode   inner join RetailerMaster C on A.customercode = C.customercode where A.post = '0' and B.POST='2' and C.post='2'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            
            let dataareaid = String(cString: sqlite3_column_text(stmt1, 0))
            let customercode = String(cString: sqlite3_column_text(stmt1, 1))
            let drcode = String(cString: sqlite3_column_text(stmt1, 2))
            let ispurchaseing = String(cString: sqlite3_column_text(stmt1, 3))
            let ispriscription = String(cString: sqlite3_column_text(stmt1, 4))
            let siteid = String(cString: sqlite3_column_text(stmt1, 5))
            if(AppDelegate.isDebug){
            print("\n")
            }
            let parameters: [String: AnyObject] = [
                "DATAAREAID" : dataareaid as AnyObject,
                "SITEID" : siteid as AnyObject,
                "CUSTOMERCODE" : customercode as AnyObject,
                "USERCODE" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "DRCODE" : drcode as AnyObject,
                "ISPURCHASEING" : ispurchaseing as AnyObject,
                "ISPRISCRIPTION" : ispriscription as AnyObject,
                "ISMOBILE" : "1" as AnyObject
            ]
            
            var a = self.json(from: parameters)
            if(AppDelegate.isDebug){
            print("DoctorCustomerLinking ====> \(a!)")
            }
            DispatchQueue.main.async {
                Alamofire.request(constant.Base_url + constant.URL_PostDoctorCustomerLinking, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .validate()
                    .responseJSON {
                        response in
                        if(AppDelegate.isDebug){
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        }
                        self.stat = response.result.description as NSString
                        if(AppDelegate.isDebug){
                        print("status =========>>>>>\(String(describing: self.stat!))")
                        }
                        switch response.result {
                            
                        case .success(let value) :
                            
                            self.postLog(tablename: "userDrCustLinking", logstat: "success", syncdate: self.getTodaydatetime(), logid: "doctor customer Linking")
                            if(AppDelegate.isDebug){
                            print("value ==========> \(value)")
                            }
                            self.view.isUserInteractionEnabled = true
                           if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                            if self.loadershow {
                                self.updateprogress()
                            }
                            self.UpdateDocCustomerLinking(customercode: customercode, doccode: drcode )
                            break
                            
                        case .failure(let error):
                            //                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.postLog(tablename: "userDrCustLinking", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "doctor customer Linking")
                            if(AppDelegate.isDebug){
                            print("error=========> \(error)")
                            }
                            self.view.isUserInteractionEnabled = true
                            if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                            
                            break
                        }   }  } }
    }
    
    func postmiimage()
    {
        view.isUserInteractionEnabled = false
        if(AppDelegate.isDebug){
        print("loader activated")
        }
        var stmt1: OpaquePointer?
        
        let query = "SELECT ids , userId ,dataareaid ,customercode ,siteid ,post ,storestockimage ,type ,getdate ,latitude ,longitude FROM storeimage where post = '0'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
            print("error preparing get: \(errmsg)")
            }
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            
            let dataareaid = String(cString: sqlite3_column_text(stmt1, 2))
            let customercode = String(cString: sqlite3_column_text(stmt1, 3))
            let date = String(cString: sqlite3_column_text(stmt1, 8))
            let filetype = String(cString: sqlite3_column_text(stmt1, 7))
            let imagefile = String(cString: sqlite3_column_text(stmt1, 6))
            let lat = String(cString: sqlite3_column_text(stmt1, 9))
            let longi = String(cString: sqlite3_column_text(stmt1, 10))
            let usercode = String(cString: sqlite3_column_text(stmt1, 1))
            let siteid = String(cString: sqlite3_column_text(stmt1, 4))
            let id = String(cString: sqlite3_column_text(stmt1, 0))
            if(AppDelegate.isDebug){
            print("\n")
            }
            let parameters: [String: AnyObject] = [
                "DATAAREAID" : dataareaid as AnyObject,
                "SITEID" : siteid as AnyObject,
                "CUSTOMERCODE" : customercode as AnyObject,
                "USERCODE" : usercode as AnyObject,
                "IMAGETYPE" : filetype as AnyObject,
                "IMAGEFILE" : imagefile as AnyObject,
                "CAPTUREDATETIME" : date as AnyObject,
                "LONGITUDE" : longi as AnyObject,
                "LATITUDE" : lat as AnyObject,
                
                //CUSTOMERCODE      SITEID      DATAAREAID      IMAGETYPE       IMAGEFILE
                //CAPTUREDATETIME       USERCODE        LATITUDE        LONGITUDE
            ]
            var a = self.json(from: parameters)
            if(AppDelegate.isDebug){
            print("MIImageVersion2====> \(a!)")
            }
            DispatchQueue.main.async {
                Alamofire.request(constant.Base_url + constant.URL_postmiimage, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .validate()
                    .responseJSON {
                        response in
             if(AppDelegate.isDebug){
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        }
                        self.stat = response.result.description as NSString
                        if(AppDelegate.isDebug){
                        print("status =========>>>>>\(String(describing: self.stat!))")
                        }
                        switch response.result {
                            
                        case .success(let value) :
                            
                            self.postLog(tablename: "storeimage", logstat: "success", syncdate: self.getTodaydatetime(), logid: "Stock and store Image post")
                         if(AppDelegate.isDebug){
                            print("value ==========> \(value)")
                            }
                            self.updatestoreimage(id: id)
                            self.view.isUserInteractionEnabled = true
                            if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                            if self.loadershow {
                                self.updateprogress()
                            }
                            
                            break
                            
                        case .failure(let error):
                            //                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.postLog(tablename: "storeimage", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "Stock and store Image post")
                            if(AppDelegate.isDebug){
                            print("error=========> \(error)")
                            }
                            self.view.isUserInteractionEnabled = true
                           if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                            //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                            
                            break
                        }
                        
                }  } }
    }
    func postCustHospitalLinking()
    {
        view.isUserInteractionEnabled = false
        if(AppDelegate.isDebug){
        print("loader activated")
        }
        var stmt1: OpaquePointer?
        
        let query = "select  A.DATAAREAID,A.SITEID,A.CUSTOMERCODE,A.HOSPITALCODE from CUSTHOSPITALLINKING A  inner join RetailerMaster B on A.CUSTOMERCODE = B.customercode  inner join HospitalMaster C on A.HOSPITALCODE = C.HOSCODE  where A.post = '0' and B.POST='2' and C.post='2'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            if(AppDelegate.isDebug){
                print("error preparing get: \(errmsg)")
            }
            return
        }
        
        while (sqlite3_step(stmt1) == SQLITE_ROW) {
            
            let dataareaid = String(cString: sqlite3_column_text(stmt1, 0))
            let siteid = String(cString: sqlite3_column_text(stmt1, 1))
            let customercode = String(cString: sqlite3_column_text(stmt1, 2))
            let hoscode = String(cString: sqlite3_column_text(stmt1, 3))
            let ispurchaseing = "0"
            let ispriscription = "0"
            
            if(AppDelegate.isDebug){
            print("\n")
            }
            let parameters: [String: AnyObject] = [
                "DATAAREAID" : dataareaid as AnyObject,
                "SITEID" : siteid as AnyObject,
                "CUSTOMERCODE" : customercode as AnyObject,
                "HOSPITALCODE" : hoscode as AnyObject,
                "ISPURCHASEING" : ispurchaseing as AnyObject,
                "ISPRISCRIPTION" : ispriscription as AnyObject,
                "USERCODE" : UserDefaults.standard.string(forKey: "usercode")! as AnyObject,
                "ISMOBILE" : "1" as AnyObject
            ]
            
            var a = self.json(from: parameters)
           if(AppDelegate.isDebug){
            print("CustHospitalLinking====> \(a!)")
            }
            DispatchQueue.main.async {
                
                Alamofire.request(constant.Base_url + constant.URL_postCustHospitalLinking, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .validate()
                    .responseJSON {
                        
                        response in
                        if(AppDelegate.isDebug){
                        print("Response =========>>>>\(response.response as Any)")
                        print("Error ============>>>>\(response.error as Any)")
                        print("Data =============>>>>\(response.data as Any)")
                        print("Result =========>>>>>\(response.result)")
                        }
                        self.stat = response.result.description as NSString
                        if(AppDelegate.isDebug){
                        print("status =========>>>>>\(String(describing: self.stat!))")
                        }
                        switch response.result {
                            
                        case .success(let value) :
                            
                            self.postLog(tablename: "updateCUSTHOSPITALLINKING", logstat: "success", syncdate: self.getTodaydatetime(), logid: "updateCUSTHOSPITALLINKING")
                            if(AppDelegate.isDebug){
                            print("value ==========> \(value)")
                            }
                            SwiftEventBus.post("updateCUSTHOSPITALLINKING")
                            self.view.isUserInteractionEnabled = true
                            if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                        self.showtoast(controller: self, message: " Data is Uploaded", seconds: 1.0)
                            if self.loadershow {
                                self.updateprogress()
                            }
                            self.UpdateCUSTHOSPITALLINKING(customercode: customercode, hoscode: hoscode )
                            break
                            
                        case .failure(let error):
                            //                            self.showtoast(controller: self, message: "Upload Status: \(error)", seconds: 2.0)
                            self.postLog(tablename: "updateCUSTHOSPITALLINKING", logstat: error.localizedDescription, syncdate: self.getTodaydatetime(), logid: "updateCUSTHOSPITALLINKING")
                            if(AppDelegate.isDebug){
                            print("error=========> \(error)")
                            }
                            SwiftEventBus.post("updateCUSTHOSPITALLINKINGNOT")
                            self.view.isUserInteractionEnabled = true
                           if(AppDelegate.isDebug){
                            print("loader deactivated")
                            }
                            //                            self.showtoast(controller: self, message: " Data is not Uploaded", seconds: 1.0)
                            
                            break
                        }   }  } }
    }
}

