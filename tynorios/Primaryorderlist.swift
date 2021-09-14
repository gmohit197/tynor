//
//  Primaryorderlist.swift
//  tynorios
//
//  Created by Acxiom Consulting on 12/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import Foundation
import SwiftEventBus

class Primaryorderlist: Executeapi, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return primaryorderadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Primarytakeordercell
        let list: Takeorderadapter
        list = primaryorderadapter[indexPath.row]
        cell.orderno.text = list.orderno
        cell.amount.text = list.payableamt
        cell.date.text = list.date
        cell.qty.text = list.qty
        cell.paybleamt.text = list.amount
        cell.status.text = list.status
        return cell
    }
    
    
    var primaryorderadapter = [Takeorderadapter]()
    var customercode: String?
    var customername: String?
    var pricegroup: String?
    var siteid: String?
    var stateid: String?
    var orderid: String?
    var plantstateid: String?
    var plantcode: String?
    var titletext: String?
    var taxdb : Int64 = 0
    var pricedb : Int64 = 0
    
    
    @IBOutlet weak var primaryordertable: UITableView!
    @IBOutlet weak var addOrder: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        checknet()
        if AppDelegate.ntwrk==1
        {
            var loadingalert:UIAlertController?
            loadingalert = UIAlertController(title: "Downloading data", message: "Please wait...", preferredStyle: .alert)
            loadingalert!.view.tintColor = UIColor.black
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            
            self.URL_GETUSERTAXSETUPCOUNT()
            loadingalert!.view.addSubview(loadingIndicator)
            self.present(loadingalert!, animated: true)
            
            SwiftEventBus.onMainThread(self, name: "gottaxsetup")
            {_ in
                loadingalert?.dismiss(animated: true, completion: nil)
                //userpricelist calls here
            }
            SwiftEventBus.onMainThread(self, name: "nottaxsetup")
            {_ in
                loadingalert?.dismiss(animated: true, completion: nil)
                self.showalert1()
            }
            SwiftEventBus.onMainThread(self, name: "gopricefailure")
            {_ in
                loadingalert?.dismiss(animated: true, completion: nil)
                self.showalert1()
            }
            SwiftEventBus.onMainThread(self, name: "sorderlist")
            {_ in
                self.setlist()
            }
        }
        else{
            if(!(self.validate()))
            {
                addOrder.isEnabled=false
                self.showtoast(controller: self, message: "No internet available to download the data", seconds: 1.5)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setlist()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "\(customername!)")
        setlist()
        primaryordertable.delegate = self
        primaryordertable.dataSource = self
        
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(clickorder))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.primaryordertable.addGestureRecognizer(tapeno)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.4 // 1 second press
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.primaryordertable.addGestureRecognizer(longPressGesture)

        SwiftEventBus.onMainThread(self, name: "porderlist")
        {_ in
            self.setlist()
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.primaryordertable)
            if let indexPath = primaryordertable.indexPathForRow(at: touchPoint) {
                let index = indexPath.row
                let orderItem: Takeorderadapter
                orderItem = primaryorderadapter[index]
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
            self.deleteindent(indentid: index)
            self.setlist()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func addorder(_ sender: Any) {
        if(self.validate()){
            createindent(todaydate: getTodaydatetime(), siteid: siteid, indentid: CustomerCard.orderid, status: "0", plantcode: plantcode, dataareaid: UserDefaults.standard.string(forKey: "dataareaid"))
            
            let primaryorderitme: Primarytakeorder = self.storyboard?.instantiateViewController(withIdentifier: "primaryorderitem") as! Primarytakeorder
            primaryorderitme.customercode = self.customercode
            primaryorderitme.customername = self.customername
            primaryorderitme.pricegroup =  self.pricegroup
            primaryorderitme.siteid = CustomerCard.siteid
            primaryorderitme.stateid = CustomerCard.stateid
            primaryorderitme.orderid = self.orderid
            primaryorderitme.plantcode = CustomerCard.plantcode
            primaryorderitme.plantstateid = CustomerCard.plantstateid
            primaryorderitme.titletext = self.titletext
            
            self.navigationController?.pushViewController(primaryorderitme, animated: true)
        }
    }
    
    @objc func clickorder(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.primaryordertable)
        if let indexPath = primaryordertable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            let orderItem: Takeorderadapter
            orderItem = primaryorderadapter[index]
            CustomerCard.orderid = orderItem.orderno
            
            if orderItem.status == "Pending" {
                let primaryorderitme: Primarytakeorder = self.storyboard?.instantiateViewController(withIdentifier: "primaryorderitem") as! Primarytakeorder
                primaryorderitme.customercode = self.customercode
                primaryorderitme.customername = self.customername
                primaryorderitme.pricegroup =  self.pricegroup
                CustomerCard.siteid = self.siteid
                CustomerCard.stateid = self.stateid
                CustomerCard.plantcode = self.plantcode
                CustomerCard.plantstateid = self.plantstateid
                primaryorderitme.titletext = self.titletext
                self.navigationController?.pushViewController(primaryorderitme, animated: true)
                
            }
            else{
                let item: MyCart = self.storyboard?.instantiateViewController(withIdentifier: "mycart") as! MyCart
                item.siteid = self.siteid!
                item.isApproved = true
                item.isPrimary = true
                item.titletext = self.titletext
                self.navigationController?.pushViewController(item, animated: true)
            }
        }
    }
    func setlist()
    {
        primaryorderadapter.removeAll()
        var stmt1: OpaquePointer?
        let fromdate = self.getdate(days: -2)
        let todate = self.getdate()
        
        let query = "select 1 as _id,SOH.INDENTNO,substr(SOH.INDENTDATE,1,10) as dated,case when sum(SOL.QUANTITY)>0 then cast(ROUND(sum(SOL.QUANTITY),2)  AS nvarchar(12)) else 0 end as QUANTITY,case when sum(SOL.LineAmount)>0 then  cast(ROUND(sum(SOL.LineAmount),2)  AS nvarchar(12)) else 0 end as LineAmount , case when sum(SOL.Amount)>0 then  cast(ROUND(sum(SOL.Amount),2)  AS nvarchar(12)) else 0 end as Amount ,  case when soh.STATUS =1 then 'Approved' else 'Pending' end as approvestatus from PURCHINDENTHEADER soh left join PURCHINDENTLINE sol on soh.INDENTNO=sol.INDENTNO  where SOH.SITEID= '\(siteid!)' and dated > '\(fromdate)' and dated <= '\(todate)' group by SOH.INDENTNO,SOH.INDENTDATE"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let  indentno = String(cString: sqlite3_column_text(stmt1, 1))
            let  date = String(cString: sqlite3_column_text(stmt1, 2))
            let  amount = String(cString: sqlite3_column_text(stmt1, 5))
            let  paybleamt = String(cString: sqlite3_column_text(stmt1, 4))
            let  qty = String(sqlite3_column_int64(stmt1, 3))
            let  status = String(cString: sqlite3_column_text(stmt1, 6))
            self.primaryorderadapter.append(Takeorderadapter(orderno: indentno, date: date, amount: amount, payableamt: paybleamt, qty: qty, status: status))
        }
        self.primaryordertable.reloadData()
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
            
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            self.taxdb = Int64(sqlite3_column_int(stmt1, 0))
            print(self.taxdb)
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query1, -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        
        if(sqlite3_step(stmt2) == SQLITE_ROW){
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
            self.showalert1()
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
