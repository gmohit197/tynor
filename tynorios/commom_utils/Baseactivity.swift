//
//  Baseactivity.swift
//  tynorios
//
//  Created by Acxiom Consulting on 21/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import SystemConfiguration
import UIKit
import SQLite3
import SwiftEventBus
import Alamofire

public class Baseactivity: Databaseconnection
{
    var timer: Timer?
    
    var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectView = UIVisualEffectView()
    //for bottomsheets
    static var bottomsheetblurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    static var bottomsheetEffectView = UIVisualEffectView()
    let subtitleLabel: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 40.0, height: 12.0))
    //    let subtitleLabel = UITextField()
    public func showtoast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message,  preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated : false)
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func checkRetailersign(customercode: String?){
        
        var stmt1: OpaquePointer?
        let query = "select customercode, substr(lastvisit,1,10) as lastvisited, lastactivityid from USERCUSTOMEROTHINFO  where customercode = '\(customercode!)' and lastvisited <> '\(getdate())' and (lastactivityid <> '3' and isescalated <> '1')"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.updateRetailersign(customercode: customercode)
        }
    }
    
    func updateRetailersign(customercode: String?){
        // var stmt1: OpaquePointer?
        let query = "update USERCUSTOMEROTHINFO set lastactivityid = '0' where customercode = '\(customercode!)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating Table USERCUSTOMEROTHINFO")
            return
        }
    }
    func showalert(controller: UIViewController, msg: String){
        let alert = UIAlertController(title: "Data Sync...", message: "Data \(msg) Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            UserDefaults.standard.set(true, forKey: "synced")
            alert.dismiss(animated: true, completion: nil)
            AppDelegate.menubool = true
            self.gotohome()
            //            UIView.animate(withDuration: 0.3, animations: { ()->Void in
            //                controller.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            //            }) { (finished) in
            //                controller.view.removeFromSuperview()
            //
            //            }
        }))
        present(alert, animated: true)
    }
    
    
    func showProdalert(controller: UIViewController, msg: String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            AppDelegate.menubool = true
            self.gotohome()
        }))
        present(alert, animated: true)
    }
    
    
    func pushnext(identifier: String,controller: UIViewController){
        let forgot = (controller.storyboard?.instantiateViewController(withIdentifier: identifier))!
        print(" \(identifier) - \(controller.navigationController)")
        controller.navigationController?.pushViewController(forgot, animated: true)
    }
    
    func popback(controller: UIViewController){
        controller.navigationController?.popViewController(animated: true)
    }
    
    
    func showalertdash(controller: UIViewController,msg: String){
        let alert = UIAlertController(title: "Data Sync...", message: "Data \(msg) Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            UserDefaults.standard.set(true, forKey: "synced")
            SwiftEventBus.post("startrefesh")
            
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
    
    
    
    
    
    func showsettingsalert(controller: UIViewController,msg: String){
        let alert = UIAlertController(title:"",message: "\(msg)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
    func getdate(days:Int)-> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: Calendar.current.date(byAdding: .day, value: days, to: Date())!)
        
    }
    var loader = UIAlertController()
    func showloader(title: String){
        loader = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        loader.view.addSubview(loadingIndicator)
        present(loader, animated: false, completion: nil)
    }
    func hideloader(){
        loader.dismiss(animated: false, completion: nil)
    }
    
    
    func showSyncloader(title: String){
        loader = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        loader.view.addSubview(loadingIndicator)
        present(loader, animated: true, completion: nil)
    }
    
    func hideSyncloader(){
        DispatchQueue.main.async {
            self.loader.dismiss(animated: true, completion: nil)
        }
    }
    
    public func hideview(view: UIView){
        view.isHidden = true
        view.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    public func showview(view: UIView, height: CGFloat){
        // self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 20.0)
        view.isHidden = false
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: height)
        
        //        view.layoutIfNeeded()
        //        CGRect frameRect
        //        frameRect = view.frame
        //        frameRect.size.height = height // <-- Specify the height you want here.
        
        
    }
    
    public func showview1(view: UIView){
        view.isHidden = false
        view.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
    }
    public func hidecardview(view: UIView){
        view.isHidden = true
        view.heightAnchor.constraint(equalToConstant: 0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    
    public func hidetextview(view: UITextField){
        view.isHidden = true
        view.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    
    
    
    public func getPendingSubDealer(){
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
                    SwiftEventBus.post("pending")
                    self.updatelog(tablename: "Pendingsubdealer", status: "success", datetime: self.getTodaydatetime())
                }
            }
            
                break
                
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "Pendingsubdealer",status: error.localizedDescription, datetime: self.getTodaydatetime())
            SwiftEventBus.post("pendingnot")
                break
            }}
    }
    public func getPendingEscalation(){
        DispatchQueue.main.async {
            Alamofire.request(constant.Base_url + constant.URL_getpendingescalationConst()).validate().responseJSON {
                response in
                print("getPendingEscalation==" + constant.Base_url + constant.URL_getpendingescalationConst())
                switch response.result {
                case .success(let value): print("success==========> \(value)")
                self.deleteescalationreport()
                if  let json = response.result.value{
                    let listarray : NSArray = json as! NSArray
                    if listarray.count > 0 {
                        for i in 0..<listarray.count{
                            let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                            let escalationid = String (((listarray[i] as AnyObject).value(forKey:"escalationid") as? String)!)
                            let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as? String)!)
                            let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                            let siteid = String(((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                            let submittime = String (((listarray[i] as AnyObject).value(forKey:"submittime") as? String)!)
                            let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Int)!)
                            let createdby = String (((listarray[i] as AnyObject).value(forKey:"createdby") as? String)!)
                            
                            
                            self.insertescalationreport(dataareaid: dataareaid as NSString, escalationid: escalationid as NSString, customercode: customercode as NSString, siteid: siteid as NSString, submittime: submittime as NSString, createdby: createdby as NSString, status: status as NSString, remark: "", reasoncode: reasoncode as NSString, username: "", closeremarks: "", post: "2", latitude: "", longitude: "")
                        }
                        SwiftEventBus.post("gotescalaltion")
                    }
                }
                    break
                case .failure(let error): print("error============> \(error)")
                    break
                }
                print("loader deactivated")
            }
        }
    }
    
    
    
    
    public func checknet() {
//        guard let status = Network.reachability?.status else { return }
//        switch status {
//        case .unreachable:
//            let modelName = UIDevice.modelName
//            print("Device=========>\(modelName)")
//            if modelName.contains("Simulator") {
//                AppDelegate.ntwrk = 1;
//            }
//            else {
//                AppDelegate.ntwrk = 0;
//            }
//
//            break
//        case .wifi:
//            AppDelegate.ntwrk = 1;
//            break
//        case .wwan:
//            AppDelegate.ntwrk = 1;
//            break
//        }
  //      print("Reachability Summary")
  //      print("Status:", status)
//        print("HostName:", Network.reachability?.hostname ?? "nil")
 //       print("Reachable:", Network.reachability?.isReachable ?? "nil")
 //       print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
        
    }
    public func cardview (myview: UIView)
    {
        myview.layer.shadowColor = UIColor.black.cgColor
        myview.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        myview.layer.shadowOpacity = 0.3
        myview.layer.cornerRadius = 4 as CGFloat
    }
    
    func getTodaydatetime() -> String{
        
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.hour,.minute,.second], from: date)
        
        //        let year = components.year
        //        let month = components.month
        //        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = "\(self.getdate()) \(String(hour!)):\(String(minute!)):\(String(second!))"
        
        return today_string
        
    }
    
    func getToHome(controller: UIViewController)
    {
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        controller.navigationController?.pushViewController(home, animated: true)
    }
    
    public func getIDItemId () -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "kkmmss"
        let currdate = formatter.string(from: date)
        return currdate
    }
    
    public func getID () -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyHHmmss"
        let currdate = formatter.string(from: date)
        let id = UserDefaults.standard.string(forKey: "usercode")! + currdate
        
        return id
    }
    
    public func getIDNew () -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddkkmmss"
        let currdate = formatter.string(from: date)
        let id = UserDefaults.standard.string(forKey: "usercode")! + currdate
        
        return id
    }
    
    public func getdate () -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currdate = formatter.string(from: date)
        
        return currdate
    }
    
    public func isescalated(customercode: String?) -> Bool
    {
        
        var stmt: OpaquePointer?
        let query = "select ifnull(lastactivityid,'0') as lastactivityid,isescalated from  USERCUSTOMEROTHINFO where CUSTOMERCODE='\(customercode!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        
        if(sqlite3_step(stmt) == SQLITE_ROW){
            let lastactivity = String(cString: sqlite3_column_text(stmt, 0))   //  ==3  -> escalate &&
            let escalated  = String(cString: sqlite3_column_text(stmt, 1))   // ==true  -> escalate
            
            if ((lastactivity != "3" || PendingEscalation.ispendingescalated) && !(escalated == "true"))
            {
                return true
            }else{
                self.showtoast(controller: self, message: "Customer is escalated", seconds: 1.5)
                return false
            }
        }else{
            return false
        }
    }
    
    func checkattendance() -> String {
        var stmt:OpaquePointer?
        var attendance: String = "";
        // let query = "select attndesc from AttendanceMaster where attnid = (select status from Attendance)"
        let query = "SELECT  B.attndesc from Attendance A inner join AttendanceMaster B on A.status = B.attnid where attendancedate like '\(self.getdate())%' and isblock='0'  order by A.status desc "
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return attendance
        }
        if(sqlite3_step(stmt) == SQLITE_ROW){
            attendance = String(cString: sqlite3_column_text(stmt, 0))
        }
        return attendance
    }
    
    func checkvalidation(customercode: String?) -> String {
        var stmt: OpaquePointer?
        var lastactivityid: String = "-1";
        let query = "select lastactivity, ifnull(lastactivityid,'0') from USERCUSTOMEROTHINFO where customercode = '\(customercode!)' and lastvisit like '\(self.getdate())%'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return lastactivityid
        }
        
        if(sqlite3_step(stmt) == SQLITE_ROW){
            lastactivityid = String(cString: sqlite3_column_text(stmt, 1))
        }
        return lastactivityid
    }
    
    func getTodaysOrder(customercode: String?) -> String
    {
        var stmt: OpaquePointer?
        var lastactivityid: String = "-1"
        
        let query = "select * from USERCUSTOMEROTHINFO  where CUSTOMERCODE = '\(customercode!)' and lastactivityid = '1'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return lastactivityid
        }
        
        if(sqlite3_step(stmt) == SQLITE_ROW){
            lastactivityid = String(cString: sqlite3_column_text(stmt, 1))
        }
        return lastactivityid
    }
    
    func attendanceValidation() -> Bool {
        
        if(AppDelegate.isDash){
            self.autoLogout()
        }
        
        var stmt: OpaquePointer? = nil
        
        let query = "SELECT B.attndesc from Attendance A inner join AttendanceMaster B on A.status =B.attnid where attendancedate like '\(self.getdate())%'" + "and usercode='" + UserDefaults.standard.string(forKey: "usercode")! + "' and isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        var status:String! = ""
        while(sqlite3_step(stmt) == SQLITE_ROW){
            status = String(cString: sqlite3_column_text(stmt, 0))
        }
        if status == ""
        {
            let attn: Attendancevc = self.storyboard?.instantiateViewController(withIdentifier: "avc") as! Attendancevc
            attn.source = "dash"
            self.navigationController?.pushViewController(attn, animated: true)
            return false
        }
        return true
    }
//    func attendanceValidationBurgerMenu() -> Bool {
//        var stmt: OpaquePointer? = nil
//        
//        let query = "SELECT B.attndesc from Attendance A inner join AttendanceMaster B on A.status =B.attnid where attendancedate like '\(self.getdate())%'" + "and usercode='" + UserDefaults.standard.string(forKey: "usercode")! + "' and isblocked='false'"
//        
//        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//            return false
//        }
//        var status:String! = ""
//        while(sqlite3_step(stmt) == SQLITE_ROW){
//            status = String(cString: sqlite3_column_text(stmt, 0))
//        }
//        if status == ""
//        {
//            let attn: Attendancevc = self.storyboard?.instantiateViewController(withIdentifier: "avc") as! Attendancevc
//            attn.source = "dash"
//            self.navigationController?.pushViewController(attn, animated: true)
//            return false
//        }
//        return true
//    }
    
    func teamtrainingcheck() -> Bool
    {
        var stmt: OpaquePointer? = nil
        let query = "select distinct 1 as _id,A.rowid,A.empname,A.usercode,b.status,b.trainingid as TRAININGID from USERHIERARCHY A left join TrainingDetail B on B.TRAINEDTO =A.usercode where A.usertype <> '\(AppDelegate.usertype)'and b.status = '0' and substr(b.trainingstarttime,1,10)<>'\(self.getdate())' ORDER BY A.usertype"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        if(sqlite3_step(stmt) == SQLITE_ROW){
            let teamtraining: TeamTrainingvc = self.storyboard?.instantiateViewController(withIdentifier: "teamtraining") as! TeamTrainingvc
            self.navigationController?.pushViewController(teamtraining, animated: true)
            self.showtoast(controller: self, message: "Please End Training First", seconds: 1.5)
            return false
        }
        else
        {
            return true
        }
    }
    
    func setnav(controller: UIViewController, title: String) {
        
        let titleStackView: UIStackView = {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.boldSystemFont(ofSize: (titleLabel.font.pointSize))
            // titleLabel.font = .boldSystemFont(ofSize: 14)
            titleLabel.text = title
            titleLabel.textColor = UIColor.white
            titleLabel.numberOfLines = 2
            
            
            subtitleLabel.text = "ONLINE"
            subtitleLabel.backgroundColor = UIColor.green.withAlphaComponent(0.6)
            subtitleLabel.textAlignment = .center
            
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                subtitleLabel.text = "ONLINE"
                subtitleLabel.backgroundColor = UIColor.green.withAlphaComponent(0.6)
            }
            else {
                subtitleLabel.text = "OFFLINE"
                subtitleLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
            }
            subtitleLabel.font = .boldSystemFont(ofSize: 11)
            subtitleLabel.textColor = UIColor.white
            subtitleLabel.borderStyle = UITextBorderStyle.roundedRect
            subtitleLabel.isUserInteractionEnabled = false
            
            let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            stackView.spacing = 3
            NSLayoutConstraint.activate([
                stackView.heightAnchor.constraint(equalToConstant: 35),
            ])
            stackView.axis = .vertical
            stackView.sizeToFit()
            
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            
            return stackView
        }()
        
        controller.navigationItem.titleView = titleStackView
        controller.navigationController?.navigationBar.frame.maxY
        if(AppDelegate.isDash){
          self.autoLogout()
        }
        self.BlockCheck()
    }
    
    func BlockCheck(){
            self.checknet()
            if (AppDelegate.ntwrk > 0 && (constant.Base_url == "http://103.25.172.118:8089/api/" || constant.Base_url == "http://tynor.co:82/api/") && !((UserDefaults.standard.string(forKey: "usercode") == nil || UserDefaults.standard.string(forKey: "usercode") == ""))) {
                self.URL_PROFILEDETAIL_BLOCKCHECK()
            }

    }
    
      func setnavAppDelegate(title: String) {
            
            let titleStackView: UIStackView = {
                let titleLabel = UILabel()
                titleLabel.textAlignment = .center
                titleLabel.font = UIFont.boldSystemFont(ofSize: (titleLabel.font.pointSize))
                // titleLabel.font = .boldSystemFont(ofSize: 14)
                titleLabel.text = title
                titleLabel.textColor = UIColor.white
                subtitleLabel.text = "ONLINE"
                subtitleLabel.backgroundColor = UIColor.green.withAlphaComponent(0.6)
                subtitleLabel.textAlignment = .center
                
                self.checknet()
                if AppDelegate.ntwrk > 0 {
                    subtitleLabel.text = "ONLINE"
                    subtitleLabel.backgroundColor = UIColor.green.withAlphaComponent(0.6)
                }
                else {
                    subtitleLabel.text = "OFFLINE"
                    subtitleLabel.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
                }
                subtitleLabel.font = .boldSystemFont(ofSize: 11)
                subtitleLabel.textColor = UIColor.white
                subtitleLabel.borderStyle = UITextBorderStyle.roundedRect
                subtitleLabel.isUserInteractionEnabled = false
                
                let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
                stackView.spacing = 3
                NSLayoutConstraint.activate([
                    stackView.heightAnchor.constraint(equalToConstant: 35),
                ])
                stackView.axis = .vertical
                stackView.sizeToFit()
                stackView.alignment = .center
                stackView.distribution = .fillEqually
                return stackView
            }()
//            controller.navigationItem.titleView = titleStackView
            
            if(AppDelegate.isDash){
              self.autoLogout()
            }

            self.BlockCheck()
        }
    
    func gotohome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "DNC") as! UINavigationController
        UIApplication.shared.delegate?.window?!.rootViewController = registrationVC
    }
    
    func gotoSplash(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registrationVC = storyboard.instantiateViewController(withIdentifier: "splash") as! UINavigationController
        UIApplication.shared.delegate?.window?!.rootViewController = registrationVC
    }
    
    func todatecheck(todate: Date, fromdate: Date){
        if fromdate.compare((todate)) == .orderedDescending  {
            self.showtoast(controller: self, message: "From Date should be before To date", seconds: 1.5)
        }
    }
    
    func todatecheckString(todate: String, fromdate: String)-> Bool{
        if todate < fromdate  {
            self.showtoast(controller: self, message: "From Date should be before To date", seconds: 1.5)
            return false
        }
        return true
    }
    func validateReportCheck(todate: String, fromdate: String)-> Bool{
        if fromdate == "" {
            self.showtoast(controller: self, message: "Please enter From date", seconds: 1.5)
            return false
        }
        if todate == "" {
            self.showtoast(controller: self, message: "Please enter To date", seconds: 1.5)
            return false
        }
        if todate < fromdate  {
            self.showtoast(controller: self, message: "From Date should be before To date", seconds: 1.5)
            return false
        }
        self.checknet()
        if !(AppDelegate.ntwrk > 0 ){
            self.showtoast(controller: self, message: "You are Offline", seconds: 1.5)
            return false
        }
        return true
    }
    
    func blurView(view: UIView){
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = UIColor.lightGray
        blurEffectView.alpha = 0.2
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }
    
    func autoLogout(){
        if UserDefaults.standard.string(forKey: "executeapi") != self.getdate(){
            self.gotoSplash()
            if(AppDelegate.isDebug){
            print("logout is clicked");
            }
        }
    }
    
    func removeBlurView()
    {
        blurEffectView.removeFromSuperview()
    }
    static func bottomSheetBlurView(view: UIView){
        bottomsheetblurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        bottomsheetEffectView = UIVisualEffectView(effect: bottomsheetblurEffect)
        bottomsheetEffectView.backgroundColor = UIColor.lightGray
        bottomsheetEffectView.alpha = 0.2
        bottomsheetEffectView.frame = view.bounds
        view.addSubview(bottomsheetEffectView)
    }
    
    static func bottomSheetRemoveBlurView()
    {
        bottomsheetEffectView.removeFromSuperview()
    }
    
   public  func URL_PROFILEDETAIL_BLOCKCHECK(){
    Alamofire.request(constant.Base_url + constant.URL_PROFILEDETAILConst()).validate().responseJSON {
            response in
        if(AppDelegate.isDebug){
        print("ProfileDetailBlock=="+constant.Base_url + constant.URL_PROFILEDETAILConst())
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
                        let ismobileblock = Int (((listarray[i] as AnyObject).value(forKey:"ismobileblock") as? Int)!)
                 if(AppDelegate.isDebug){
                        print("IsMobileBlockValue")
                        print(ismobileblock)
                        }
                        if(ismobileblock  == 1 ){
                            AppDelegate.isMobileBlock = true
                            AppDelegate.isDash = false
                            self.gotoSplash()
                            DispatchQueue.main.asyncAfter(deadline: .now()+5.00) {
                                 self.clearData ()
                                 self.deleteDatabase()
                                 self.clearSharedPref()
                                 self.showtoast(controller: self, message: "User Blocked", seconds: 2.0)
                            }
                        }
                        else{
                           AppDelegate.isMobileBlock = false
                        }
                    }
                }
            }
                break
            case .failure(let error):
                if(AppDelegate.isDebug){
                print("error===========\(error)")
                }
                break
            }}}

    func clearSharedPref(){
        UserDefaults.standard.removeObject(forKey: "usercode")
        UserDefaults.standard.removeObject(forKey: "islogged")
        UserDefaults.standard.removeObject(forKey: "isblocked")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "stateid")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "usertype")
        UserDefaults.standard.removeObject(forKey: "userid")
        UserDefaults.standard.removeObject(forKey: "dataareaid")
        UserDefaults.standard.removeObject(forKey: "ismobilelogin")
        UserDefaults.standard.set(false, forKey: "islogged")
        UserDefaults.standard.set("", forKey: "usercode")
        UserDefaults.standard.set("1", forKey: "isblocked")
        UserDefaults.standard.set(0, forKey: "ismobileblock")
        UserDefaults.standard.set(self.getdate(days: -2), forKey: "executeapi")
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
    }
    
     public func getExpense(){
               
    //           self.showloader(title: "Syncing")
               print("sending request")
               let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
               activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
               activityIndicator.color = UIColor.black
               view.addSubview(activityIndicator)
               activityIndicator.startAnimating()
               print("loader activated")
               
               let URL_expensereport = "GETEXPENSEENTRY?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&ISMOBILE=1" + "&FROMDATE=" + self.getdate() + "&TODATE=" + self.getdate()
               print(URL_expensereport)
               DispatchQueue.main.async {
                   Alamofire.request(constant.Base_url + URL_expensereport).validate().responseJSON {
                       response in
                       switch response.result {
                       case .success(let value): print("success==========> \(value)")
                       
                       if  let json = response.result.value{
                           let listarray : NSArray = json as! NSArray
                           if listarray.count > 0 {
                               
                               SwiftEventBus.post("gotexpensetoday")
                             //  self.hideloader()
                           }
                       }
                       break
                       case .failure(let error):
                           SwiftEventBus.post("notexpensetoday")
                          // self.hideloader()
                           print("error============> \(error)")

                           break
                       }
                       DispatchQueue.main.async {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                         
                                         // stop animating now that background task is finished
                                         activityIndicator.stopAnimating()
                                      //   self.view.isUserInteractionEnabled = true
                                         print("loader deactivated")
                                         
                       
                                     }}
                       
                   }
               }
           }
        
    }

extension UIDatePicker {
    func fromdatecheck(){
        self.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        //        self.datePicker!.date = Calendar.current.date(byAdding: .year, value: 0, to: Date())!
        self.setDate(Calendar.current.date(byAdding: .year, value: 0, to: Date())!, animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

extension UILabel {
    
    func addImageWith(name: String, behindText: Bool) {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        let attachmentString = NSAttributedString(attachment: attachment)
        
        guard let txt = self.text else {
            return
        }
        
        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    func checkflag() -> Bool {
        if AppDelegate.totalapi == Loginvc.flagcount {
            return true
        }
        else {
            return false
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
extension UIDatePicker {
    func todatecheck(){
        self.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
    }
    
}


extension UIColor{
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
