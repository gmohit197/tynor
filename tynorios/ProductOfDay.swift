//
//  ProductOfDay.swift
//  tynorios
//
//  Created by Acxiom Consulting on 31/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import ImageTextField
import SwiftEventBus

class ProductOfDay: Executeapi, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productdayadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductDaycell
        
        let list: ProductDayadapter
        list = productdayadapter[indexPath.row]
        
       cell.category.text = list.category
       cell.product.text = list.product
       cell.status.text = list.status
        
        return cell
    }
    
    var orderid: [String]!
    var productdayadapter = [ProductDayadapter]()
    var isCitySelected: Bool = false
    @IBOutlet weak var workingareaspinr: DropDownUtil!
    @IBOutlet weak var productspinr: DropDownUtil!
    var cityarr:[String] = []
    var cityid:String = ""
    let post : Postapi = Postapi()
    var cityidOut : String = ""
    @IBOutlet weak var producttableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Product of the day")
        productspinr.optionIds = []
        orderid = []
//        let lineView = UIView(frame: CGRect(x: 5, y: 115, width: 365, height: 1.0))
//        lineView.layer.borderWidth = 0.8
//        lineView.layer.borderColor = UIColor.lightGray.cgColor
//        self.view.addSubview(lineView)
        
        productspinr.leftViewMode = UITextFieldViewMode.always
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 18))
        let image1 = UIImage(named: "search1.png")
        
        imageView1.image = image1
        productspinr.leftView = imageView1
        
        self.producttableview.tableFooterView = UIView()
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.4
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.producttableview.addGestureRecognizer(longPressGesture)
        
        productspinr.didSelect{(selected, index, id) in
            self.insertProductDay(dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, itemgroupid: String(id) as NSString, usercode: UserDefaults.standard.string(forKey: "usercode")! as NSString, pddate: self.getTodaydatetime() as NSString, post: "0", isapprove: "0")
            
            self.setlist()
            self.setproductspinnr()
            
        }
        productspinr.listDidDisappear {
            self.productspinr.text = ""
        }
        workingareaspinr.didSelect{(selected, index, id) in
            self.cityid = self.cityarr[index]
            self.cityidOut = self.cityarr[index]
            self.outStationfuncCheck(cityidStr: self.cityidOut)
        }
        
//        SwiftEventBus.onMainThread(self, name: "productdaySucess") { (Result) in
//                let post : Postapi = Postapi()
//                self.checknet()
//                if AppDelegate.ntwrk > 0 {
//                    post.postWorkingArea()
//                }
//                if let topController = UIApplication.getTopViewController() {
//                    let name = String(describing: type(of: topController))
//                if(name=="Dashboardvc"){
//                    return
//                }else{
//                     self.getToHome(controller: self)
//                     self.showtoast(controller: self, message: "Data Succesfully Sent", seconds: 1.5)
//
//                }
//              }
//        }
//
//        SwiftEventBus.onMainThread(self, name: "workingareaSucess") { (Result) in
//
//            if let topController = UIApplication.getTopViewController() {
//                let name = String(describing: type(of: topController))
//                if(name=="Dashboardvc"){
//                    return
//                }else{
//                     self.getToHome(controller: self)
//                     self.showtoast(controller: self, message: "Data successfully sent", seconds: 1.5)
//                }
//            }
//
//            UIView.animate(withDuration: 0.3, animations: { ()->Void in
//                self.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            }) { (finished) in
//                self.view.removeFromSuperview()
//                AppDelegate.menubool = true
//            }
//        }
//
//        SwiftEventBus.onMainThread(self, name: "workingareaFailure") { (Result) in
//            self.showtoast(controller: self, message: "Something Went Wrong", seconds: 1.0)
//        }
        
        producttableview.delegate = self
        producttableview.dataSource = self
      
        setcityspinnr()
        setproductspinnr()
        setlist()
    }
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "workingareaFailure") { (Result) in
            self.showProdalert(controller: self, msg: "Data Not Submitted !! Please try again Later!!")
        }
        SwiftEventBus.onMainThread(self, name: "workingareaSucess") { (Result) in
            self.post.postProductOfTheDay()
        }
        SwiftEventBus.onMainThread(self, name: "productdaySucess") { (Result) in
            if(AppDelegate.isProdIntentDone == 0){
                AppDelegate.isProdIntentDone = 1
                self.IntentMsgSuccess()
            }
        }
        SwiftEventBus.onMainThread(self, name: "productdayFailure") { (Result) in
            if( AppDelegate.isProdIntentDone == 0){
                AppDelegate.isProdIntentDone = 1
                self.IntentMsgFailure()
            }
        }
    }
    
    func showalertmsg(){
        let alert = UIAlertController(title: "Do you want to submit", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
           if  !self.isCitySelected {
            self.insertUserCurrentCity(date: self.getTodaydatetime() as NSString, city: self.cityid as NSString , isblocked: "false" as NSString , post: "0" as NSString)
            }
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                AppDelegate.isProdIntentDone = 0
                DispatchQueue.main.async {
                    if(self.checkWorkingPosted()){
                        self.post.postWorkingArea()
                    }
                    else if(self.checkProductPosted()){
                        self.post.postProductOfTheDay()
                    }
                }
            }
            else {
                self.showtoast(controller: self, message: "Please Check your Internet Connection", seconds: 1.5)
            }
            
//            UIView.animate(withDuration: 0.3, animations: { ()->Void in
//                self.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            }) { (finished) in
//                self.view.removeFromSuperview()
//                AppDelegate.menubool = true
//            }
            
        }
        
        ))
        present(alert, animated: true)
    }
    

    
    func IntentMsgSuccess(){
        self.getToHome(controller: self)
        self.showtoast(controller: self, message: "Data successfully sent", seconds: 1.5)
    }
    func IntentMsgFailure(){
        self.showProdalert(controller: self, msg: "Data Not Submitted !! Please try again Later!!")
    }
    func checkWorkingPosted() -> Bool
    {
        var check : Bool = false
        var stmt1: OpaquePointer?
        let query = "Select * from UserCurrentCity where post = '0' "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
          
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            check = true
        }
        return check
    }
    
    func checkProductPosted() -> Bool
    {
        var check : Bool = false
        var stmt1: OpaquePointer?
        let query = "Select * from ProductDay where post = '0' "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
          
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            check = true
        }
        return check
    }
    
    func checkrecord()
    {
        var stmt1: OpaquePointer?
        let query = "select * from ProductDay where isapprove = '0'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.showalertmsg()
        }
        else
        {
            self.showtoast(controller: self, message: "Select a product", seconds: 2.0)
        }
    }
    
    func checkWorkingArea(cityname: String?) -> Bool{
        var stmt2: OpaquePointer?
        let query = "select A.cityid,locationtype || ' - ' || b.cityname as CityName,locationtype || ' - ' || b.cityname as areacheck from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' and areacheck = '\(cityname!)' order by CityName"
        print("checkworkingarea==="+query)
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if (sqlite3_step(stmt2) == SQLITE_ROW){
            self.cityidOut = String(cString: sqlite3_column_text(stmt2, 0))
            return false
        }
        else{
            
            return true
        }
    }
    
    @IBAction func submitbtn(_ sender: Any) {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            if ((workingareaspinr.text == "-Select City-" || self.checkWorkingArea(cityname: workingareaspinr.text)))
            {
                self.showtoast(controller: self, message: "Select Linked City", seconds: 1.5)
            }
            else{
                if productdayadapter.count < 5 {
                    self.showtoast(controller: self, message: "Minimum 5 Products Required", seconds: 1.5)
                }
                else
                {
                if(outStationfuncCheck(cityidStr: self.cityidOut)){
                    self.checkrecord()
                }
                }
            }
        }
        
        else{
            self.showsettingsalert(controller: self, msg: "Please Enable Internet connection in Settings")
           
        }
        
    }
    
    func setcityspinnr()
    {
        var currentcity: String?
        var currentcityid: String?
        cityarr.removeAll()
        var stmt2: OpaquePointer?
        
        let query1 =  "select * from UserCurrentCity A inner join CityMaster B on A.city = B.CityID where substr(A.date,1,10) = '\(self.getdate())' and isBlocked= 'false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query1 , -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt2) == SQLITE_ROW){
            currentcity = String(cString: sqlite3_column_text(stmt2, 5))
            currentcityid = String(cString: sqlite3_column_text(stmt2, 4))
        }
        
        var stmt1: OpaquePointer?
        let query = "select ''as cityid,'-Select City-' as CityName union select A.cityid,locationtype || ' - ' || b.cityname as CityName from UserLinkCity A inner join CityMaster B on A.cityid = B.CityID where A.isblocked='false' order by CityName"

        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var temp: Bool! = true
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let cityname = String(cString: sqlite3_column_text(stmt1, 1))
            let cityid = String(cString: sqlite3_column_text(stmt1, 0))
            cityarr.append(cityid)
            workingareaspinr.optionArray.append(cityname)

            if(currentcityid == cityid){
                temp = false
                workingareaspinr.text = cityname
                workingareaspinr.isUserInteractionEnabled = false
                isCitySelected = true
            }
        }
        if temp{
               self.workingareaspinr.text = workingareaspinr.optionArray[0]
        }
    }
        
        func setproductspinnr()
        {
            productspinr.optionArray.removeAll()
            productspinr.optionIds?.removeAll()
            var stmt1: OpaquePointer?
            
            let query = "select distinct itemgroupid,itemname from ItemMaster where isblocked='false' and itemsubgroup not in ('PRINTING & STATIONERY','BUSINESS PROMOTION') and itemgroupid not in (select itemgroupid from ProductDay where isdate like '\(self.getdate())%')"
            
            print("setproductSpinnerProductofDay==>" + query)
            
            if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            
            while(sqlite3_step(stmt1) == SQLITE_ROW){
                let itemname = String(cString: sqlite3_column_text(stmt1, 1))
                let itemid = String(cString: sqlite3_column_text(stmt1, 0))
                productspinr.optionArray.append(itemname)
                productspinr.optionIds?.append(Int(itemid) ?? 0)
               // productspinr.optionIds?.append(itemid)
            }
    }
    
    func setlist()
    {
        self.productdayadapter.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "select 1 _id,B.rowid,*,case when isapprove='0' then 'PENDING' else 'APPROVED' end as status,B.itemgroupid   from ProductDay B join ( select distinct itemname,itemgroup , itemgroupid from ItemMaster ) A on A.itemgroupid = B.itemgroupid where B.isdate like '\(self.getdate())%'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.orderid.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let category = String(cString: sqlite3_column_text(stmt1, 10))
            let product = String(cString: sqlite3_column_text(stmt1, 9))
            let status = String(cString: sqlite3_column_text(stmt1, 12))
            let orderid = String(cString: sqlite3_column_text(stmt1, 13))
            
            self.orderid.append(orderid)
            self.productdayadapter.append(ProductDayadapter(category: category, product: product, status: status)) 
        }
         self.producttableview.reloadData()
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.producttableview)
            if let indexPath = producttableview.indexPathForRow(at: touchPoint) {

                let index = indexPath.row
                let productitem: ProductDayadapter
                productitem = productdayadapter[index]

                if productitem.status == "PENDING"
                {
                    self.showalert(index: index,itemgroupid: self.orderid[index])
                }
            }
        }
    }
    
    func showalert(index: Int, itemgroupid: String?){
        let alert = UIAlertController(title: "Delete Line!!!", message: "Do you want to Delete?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
           self.deleteproductofday(itemgroupid: itemgroupid)
           self.setlist()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func backbtn(_ sender: Any) {
        let dash: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        self.navigationController?.pushViewController(dash, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    func outstationProfileDetailcheck() -> Bool{
        var stmt1: OpaquePointer?
        let query = "select oscount from profileDetail where oscount <= 0"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        print("outstationProfileDetailcheck=="+query)
        if (sqlite3_step(stmt1) == SQLITE_ROW){
            return true
        }
        else{
            return false
        }

    }
    
    func checkIsOustation(cityid: String?) -> Bool{
           var stmt1: OpaquePointer?

          let query = "select * from UserLinKCity where cityid = '\(cityid!)' and locationtype = 'OUTSTATION' and isblocked = 'false'"
        
           if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
               print("error preparing get: \(errmsg)")
           }
           if (sqlite3_step(stmt1) == SQLITE_ROW){
            
               return true
           }
           else{
               return false
           }
       }
    
    func outStationfuncCheck(cityidStr: String?) -> Bool{
        if checkIsOustation(cityid: cityidStr!){
            if outstationProfileDetailcheck(){
                self.showtoast(controller: self, message: "Maximum Outstation Limit Reached", seconds: 1.0)
                return false
            }
            else {
                
                return true
            }
        }
        else {
             return true
        }
    }
}

