//
//  MyCart.swift
//  tynorios
//
//  Created by Acxiom Consulting on 11/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.

import UIKit
import Alamofire
import SQLite3
import SwiftEventBus

class MyCart: Executeapi, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mycartadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCartcell
        
        let list: MyCartAdapter
        list = mycartadapter[indexPath.row]
        
        if isPrimary == true{
            cell.discount.isHidden = true
        }
        
        cell.productName.text = list.productname
        cell.size.text = list.size
        cell.qty.text = list.qty
        cell.amount.text = list.amount
        cell.discount.text = list.discount
        cell.paybleamt.text = list.paybleamt
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell(tableView: mycarttable, indexpath: indexPath)
        print("select")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedCell(tableView: mycarttable, indexpath: indexPath)
        print("Deselect")
    }
    
    func selectedCell(tableView: UITableView, indexpath: IndexPath){
        self.selecteditemIdarr.removeAll()
        if let selectedarr = mycarttable.indexPathsForSelectedRows{
            for index in selectedarr{
                selecteditemIdarr.append(itemidarr[index.row])
            }
            print(selecteditemIdarr)
        }
    }
    
    @IBOutlet weak var submi: UIButton!
    
    var sheetcontroller: EndTrainingBottomSheet?
    
    var orderid : String!
    var customername: String?
    var pricegroup: String?
    var stateid: String?
    var isescalated: String?
    var customercode: String?
    var titletext: String?
    var plantcode: String?
    var plantstateid: String?
    
    
    @IBOutlet weak var mycarttable: UITableView!
    
    var mycartadapter = [MyCartAdapter]()
    
    
    @IBOutlet weak var orderidlbl: UILabel!
    
    @IBOutlet weak var discountlbl: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    var siteid = ""
    var selecteditemIdarr = [String]()
    var itemidarr = [String]()
    var isApproved: Bool? = false
    var isPrimary: Bool? = false
    var socount = 0;
    var controller: UIViewController?
    var a = [UIView]()
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "My Cart")
        
        self.orderidlbl.text = CustomerCard.orderid!
        mycarttable.isEditing = true
        mycarttable.allowsMultipleSelectionDuringEditing = true
        
        mycarttable.delegate = self
        mycarttable.dataSource = self
        
         SwiftEventBus.onMainThread(self, name: "CloseTile") { Result in
            
            print("CloseTileCatched")
            print("CloseTileSiteid==="+AppDelegate.siteid)
            self.submitBtn.isEnabled = false
            self.submitBtn.isUserInteractionEnabled = false
            
            if self.isPrimary! {
                let primaryorderlist: Primaryorderlist = self.storyboard?.instantiateViewController(withIdentifier: "primaryorderlist") as! Primaryorderlist
                primaryorderlist.customercode = self.customercode
                primaryorderlist.customername = self.customername
                primaryorderlist.siteid = self.siteid
                primaryorderlist.pricegroup = self.pricegroup
                primaryorderlist.stateid = self.stateid
                primaryorderlist.plantcode = self.plantcode
                primaryorderlist.plantstateid = self.plantstateid
                primaryorderlist.titletext = self.titletext
                PendingEscalation.ispendingescalated = false
                print("CloseTileMyCArtcustomername==="+primaryorderlist.customername!)
               //      self.updatelastvisitid(lastvistactivityid: "1", customercode: self.customercode)
                if(primaryorderlist.customername == AppDelegate.pendingEscalationCustomerName
                    && AppDelegate.custCardSync == 0 ){
                   
                    AppDelegate.custCardSync = 1
    //                DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
                         self.navigationController?.pushViewController(primaryorderlist, animated: true)
    //                }
                }
              
            }
                else {
                let orderlist: OrderListViewController = self.storyboard?.instantiateViewController(withIdentifier: "orderlist") as! OrderListViewController
                orderlist.customercode = self.customercode
                orderlist.customername = self.customername
                orderlist.siteid = self.siteid
                orderlist.pricegroup = self.pricegroup
                orderlist.stateid = self.stateid
                orderlist.titletext = self.titletext
                PendingEscalation.ispendingescalated = false
                print("CloseTileMyCArtcustomername==="+orderlist.customername!)
                   // self.updatelastvisitid(lastvistactivityid: "1", customercode: self.customercode)
                if(orderlist.customername==AppDelegate.pendingEscalationCustomerName
                     && AppDelegate.custCardSync == 0){
                    AppDelegate.custCardSync = 1
                    
     //               DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
                          self.navigationController?.pushViewController(orderlist, animated: true)
     //               }
                }
            }
         }
        if isPrimary == true
        {
            self.discountlbl.isHidden = true
        }
        self.setlist()
        if isApproved! {
            submi.isHidden = true
            mycarttable.isUserInteractionEnabled = true
            mycarttable.isEditing = false
            self.hideview(view: deleteBtn)
        }
    }
    
    func setlist()
    {
        self.mycartadapter.removeAll()
         self.itemidarr.removeAll()
        self.selecteditemIdarr.removeAll()
        var stmt1:OpaquePointer?
        var flag = 0;
        var test=siteid
        
       let query = "select distinct 1 as _id,B.itemgroupid as productCode ,B.itemname as  productName,A.QTY as qty ,B.itemvarriantsize as size,ROUND(A.LINEAMOUNT,2) as la,ROUND(A.AMOUNT,2) as amount,B.itemid as itemid,ROUND((ifnull(H.DISCPERC,0 ))* A.LINEAMOUNT / 100.0, 2) AS discount  from  SOLINE A inner join ItemMaster B on A.ITEMID =B.itemid left outer join SOHEADER H on H.sono = A.sono where A.SONO = '\(CustomerCard.orderid!)' and A.SITEID='\(siteid)'UNION select distinct 1 as _id,C.itemgroupid as productCode ,C.itemname as  productName,D.QUANTITY as qty ,C.itemvarriantsize as size,ROUND(D.LINEAMOUNT,2) as la,ROUND(D.AMOUNT,2) as amount,C.itemid as itemid,0 as discount from  PURCHINDENTLINE D inner join ItemMaster C on D.ITEMID =C.itemid where D.INDENTNO ='\(CustomerCard.orderid!)' and D.SITEID='\(siteid)'"
        
        print("MyCart====" + query)
//        let query = "select distinct 1 as _id,B.itemgroupid as productCode ,B.itemname as  productName,A.QTY as qty ,B.itemvarriantsize as size,ROUND(A.LINEAMOUNT,2) as la,ROUND(A.AMOUNT,2) as amount,B.itemid as itemid,ROUND(A.secperc * A.LINEAMOUNT / 100.0, 2) AS discount  from  SOLINE A inner join ItemMaster B on A.ITEMID =B.itemid where A.SONO ='\(CustomerCard.orderid!)' and A.SITEID='\(siteid!)'UNION select distinct 1 as _id,C.itemgroupid as productCode ,C.itemname as  productName,D.QUANTITY as qty ,C.itemvarriantsize as size,ROUND(D.LINEAMOUNT,2) as la,ROUND(D.AMOUNT,2) as amount,C.itemid as itemid,0 as discount from  PURCHINDENTLINE D inner join ItemMaster C on D.ITEMID =C.itemid where D.INDENTNO ='\(CustomerCard.orderid!)' and D.SITEID='\(siteid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let productname = String(cString: sqlite3_column_text(stmt1, 2))
            let size = String(cString: sqlite3_column_text(stmt1, 4))
            let qty = String(cString: sqlite3_column_text(stmt1, 3))
            let amount = String(cString: sqlite3_column_text(stmt1, 5))
            let discount = String(cString: sqlite3_column_text(stmt1, 8))
            let paybleamt = String(cString: sqlite3_column_text(stmt1, 6))
            let itemid = String(cString: sqlite3_column_text(stmt1, 7))
            self.itemidarr.append(itemid)
            flag += 1;
            self.mycartadapter.append(MyCartAdapter(productname: productname, size: size, qty: qty, amount: amount, discount: discount, paybleamt: paybleamt,itemid:itemid))
        }
        if (flag == 0){
            self.showtoast(controller: self, message: "Cart is empty", seconds: 1.5)
        }
        self.mycarttable.reloadData()
    }
    
    func deleteOrderFronList(itemidarrList: [String])
    {
        if(itemidarrList.count > 0){
            if isPrimary! {
                self.deleteIndentMultiSelect(indentid: CustomerCard.orderid!, Itemid: self.selecteditemIdarr)
            }
            else{
                self.deleteSoLineMultiSelect(sono: CustomerCard.orderid! , Itemid: self.selecteditemIdarr)
            }
            
            self.setlist()
        }
        else{
            self.showtoast(controller: self, message: "Please select item to delete", seconds: 1.5)
        }
    }
    
    func showalert(){
        let alert = UIAlertController(title: "Delete Line!!!", message: "Are you sure you want to delete", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.deleteOrderFronList(itemidarrList: self.itemidarr)
            
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func deletBtn(_ sender: Any) {
        
        if mycartadapter.count > 0 {
            if selecteditemIdarr.count > 0{
                self.showalert()
            }
            else{
                self.showtoast(controller: self, message: "Please select item to delete", seconds: 1.5)
            }
        }
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
    
    private func makeSearchViewControllerIfNeeded() -> EndTrainingBottomSheet {
        let currentPullUpController = self.controller?.childViewControllers
            .filter({ $0 is EndTrainingBottomSheet })
            .first as? EndTrainingBottomSheet
        let pullUpController: EndTrainingBottomSheet = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "endbottomsheet") as! EndTrainingBottomSheet
        let base:Baseactivity = Baseactivity()
        
        pullUpController.usercode = "escalationclosing"
        AppDelegate.customercode = self.customercode!
        pullUpController.trainingid = CustomerCard.orderid!
        pullUpController.trainingdate = base.getTodaydatetime()
        
        return pullUpController
    }
    
    @IBAction func submitbtn(_ sender: Any) {
        if validate() {
        if PendingEscalation.ispendingescalated {
            //open training end bottom sheet here for description to be entered by user while closing escalation+
            a = self.view.subviews
            blurView1(view: self.view.subviews[a.count - 1])
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            sheetcontroller = storyboard.instantiateViewController(withIdentifier: "endbottomsheet") as! EndTrainingBottomSheet
            let base:Baseactivity=Baseactivity()
            sheetcontroller?.usercode = "escalationclosing"
            sheetcontroller?.trainingdate = base.getTodaydatetime()

//            sheetcontroller?.trainingid = self.trainingid
//            sheetcontroller?.usercode = self.usercode
//            sheetcontroller?.trainingdate = base.getTodaydatetime()
            
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
            
            
        }else {
            PendingEscalation.ispendingescalated = false
            approveorder(orderno: CustomerCard.orderid!, approvedate: self.getTodaydatetime(),Remark: "")
            updatelastvisitid(lastvistactivityid: "1", customercode: self.customercode!)
            self.checknet()
            if AppDelegate.ntwrk > 0
            {
                let postapi = Postapi()
                if isPrimary! {
                postapi.postPrimaryOrder()
                }else{
                    postapi.postSecondaryOrder()
                }
            }
            
            if isPrimary! {
                let primaryorderlist: Primaryorderlist = self.storyboard?.instantiateViewController(withIdentifier: "primaryorderlist") as! Primaryorderlist
                
                primaryorderlist.customercode = self.customercode
                primaryorderlist.customername = self.customername
                primaryorderlist.siteid = self.siteid
                primaryorderlist.pricegroup = self.pricegroup
                primaryorderlist.stateid = self.stateid
                primaryorderlist.plantcode = self.plantcode
                primaryorderlist.plantstateid = self.plantstateid
                primaryorderlist.titletext = self.titletext
                self.updatelastvisitid(lastvistactivityid: "1", customercode: customercode)
                self.showtoast(controller: self, message: "Order Generated", seconds: 1)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
                    self.navigationController?.pushViewController(primaryorderlist, animated: true)
                }
                
            }
            else {
                let orderlist: OrderListViewController = self.storyboard?.instantiateViewController(withIdentifier: "orderlist") as! OrderListViewController
                orderlist.customercode = self.customercode
                orderlist.customername = self.customername
                orderlist.siteid = self.siteid
                orderlist.pricegroup = self.pricegroup
                orderlist.stateid = self.stateid
                orderlist.titletext = self.titletext
                self.updatelastvisitid(lastvistactivityid: "1", customercode: customercode)
                self.showtoast(controller: self, message: "Order Generated", seconds: 1)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
                    self.navigationController?.pushViewController(orderlist, animated: true)
                   }
            }
            
        }
      }
    }
    
    func validate() -> Bool {
        if isPrimary! {
            var stmt1:OpaquePointer?
            let query =  "select cast(ROUND(ifnull(sum(QUANTITY),0),2) AS nvarchar(12)) as totalQty,ifnull(cast(ROUND(count(QUANTITY),2)  AS nvarchar(12)),'0') as  noitem,cast(ROUND(ifnull(sum(AMOUNT),0),2)  AS nvarchar(12)) as totalval from PURCHINDENTLINE WHERE INDENTNO = '\(CustomerCard.orderid!)'"
            if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                
                return false
            }
            
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                let val:Double =  ((String(cString: sqlite3_column_text(stmt1, 2))) as NSString).doubleValue
                if(val < 20000){
                    showtoast(controller: self, message: "Value should be greater than 20000", seconds: 1.0)
                    
                    return false;
                }
            }
            else{
                showtoast(controller: self, message: "Enter Quantity", seconds: 1.0)
                return false;
            }
        }else{
            getsoorder()
            if socount > 0 {
                return true
            }
            else {
                self.showtoast(controller: self, message: "No Order", seconds: 1.5)
                return false
            }
        }
        return true
    }
    
    @IBAction func backbtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    func getsoorder()
    {
        var stmt1: OpaquePointer?
        socount = 0
        let query = "select distinct 1 as _id,B.itemgroupid as productCode ,B.itemname as productName,A.QTY as qty ,B.itemvarriantsize as size,CAST(A.LINEAMOUNT AS DECIMAL(18,2)) as la,CAST(A.AMOUNT AS DECIMAL(18,2)) as amount,B.itemid as itemid,ROUND(A.secperc * A.LINEAMOUNT / 100.0, 2) AS discount  from SOLINE A inner join ItemMaster B on A.ITEMID =B.itemid where A.SONO ='\(CustomerCard.orderid!)' and A.SITEID='\(siteid)' UNION select distinct 1 as _id,C.itemgroupid as productCode ,C.itemname as productName,D.QUANTITY as qty ,C.itemvarriantsize as size,CAST(D.LINEAMOUNT AS DECIMAL(18,2)) as la,CAST(D.AMOUNT AS DECIMAL(18,2)) as amount,C.itemid as itemid,0 as discount from PURCHINDENTLINE D inner join ItemMaster C on D.ITEMID =C.itemid where D.INDENTNO ='\(CustomerCard.orderid!)' and D.SITEID='\(siteid)' order by productName "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            socount += 1
        }
    }
}
