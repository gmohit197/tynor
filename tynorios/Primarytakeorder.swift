//
//  Primarytakeorder.swift
//  tynorios
//
//  Created by Acxiom Consulting on 12/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SkyFloatingLabelTextField
import SwiftEventBus


class Primarytakeorder: Executeapi,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,QTY1,PromotionalDelegate  {
    func setstate(at index: IndexPath, state: Bool) {
        
        let list: Prmotionaladapter

        list = promotionaladapter[index.row]

        list.state = state
    }
    
    
    func nextbtn(at index: IndexPath, textfield: UITextField) {
          let cell = self.primaryitemtable.dequeueReusableCell(withIdentifier: "cell", for: index) as! PrimaryOrderItem
          
          self.donext(textfield: textfield)
      }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotionaladapter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Promotionalcell

          

          let list: Prmotionaladapter

          list = promotionaladapter[indexPath.row]

      
          cell.prmotionalitem.isSelected = list.state!

      }

      

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Promotionalcell
          let list: Prmotionaladapter
          list = promotionaladapter[indexPath.row]
          cell.prmotionalitem.setTitle(list.itemname, for: UIControlState.normal)
          cell.prmotionalitem.isSelected = list.state!

          cell.index = indexPath

          cell.delegate = self
        return cell

      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return primaryorderitemadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PrimaryOrderItem
        let list: PrimaryOrderItemadapter
        list = primaryorderitemadapter[indexPath.row]
        
        cell.size.text = list.size
        cell.shipperqty.text = list.shipperqty
        
        var stmt1: OpaquePointer?
        
        let q: String = "select ifnull(Quantity,'') from PURCHINDENTLINE where ITEMID = '\(list.itemid!)' and INDENTNO = '\(CustomerCard.orderid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            cell.qty.text = String(cString: sqlite3_column_text(stmt1, 0))
            
        } else{
            cell.qty.text = ""
        }
        
     //   cell.qty.tag = indexPath.row
        cell.qty.tag = list.index
        cell.index = indexPath
        
      //  cell.qty.delegate = self
        cell.delegate = self
        cell.qty.returnKeyType = UIReturnKeyType.next
        cell.qty.keyboardType = UIKeyboardType.numberPad
        cell.price.text = list.price
        cell.itemid = list.itemid
        cell.ispcsapply = list.ispcsapply
        cell.siteid = list.siteid
        cell.orderid = list.orderid
        cell.itemgroupid = list.itemgroupid
        cell.plantstateid = list.plantstateid
        cell.stateid = list.stateid
        cell.controller = self
        return cell
    }
    
    var primaryorderitemadapter = [PrimaryOrderItemadapter]()
    var promotionaladapter = [Prmotionaladapter]()
    
    @IBOutlet weak var promotionalitem: UICollectionView!
    @IBOutlet weak var primaryitemtable: UITableView!
    @IBOutlet weak var productspinr: DropDownUtil!
    @IBOutlet weak var itemincartlbl: UILabel!
    @IBOutlet weak var rupeelbl: UILabel!
    @IBOutlet weak var totalqty: UILabel!
    
    var customercode: String?
    var customername: String?
    var pricegroup: String?
    var siteid: String?
    var stateid: String?
    var orderid: String?
    var plantstateid: String?
    var plantcode: String?
    var itemidarr: [String]!
    var itemid: String?
    var titletext: String?
    
    @IBOutlet weak var submitview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "\(customername!)")
        itemidarr = []
        productspinr.optionIds = []
        primaryorderitemadapter = []
        
        let tapsubmit = UITapGestureRecognizer(target: self, action: #selector(clicksubmit))
        tapsubmit.numberOfTapsRequired=1
        submitview.addGestureRecognizer(tapsubmit)
        
        primaryitemtable.delegate = self
        primaryitemtable.dataSource = self
        
        productspinr.didSelect { (selected, index, id) in
            self.itemid = self.itemidarr[index]
            self.setitemtable()
        }
        setpromotionalitem()
        setproductspinnr()
        setorderdetail()
        NotificationCenter.default.addObserver(self, selector: #selector(setorderdetail), name: NSNotification.Name(rawValue: constant.key), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        primaryitemtable.reloadData()
        setorderdetail()
        if !(self.productspinr.text! == ""){
        getselecteditem()
        }
    }
    
    func getselecteditem()
    {
        var stmt1: OpaquePointer?
        let query = "select distinct itemgroupid,substr(itemid,1,3) || ' - ' || itemname as itemnamed from ItemMaster where isblocked='false' and itembuyergroupid in (select itemgrpid as itembuyergroupid from USERDISTRIBUTORITEMLINK where siteid = '\(CustomerCard.siteid!)') and itemnamed = '\(self.productspinr.text!)'"

        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }

        while(sqlite3_step(stmt1) == SQLITE_ROW){
            self.itemid = String(cString: sqlite3_column_text(stmt1, 0))
            self.setitemtable()
        }
    }
    
    
    func setproductspinnr()
    {
        productspinr.optionArray.removeAll()
        productspinr.optionIds?.removeAll()
        itemidarr.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select distinct itemgroupid,substr(itemid,1,3) || ' - ' || itemname as itemname from ItemMaster where isblocked='false' and itembuyergroupid in (select itemgrpid as itembuyergroupid from USERDISTRIBUTORITEMLINK where siteid = '\(CustomerCard.siteid!)')"
        
        print ("setproductspinnrPrimary==" + query)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 1))
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            
            
            //let productname = "\(itemcode.prefix(3)) - \(itemname)"
            productspinr.optionArray.append(itemname)
            productspinr.optionIds?.append(Int(itemid) ?? 0)

//            productspinr.optionIds?.append(itemid)
            itemidarr.append(String(cString: sqlite3_column_text(stmt1, 0)))
        }
    }
    
    func setpromotionalitem()
    {
        
        promotionaladapter.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "select 1 _id,B.rowid,*,case when isapprove='0' then 'PENDING' else 'APPROVED' end as status  from ProductDay B join (select distinct itemname,itemgroup, itemgroupid from ItemMaster) A on A.itemgroupid = B.itemgroupid where B.isdate like '\(self.getdate())%' order by itemname"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 9 ))
            
            promotionaladapter.append(Prmotionaladapter(itemname: itemname, state: false))
        }
        
        promotionalitem.reloadData()
    }
    
    func setitemtable()
    {
        primaryorderitemadapter.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "select distinct 1 as _id , A.itemid,A.itemvarriantsize,A.itemname,ifnull(C.QUANTITY,'') as qty,B.price,A.itemgroupid,C.LINEAMOUNT ,A.itempacksize ,A.ispcsapply from ItemMaster A inner join UserPriceList B on A.itemid = B.itemid  left outer join PURCHINDENTLINE C on A.itemid = C.ITEMID  and C.INDENTNO='\(CustomerCard.orderid!)' where itemgroupid = '\(itemid!)' and B.pricegroupid= '\(pricegroup!)' and B.price > 0 and isblocked = 'false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
         var i: Int! = 0
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let itemvarriantsize = String(cString: sqlite3_column_text(stmt1, 2))
            let shipperqty = String(cString: sqlite3_column_text(stmt1, 8))
            let qty = String(cString: sqlite3_column_text(stmt1, 4))
            let price = String(cString: sqlite3_column_text(stmt1, 5))
            let itemid = String(cString: sqlite3_column_text(stmt1, 1))
            let ispcsapply = String(cString: sqlite3_column_text(stmt1, 9))
            
            primaryorderitemadapter.append(PrimaryOrderItemadapter(size: itemvarriantsize, shipperqty: shipperqty, qty: qty, price: price, itemid: itemid, ispcsapply: ispcsapply, siteid: CustomerCard.siteid, orderid: self.orderid, itemgroupid: self.itemid, plantstateid: CustomerCard.plantstateid, stateid: CustomerCard.stateid, index: i))
            
             i = i + 1
        }
        primaryitemtable.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let list: PrimaryOrderItemadapter = primaryorderitemadapter[textField.tag]
        
        let qtyStr = (textField.text! as NSString)
        var qtyInt: Int
        let _: Int32
        if qtyStr != ""
        {
            qtyInt = (textField.text! as NSString).integerValue
            let shipperInt: Int = (list.shipperqty! as NSString).integerValue
            
            let ispcsapply: String = list.ispcsapply!
            
            if((qtyInt % shipperInt == 0 && ispcsapply == "N") || ispcsapply == "Y" ){
                list.qty = "\(qtyInt)"
                
                let i:Int  = self.insertindentline(siteid: CustomerCard.siteid, indentid: self.orderid, itemid: list.itemid, itemgroupid: self.itemid, packsize: list.shipperqty, shipper: "\(shipperInt)", qty: qtyInt, price: list.price, plantstateid: CustomerCard.plantstateid, stateid: CustomerCard.stateid)

                if(i == 0){
                    showtoast(controller: self, message: "Tax setup not available" , seconds: 2.0)
                    textField.text = ""
                }
                
            } else{
                showtoast(controller: self, message: "Quantity must be in shipper" , seconds: 2.0)
                textField.text = ""
            }
        }
        
        if let nextResponder = textField.superview?.superview?.superview?.superview?.viewWithTag(nextTag)
        {
            nextResponder.becomeFirstResponder()
        }
            
        else
        {
            textField.resignFirstResponder()
        }
        
        setorderdetail()
        return true
    }
    
    @objc func clicksubmit(){
        if productspinr.text != "" {
         self.setitemtable()
        }
        let item: MyCart = self.storyboard?.instantiateViewController(withIdentifier: "mycart") as! MyCart
        
        item.siteid = CustomerCard.siteid!
        item.isPrimary = true
        item.plantcode = CustomerCard.plantcode
        item.plantstateid = CustomerCard.plantstateid
        item.titletext = self.titletext
        item.customername = self.customername
        item.customercode = self.customercode
        item.pricegroup = self.pricegroup
        
        self.navigationController?.pushViewController(item, animated: true)
   
    }
    
    @objc func setorderdetail()
    {
        var stmt1: OpaquePointer?
        
        let query =  "select cast(ROUND(ifnull(sum(QUANTITY),0),2) AS nvarchar(12)) as totalQty,ifnull(cast(ROUND(count(QUANTITY),2)  AS nvarchar(12)),'0') as  noitem,cast(ROUND(ifnull(sum(LINEAMOUNT),0),2)  AS nvarchar(12)) as totalval from PURCHINDENTLINE WHERE INDENTNO = '\(CustomerCard.orderid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            self.itemincartlbl.text = String(cString: sqlite3_column_text(stmt1, 1)) + " items in cart"
            self.rupeelbl.text = "₹ " + String(cString: sqlite3_column_text(stmt1, 2))
            self.totalqty.text = "Total Qty: " + String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Next Button Click
    func donext(textfield : UITextField) {
         let nextTag = textfield.tag + 1
           let list: PrimaryOrderItemadapter
           list = primaryorderitemadapter[textfield.tag]
           let qtyStr = (textfield.text! as NSString)
        
           var qtyInt: Int
          // let _: Int32
         //  let result: Int32
           
          if qtyStr == ""
           {
               qtyInt = 0
           }
           else{
               qtyInt = (textfield.text! as NSString).integerValue
           }
           
        let shipperInt: Int = (list.shipperqty! as NSString).integerValue
        let ispcsapply: String = list.ispcsapply!
        let value = Double(qtyInt).truncatingRemainder(dividingBy:Double(shipperInt))
        print("Value")
        print(value)
        
        var validate = false
        
        if(value.isNaN){
            validate = ((value.isNaN && ispcsapply == "N") || ispcsapply == "Y" )
        }
        else{
            validate = ((qtyInt % shipperInt == 0 && ispcsapply == "N") || ispcsapply == "Y" )
        }
        
        
      //  if((qtyInt % shipperInt == 0 && ispcsapply == "N") || ispcsapply == "Y" ){
            //   if((value.isNaN && ispcsapply == "N") || ispcsapply == "Y" ){
               if(validate) {
               list.qty = "\(qtyInt)"
               
               let i:Int  = self.insertindentline(siteid: CustomerCard.siteid, indentid: self.orderid, itemid: list.itemid, itemgroupid: self.itemid, packsize: list.shipperqty, shipper: "\(shipperInt)", qty: qtyInt, price: list.price, plantstateid: CustomerCard.plantstateid, stateid: CustomerCard.stateid)
               
               if(i == 0){
                   showtoast(controller: self, message: "Tax Setup is not Available" , seconds: 2.0)
                   textfield.text = ""
            }
           }else{
               showtoast(controller: self, message: "Quantity must be in shipper" , seconds: 2.0)
               textfield.text = ""
           }
        
           if let nextResponder = textfield.superview?.superview?.superview?.superview?.viewWithTag(nextTag) as? UITextField
           {
               nextResponder.becomeFirstResponder()
           }
           else
           {
               textfield.resignFirstResponder()
           }
           setorderdetail()
       }
}
