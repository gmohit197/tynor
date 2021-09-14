//
//  Attendancevc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 15/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import CoreLocation
import Alamofire
import SwiftEventBus

class Attendancevc: Executeapi, CLLocationManagerDelegate{
    var source = ""
    var attendancecode: [String]!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var status: DropDownUtil!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var detailstack: UIStackView!
    
    let date = Date()
    let formatter = DateFormatter()
    var attendancestatus: String?
    var attencode: String!
    var lat: String!
    var longi: String!
    var locationManager:CLLocationManager!
    let backgroundColor = UIColor(red: 154.0 / 255.0, green: 154.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
    var count: Int!
    var isCompleted = false
    var sheetcontroller: EndTrainingBottomSheet?
    var controller: UIViewController?
    var countIntent:Int! = 0
    
      var a = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        count = 0
        if source == "dash" {
            self.showtoast(controller: self, message: "Please Mark Attendance", seconds: 1.0)
        }
        self.setnav(controller: self, title: "Attendance")

        self.status.borderColor = UIColor.lightGray
        self.status.borderWidth = 1.0
//        detailstack.addHorizontalSeparators(color: backgroundColor)
        lat = "0"
        longi = "0"
        determineMyCurrentLocation()
        attendancecode = []
        attendancestatus = ""
        attencode = ""
        formatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        let result = formatter.string(from: date)
        self.datelbl.text = result
        self.user.text = UserDefaults.standard.string(forKey: "usercode")
        
        SwiftEventBus.onMainThread(self, name: "attndone") { (Result) in
            self.hideloader()
            if(self.isCompleted==false){
                self.AttendanceIntent()
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "attnnotdone") { (Result) in
            self.hideloader()
            self.showtoast(controller: self, message: "Something went wrong! Please try again...", seconds: 1.5)
        }
        
        getattendance()
      
        switch attendancestatus {
        case "Day Start":
            status.optionArray.removeAll()
            status.optionArray.append("Day End")
            attencode = "2"
            submit.isEnabled = true
            status.text = "Day End"
            status.isUserInteractionEnabled = false
            break
            
        case "Day End":
            status.optionArray.removeAll()
            status.optionArray.append("Day End")
            submit.isEnabled = false
            status.text = "Day End"
            status.isEnabled = false
            showtoast(controller: self, message: "Attendance is already submitted for today", seconds: 1.0)
            break
            
        case "Leave":
             status.optionArray.removeAll()
             status.optionArray.append("Leave")
             submit.isEnabled = false
             status.text = "Leave"
             status.isEnabled = false
             showtoast(controller: self, message: "Attendance is already submitted for today", seconds: 1.0)
             break
            
       case "Holiday":
            status.optionArray.removeAll()
            status.optionArray.append("Holiday")
            submit.isEnabled = false
            status.text = "Holiday"
            status.isEnabled = false
            showtoast(controller: self, message: "Attendance is already submitted for today", seconds: 1.0)
            break
            
      case "Sunday":
            status.optionArray.removeAll()
            status.optionArray.append("Sunday")
            submit.isEnabled = false
            status.text = "Sunday"
            status.isEnabled = false
            showtoast(controller: self, message: "Attendance is already submitted for today", seconds: 1.0)
            break
            
        case "":
            getspinnerdata()
            submit.isEnabled = true
            break
            
        default:
            status.optionArray.removeAll()
            status.optionArray.append(self.attendancestatus!)
            submit.isEnabled = false
            status.text = self.attendancestatus!
            status.isEnabled = false
            break
        }
        
        status.didSelect { (selected, index, id) in
            if selected == "Day End"{
                self.attencode = "2"
            }
            else {
                self.attencode = self.attendancecode[index]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        longi = nil
        lat = nil
    }
    
    func determineMyCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
    //    print("user latitude = \(userLocation.coordinate.latitude)")
    //    print("user longitude = \(userLocation.coordinate.longitude)")
        lat = String(userLocation.coordinate.latitude)
        longi = String(userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func getattendance(){
        var stmt: OpaquePointer? = nil
        self.formatter.dateFormat = "yyyy-MM-dd"
        let todaydate = formatter.string(from: date)
        let query = "SELECT  B.attndesc from Attendance A inner join AttendanceMaster B on A.status =B.attnid where attendancedate like '" + todaydate + "%'" + "and usercode='" + UserDefaults.standard.string(forKey: "usercode")! + "' and isblocked='false' order by A.status desc LIMIT 1"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let status = String(cString: sqlite3_column_text(stmt, 0))
            self.attendancestatus = status
        }
    }
    
    func getspinnerdata(){
        var stmt: OpaquePointer? = nil
        
        let query = "SELECT  '0' as attnid ,  '-Select-' as attndesc union SELECT attnid, attndesc from AttendanceMaster"
        attendancecode.removeAll()
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let attendes = String(cString: sqlite3_column_text(stmt, 1))
            let attencode = String(cString: sqlite3_column_text(stmt, 0))
            
            if attendes != "Day End"
            {
                self.status.optionArray.append(attendes)
                self.attendancecode.append(attencode)
            }
        }
        self.status.text = self.status.optionArray[0]
        self.attencode = self.attendancecode[0]
    }
    
    func showInternetSetting(){
        let alert = UIAlertController(title: "Please Enable Internet Connection in Settings", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            
            UIView.animate(withDuration: 0.3, animations: { ()->Void in
                self.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (finished) in
                self.view.removeFromSuperview()
            }
        }))
        present(alert, animated: true)
    }
    
    func showalertmsg(){
        let alert = UIAlertController(title: "Are you sure you want to '\(status.text!)'", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            self.insertattendance(usercode: UserDefaults.standard.string(forKey: "usercode")! as NSString, status: self.attencode as NSString, lat: self.lat as NSString, lon: self.longi as NSString, attendancedate: self.datelbl.text! as NSString, post: "0", usertype: UserDefaults.standard.string(forKey: "usertype")! as NSString, dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, isblocked: "false")
            
            let post = Postapi()
            self.showloader(title: "Uploading Attendence")
            post.postAttendence()
    
        }))
        present(alert, animated: true)
    }
    
    @IBAction func submitbtn(_ sender: UIButton){
        self.checknet()
        if AppDelegate.ntwrk > 0
        {
            if self.status.text == "-Select-"{
                self.showtoast(controller: self, message: "Select Attendance", seconds: 1.5)
            }
            else{
                if(self.status.text == "Leave")
                {
                    self.showBottomSheet()
                //    self.status.isUserInteractionEnabled = false

                }
                else{
                    self.showalertmsg()
                  //  self.status.isUserInteractionEnabled = false

                }
            }
        }
        else
        {
            self.showInternetSetting()
        }
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        
        self.navigationController?.pushViewController(home, animated: true)
    }
    
//    func productDayValidation() -> Bool
//    {
//        var stmt1: OpaquePointer?
//        let query = "select 1 _id,B.rowid,*,case when isapprove='0' then 'PENDING' else 'APPROVED' end as status from ProductDay B join ( select distinct itemname,itemgroup,itemgroupid from ItemMaster ) A on A.itemgroupid = B.itemgroupid where B.isdate like '\(self.getdate())%' and isapprove<>'0' "
//
//        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//            return false
//        }
//
//        var count:Int! = 0
//        while(sqlite3_step(stmt1) == SQLITE_ROW){
//            count = count + 1
//        }
//        if count < 5 {
//            if self.attencode == "1"{
//                return false
//            }  else  {
//                //dashboard
//                 return true
//            }
//        }
//        return false
//    }
    
    func productDayValidation() -> Bool
    {
        var stmt1: OpaquePointer?
        let query = "select 1 _id,B.rowid,*,case when isapprove='0' then 'PENDING' else 'APPROVED' end as status  from ProductDay B join (select distinct itemname,itemgroup , itemgroupid from ItemMaster ) A on A.itemgroupid = B.itemgroupid where B.isdate like '\(self.getdate())%' and isapprove<>'0' "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        
        var count:Int! = 0
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
        }
        
//        if count < 5  {
//            //            self.performSegue(withIdentifier: "product", sender: (Any).self)
//         //   self.pushnext(identifier: "productday", controller: self)
//            return false
//        }
        
         if count < 5  {
                  if self.attencode == "1"{
                   return false
            }
                    
          else {
                 return true
            }
        }
        return true
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    func AttendanceIntent(){
        countIntent = countIntent + 1
        print("AttendanceIntent===")
        print(countIntent)
        
        self.isCompleted=true
        
        if (self.productDayValidation() ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
         self.navigationController?.pushViewController(home, animated: true)
         }
        AppDelegate.menubool = true
         }
         else {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
         let peoductOfDay: ProductOfDay = self.storyboard?.instantiateViewController(withIdentifier: "productday") as! ProductOfDay
         self.navigationController?.pushViewController(peoductOfDay, animated: true)
           }
        }
    }
    
    private func makeSearchViewControllerIfNeeded() -> EndTrainingBottomSheet {
          let currentPullUpController = self.controller?.childViewControllers
              .filter({ $0 is EndTrainingBottomSheet })
              .first as? EndTrainingBottomSheet
          let pullUpController: EndTrainingBottomSheet = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "endbottomsheet") as! EndTrainingBottomSheet
          let base:Baseactivity = Baseactivity()
          
          pullUpController.usercode = "escalationclosing"
         // AppDelegate.customercode = self.customercode!
          pullUpController.trainingid = CustomerCard.orderid!
          pullUpController.trainingdate = base.getTodaydatetime()
          
          return pullUpController
      }
    @objc func hidesheet(sender: UITapGestureRecognizer){
        print("tappedd")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.sheetcontroller!.view.frame  = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
            
        })
        { (finished) in
            self.sheetcontroller!.willMove(toParentViewController: nil)
            self.sheetcontroller!.view.removeFromSuperview()
            self.sheetcontroller!.removeFromParentViewController()
        }
        AppDelegate.blureffectview.removeFromSuperview()
        
    }
    var blurEffect1 = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectView1 = UIVisualEffectView()
    func blurView1(view: UIView){
        
        blurEffect1 = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView1 = UIVisualEffectView(effect: blurEffect1)
        blurEffectView1.backgroundColor = UIColor.lightGray
        blurEffectView1.alpha = 0.2
        blurEffectView1.frame = view.bounds
        AppDelegate.blureffectview = blurEffectView1
        view.addSubview(AppDelegate.blureffectview)
    }
    func showBottomSheet(){
              a = self.view.subviews
               blurView1(view: self.view.subviews[a.count - 1])
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                 sheetcontroller = storyboard.instantiateViewController(withIdentifier: "endbottomsheet") as? EndTrainingBottomSheet
                                 let base:Baseactivity=Baseactivity()
                                 sheetcontroller?.usercode = "leaveAttendance"
                                 sheetcontroller?.trainingdate = base.getTodaydatetime()
                     //            sheetcontroller?.trainingid = self.trainingid                               
                                 sheetcontroller?.trainingdate = self.datelbl.text! as String
                                 
                                 let screenSize = UIScreen.main.bounds.size
                                 self.sheetcontroller!.view.frame  = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
                                 UIApplication.shared.keyWindow!.addSubview(self.sheetcontroller!.view)
                                 UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                                     let screenSize = UIScreen.main.bounds.size
                                     
                                     self.sheetcontroller!.view.frame  = CGRect(x: 0, y: screenSize.height - self.sheetcontroller!.view.frame.height-300 + 60, width: screenSize.width, height:  self.sheetcontroller!.view.frame.height+300)
                                 }, completion: nil)
                                 let tapblurview = UITapGestureRecognizer(target: self, action: #selector(hidesheet))
                                 tapblurview.numberOfTapsRequired = 1
                                 AppDelegate.blureffectview.addGestureRecognizer(tapblurview)
          }
    
}

//extension UIStackView {
//    func addHorizontalSeparators(color : UIColor) {
//        var i = self.arrangedSubviews.count - 1
//        while i > 0 {
//            let separator = createSeparator(color: color)
//            insertArrangedSubview(separator, at: i)
//            separator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
//            i -= 1
//        }
//    }
//
//    private func createSeparator(color : UIColor) -> UIView {
//        let separator = UIView()
//        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        separator.backgroundColor = color
//        return separator
//    }
//}
