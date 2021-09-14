//
//  OrderListViewController.swift
//  tynorios
//
//  Created by Acxiom Consulting on 05/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Foundation
import SQLite3
import SwiftEventBus

class OrderListViewController: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderlistadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! takeordercell
        
        let list: Takeorderadapter
        list = orderlistadapter[indexPath.row]
        cell.amount.text = list.payableamt
        cell.sono.text = list.orderno
        cell.status.text = list.status
        cell.date.text = list.date
        cell.qty.text = list.qty
        cell.payamt.text = list.amount
        
        return cell
    }
    
    var customercode: String?
    var customername: String?
    var pricegroup: String?
    var siteid: String?
    var stateid: String?
    var orderid: String?
    var titletext: String?
    
    var orderlistadapter = [Takeorderadapter]()
    var siteidarr: [String]!
    var taxdb : Int64 = 0
    var pricedb : Int64 = 0
    
    
    @IBOutlet weak var orderListTable: UITableView!
    
    @IBOutlet var addorderbtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {

        print("ViewWillAppearCalled")
        
        SwiftEventBus.onMainThread(self, name: "sorderlist")
       {_ in
            self.setList()
        }
 //       setList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewWillDisAppearCalled")
    }
    override func viewDidDisappear(_ animated: Bool) {
         print("viewDidDisappearCalled")
    }
    override func viewDidAppear(_ animated: Bool) {
        self.ApiCall()
        self.setList()
    }
    
    var loadingalert:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        siteid="0"
//        checknet()
//        if AppDelegate.ntwrk==1
//        {
//         //   if(AppDelegate.isorderList){
//                 self.ApiCalling()
//        //    }
//        //    else{
//        //        setList()
//        //    }
//        }
//        else{
//            if(!(self.validate()))
//            {
//                addorderbtn.isEnabled=false
//                self.showtoast(controller: self, message: "No internet available to download the data", seconds: 1.5)
//            }
//
//
////            if UserDefaults.standard.string(forKey: "executeapi") != self.getdate(){
////                if !( UserDefaults.standard.bool(forKey:"usertaxsetuploaded" )){
////                    addorderbtn.isEnabled=false
////                    self.showtoast(controller: self, message: "No internet available to download the data", seconds: 1.5)
////                }
////            }
//        }
        print("CloseTileOrderListcustomername==="+customername!)
        self.setnav(controller: self, title: "\(customername!)")
        //  navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(clickorder))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.orderListTable.addGestureRecognizer(tapeno)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.4
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.orderListTable.addGestureRecognizer(longPressGesture)
        
        siteidarr = []
        setList()
        orderListTable.delegate = self
        orderListTable.dataSource = self
    }
    func ApiCall(){
        // checknet()
         self.setnav(controller: self, title: "\(customername!)")
       //  self.viewDidAppear(true)
        if AppDelegate.ntwrk==1
        {
            self.ApiCalling()
        }
        else{
        if(!(self.validate()))
          {
            addorderbtn.isEnabled=false
            self.showtoast(controller: self, message: "No internet available to download the data", seconds: 1.5)
            }
        }
    }
    
    @objc func clickorder(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.orderListTable)
        if let indexPath = orderListTable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            let orderItem: Takeorderadapter
            orderItem = orderlistadapter[index]
            CustomerCard.orderid = orderItem.orderno
            
            if orderItem.status == "Pending" {
                let secondaryorderitem: Takeorder = self.storyboard?.instantiateViewController(withIdentifier: "orderitem") as! Takeorder
                secondaryorderitem.customercode = self.customercode
                secondaryorderitem.customername  = self.customername
                secondaryorderitem.pricegroup  = self.pricegroup
                secondaryorderitem.siteid = siteidarr[index]
                secondaryorderitem.stateid = self.stateid
                secondaryorderitem.titletext = self.titletext
                self.navigationController?.pushViewController(secondaryorderitem, animated: true)
            }
            else{
                let item: MyCart = self.storyboard?.instantiateViewController(withIdentifier: "mycart") as! MyCart
                item.siteid = self.siteid!
                item.isApproved = true
                item.isPrimary = false
                item.titletext = self.titletext
                self.navigationController?.pushViewController(item, animated: true)
            }
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.orderListTable)
            if let indexPath = orderListTable.indexPathForRow(at: touchPoint) {
                let index = indexPath.row
                let orderItem: Takeorderadapter
                orderItem = orderlistadapter[index]
                if orderItem.status == "Pending"
                {
                    self.showalert(index: orderItem.orderno)
                }
            }
        }
    }
    
    func showalert(index: String?){
        let alert = UIAlertController(title: "Delete Line!!!", message: "Do you want to Delete Order?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            self.deleteOrder(sono: index)
            self.setList()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func addOrderBtn(_ sender: Any) {
        
//        var usertax:Bool = false;
//        var itemprice:Bool = false;
//        CustomerCard.orderid = self.getID()
//        var stmt1:OpaquePointer?
//        var stmt2:OpaquePointer?
//        let query = "select * from usertaxsetup"
//        let query1 = "select * from UserPriceList"
//        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//            return
//        }
//
//        if(sqlite3_step(stmt1) == SQLITE_ROW){
//            usertax = true;
//        }
//        if sqlite3_prepare_v2(Databaseconnection.dbs, query1, -1, &stmt2, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
//            print("error preparing get: \(errmsg)")
//            return
//        }
//
//        if(sqlite3_step(stmt2) == SQLITE_ROW){
//            itemprice = true;
//        }
//        if usertax && itemprice
//
        if(self.validate())
        {
            
            self.createSoOrder(userid: UserDefaults.standard.string(forKey: "usercode"), todaydate: self.getTodaydatetime(), siteid: self.siteid, customercode: self.customercode, latitude: "0", longitude: "0", percent: "0",sono:CustomerCard.orderid)
            
            let orderitem: Takeorder = self.storyboard?.instantiateViewController(withIdentifier: "orderitem") as! Takeorder
            
            orderitem.customercode = self.customercode
            orderitem.customername  = self.customername
            orderitem.pricegroup  = self.pricegroup
            orderitem.siteid = self.siteid
            orderitem.stateid = self.stateid
            orderitem.titletext = self.titletext
            
            self.navigationController?.pushViewController(orderitem, animated: true)
        }
    }
    
    func setList() {
        
        var stmt1:OpaquePointer?
        siteidarr.removeAll()
        
        let fromdate = self.getdate(days: -2)
        let todate = self.getdate()
        orderlistadapter.removeAll()
        
        let query = "select 1 as _id,SOH.SONO,substr(SOH.SODate,1,10) as dated,case when sum(SOL.QTY)>0 then cast(ROUND(sum(SOL.QTY),2) AS nvarchar(12)) else 0 end as QTY,case when sum(SOL.LineAmount)>0 then cast(ROUND(sum(SOL.LineAmount),2) AS nvarchar(12)) else 0 end as LineAmount , case when sum(SOL.Amount)>0 then cast(ROUND(sum(SOL.Amount),2) AS nvarchar(12)) else 0 end as Amount , case when soh.approved =1 then 'Approved' else 'Pending' end as approvestatus ,usd.sitename as dealer,SOH.SITEID  from soheader soh left join soline sol on soh.SONO=sol.SONO and SOH.CUSTOMERCODE=SOL.Customercode and  SOH.SITEID=SOL.SITEID left join USERDISTRIBUTOR usd on soh.SITEID = usd.siteid  where SOH.Customercode= '\(self.customercode!)' and dated > '\(fromdate)' and dated <= '\(todate)' group by SOH.SONO,SOH.SODate,usd.sitename,SOH.SITEID"
        
        print("OrderListViewController==>"+query)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let amount = String(cString: sqlite3_column_text(stmt1, 5))
            var date = String(cString: sqlite3_column_text(stmt1, 2))
            let orderno = String(cString: sqlite3_column_text(stmt1, 1))
            let payableamt = String(cString: sqlite3_column_text(stmt1, 4))
            let qty = String(cString: sqlite3_column_text(stmt1, 3))
            let status = String(cString: sqlite3_column_text(stmt1, 6))
            let siteid = String(cString: sqlite3_column_text(stmt1, 8))
            
            self.orderlistadapter.append(Takeorderadapter(orderno: orderno, date: date, amount: amount, payableamt: payableamt, qty: qty, status: status))
            
            self.siteidarr.append(siteid)
        }
        self.orderListTable.reloadData()
        self.view.isUserInteractionEnabled = true
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    @IBAction func backbtn(_ sender: Any) {
        
        let customerCard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
        customerCard.customercode = self.customercode
        customerCard.customername = self.customername
        CustomerCard.siteid = self.siteid
        customerCard.pricegroup = self.pricegroup
        CustomerCard.stateid = self.stateid
        customerCard.titletxt = self.titletext
        self.navigationController?.pushViewController(customerCard, animated: true)
        
       // self.navigationController?.popViewController(animated: true)
    }
    
    func ApiCalling () {
        loadingalert = UIAlertController(title: "Downloading data", message: "Please wait...", preferredStyle: .alert)
                  loadingalert!.view.tintColor = UIColor.black
                  let loadingIndicator: UIActivityIndicatorView
                    = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
                  loadingIndicator.hidesWhenStopped = true
                  loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                  loadingIndicator.startAnimating();
                  loadingalert!.view.addSubview(loadingIndicator)
                  self.loadingalert!.dismiss(animated: false, completion: nil)
                  self.present(loadingalert!, animated: false)
                  print("loader show")
                //  self.URL_GETUSERTAXSETUP()
                  self.URL_GETUSERTAXSETUPCOUNT()
        
                 SwiftEventBus.onMainThread(self, name: "gottaxsetup")
                  {_ in
                      
                    print("event caught===========")
                    self.loadingalert!.dismiss(animated: true, completion: nil)
                    print("loader fired===========")
                    self.addorderbtn.isEnabled=true
                      //userpricelist calls here
                  }
                  SwiftEventBus.onMainThread(self, name: "nottaxsetup")
                  {_ in
                    self.loadingalert?.dismiss(animated: true, completion: nil)
                    
                    self.showalert1()
                  //  self.showtoast(controller: self, message: "Something went wrong...Please try again later!", seconds: 1.5)
                  }
                  SwiftEventBus.onMainThread(self, name: "gopricefailure")
                  {_ in
                      self.loadingalert?.dismiss(animated: true, completion: nil)
                      self.showalert1()
                   //   self.showtoast(controller: self, message: "Something went wrong...Please try again later!", seconds: 1.5)
                  }
                  SwiftEventBus.onMainThread(self, name: "sorderlist")
                  {_ in
                      self.setList()
                  }
    }
    
    func validate() -> Bool {
            var validate = true
              CustomerCard.orderid = self.getID()
               var stmt1:OpaquePointer?
               var stmt2:OpaquePointer?
               let query = "select count(*) from usertaxsetup"
               let query1 = "select count(*)  from UserPriceList"
               
               if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                   print("error preparing get: \(errmsg)")
                //   return
               }
               if(sqlite3_step(stmt1) == SQLITE_ROW){
                 //  usertax = true
                   self.taxdb = Int64(sqlite3_column_int(stmt1, 0))
                   print(self.taxdb)
               }
               if sqlite3_prepare_v2(Databaseconnection.dbs, query1, -1, &stmt2, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                   print("error preparing get: \(errmsg)")
                 //  return
               }

               if(sqlite3_step(stmt2) == SQLITE_ROW){
                 //  itemprice = true
                   self.pricedb = Int64(sqlite3_column_int(stmt2, 0))
                   print(self.pricedb)
               }
                print(AppDelegate.taxapi)
                print(AppDelegate.priceapi)
         
                if(self.taxdb == 0 || AppDelegate.taxapi == 0 || self.pricedb == 0 || AppDelegate.priceapi==0){
                  showalert1()
                  validate = false
                }
               
               if(self.taxdb != AppDelegate.taxapi || self.pricedb != AppDelegate.priceapi ){
               
               if(taxdb != AppDelegate.taxapi){
               self.deleteTaxSetup()
               }
               
               if(pricedb != AppDelegate.priceapi){
               self.deleteUserPriceList()
               }
                
               showalert1()
               validate = false
        
               }
        
           return validate ;
       }
       
       func showalert1(){
              let alert = UIAlertController(title: "Data not downloaded!", message: "Please try again Later", preferredStyle: UIAlertControllerStyle.alert)
              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
               self.backbtnIntent()
                  alert.dismiss(animated: true, completion: nil)
              }))
             
              self.present(alert, animated: true)
          }
       
       func backbtnIntent(){
        if(AppDelegate.ntwrk > 0){
            self.ApiCall()
        }
        else {
            let customerCard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            
            customerCard.customercode = self.customercode
            customerCard.customername = self.customername
            CustomerCard.siteid = self.siteid
            customerCard.pricegroup = self.pricegroup
            CustomerCard.stateid = self.stateid
            customerCard.titletxt = self.titletext
            self.navigationController?.pushViewController(customerCard, animated: true)
        }
       }
}
