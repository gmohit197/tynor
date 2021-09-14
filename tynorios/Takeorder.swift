//
//  Takeorder.swift
//  tynorios
//
//  Created by Acxiom Consulting on 05/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.

import UIKit
import SQLite3
import SkyFloatingLabelTextField
import SwiftEventBus

class Takeorder:  Executeapi, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate,QTY,PromotionalDelegate {

   func setstate(at index: IndexPath, state: Bool) {
       let list: Prmotionaladapter
       list = promotionaladapter[index.row]
       list.state = state
   }
    
    func nextbtn(at index: IndexPath, textfield: UITextField) {
        let cell = self.itemlist.dequeueReusableCell(withIdentifier: "cell", for: index) as! Ordreitemcell
        self.donext(textfield: textfield)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return promotionaladapter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PromotionalSecondarycell
        let list: Prmotionaladapter
        list = promotionaladapter[indexPath.row]
        cell.prmotionalitem.isSelected = list.state!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PromotionalSecondarycell
        let list: Prmotionaladapter
        list = promotionaladapter[indexPath.row]
        cell.prmotionalitem.setTitle(list.itemname, for: UIControlState.normal)
        cell.prmotionalitem.isSelected = list.state!
        cell.index = indexPath
        cell.delegate = self
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderitemadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Ordreitemcell
        
        let list: OrderItemAdapter
        list = orderitemadapter[indexPath.row]
        cell.price.text = list.price
        cell.qty.keyboardType = UIKeyboardType.default
        
        var stmt1: OpaquePointer?
        
        let q: String = "select ifnull(QTY,'') from SOLINE where ITEMID = '\(list.itemid!)' and SONO = '\(CustomerCard.orderid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, q , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            cell.qty.text = String(cString: sqlite3_column_text(stmt1, 0))
            
        }else{
            cell.qty.text = ""
        }
        
        //        cell.qty.text = list.qty
        cell.sizelbl.text = list.size
        cell.itemid = list.itemid
        cell.sono = list.sono
        cell.siteid = list.siteid
        cell.custstate = list.custstate
        cell.customercode = list.customercode
        cell.qty.tag = list.index
        cell.index = indexPath
        
        cell.qty.returnKeyType = UIReturnKeyType.next
        cell.qty.keyboardType = UIKeyboardType.numberPad
        
        cell.controller = self
//        cell.qty.delegate = self
        cell.delegate = self
        
        return cell
    }
    
    @IBOutlet weak var promitionalitem: UICollectionView!
    @IBOutlet weak var dealerspinr: DropDownUtil!
    @IBOutlet weak var productspinr: DropDownUtil!
    @IBOutlet weak var submitview: UIView!
    @IBOutlet weak var itemlist: UITableView!
    @IBOutlet weak var discount: SkyFloatingLabelTextField!
    @IBOutlet weak var itemincart: UILabel!
    @IBOutlet weak var totalamount: UILabel!
    @IBOutlet weak var totalqty: UILabel!
    
    @IBOutlet weak var someView: UIView!
    
    var orderitemadapter = [OrderItemAdapter]()
    var promotionaladapter = [Prmotionaladapter]()
    var btnflag: Bool!
    var customercode: String?
    var customername: String?
    var pricegroup: String?
    var siteid: String?
    var stateid: String?
    var ordrid: String?
    var sitearr: [String]!
    var itemidarr: [String]!
    var itemid: String?
    //   var toolbar = UIToolbar()
    
    var titletext: String?
    var doneButton = UIBarButtonItem()
    var allowdis: Int64!
    var siteidVal: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        itemidarr = []
        sitearr = []
        productspinr.optionIds = []
        orderitemadapter = []
        self.getDiscount()
        
        if discount.text!.isEmpty {
            self.showtoast(controller: self, message: "Please enter valid Discount", seconds: 1.5)
        }

//        func textFieldDidBeginEditing(textField: UITextField) {
//             self.productspinr.text?.removeAll()
//        }
        
        
        self.dealerspinr.listHeight = 250.0
        
        self.setnav(controller: self, title: "\(customername!)")
        let tapsubmit = UITapGestureRecognizer(target: self, action: #selector(clicksubmit))
        tapsubmit.numberOfTapsRequired=1
        submitview.addGestureRecognizer(tapsubmit)
        allowdiscount()
        
        itemlist.delegate = self
        itemlist.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setdetail), name: NSNotification.Name(rawValue: constant.key), object: nil)
        
        productspinr.didSelect { (selected, index, id) in
             
            self.itemid = self.itemidarr[index]
            if(self.itemidarr.count > 0 ){
                self.setItemTable()
            }
            else{
                self.productspinr.isUserInteractionEnabled = false
            }
        }
        
        dealerspinr.didSelect { (selected, index, id) in
          //   self.view.isUserInteractionEnabled = true
            self.itemlist.endEditing(true)
            self.siteid = self.sitearr[index]
            self.deleteItemtable()
            self.createSoOrder(userid: UserDefaults.standard.string(forKey: "usercode"), todaydate: self.getTodaydatetime(), siteid: self.siteid, customercode: self.customercode, latitude: "0", longitude: "0", percent: self.discount.text, sono: self.ordrid)
         //   self.productspinr.text = ""
            self.setproductspinnr()
            
            if self.orderitemadapter.count > 0 {
                self.itemlist.reloadData()
            }
           //  self.setItemTable()
            self.setdetail()
        }
        
        setdealerspinr()
        setpromotionalitem()
        setproductspinnr()
        setdetail()
        
        if(AppDelegate.titletxt == "Sub Dealer" || AppDelegate.titletxt == "Sub-Dealer" ){
            allowdis = 55
        }
            
        else{
            allowdiscount()
        }
        
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        itemlist.reloadData()
        setdetail()
        if !(self.productspinr.text! == ""){
            getselecteditem()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    func getselecteditem()
    {
       
             var stmt1: OpaquePointer?
            //        let query = "select distinct itemgroupid,substr(itemid,1,3) || ' - ' || itemname as itemnamed from ItemMaster where isblocked='false' and itembuyergroupid in (select itemgrpid as itembuyergroupid from USERDISTRIBUTORITEMLINK where siteid = '\(self.dealerspinr.text!.prefix(4))') and itemnamed = '\(self.productspinr.text!)'"
                    let query = "select distinct itemgroupid,substr(itemid,1,3) || ' - ' || itemname as itemnamed from ItemMaster where isblocked='false' and itembuyergroupid in (select itemgrpid as itembuyergroupid from USERDISTRIBUTORITEMLINK where siteid = '\(self.siteid!)' and itemsubgroup not in ('PRINTING & STATIONERY','BUSINESS PROMOTION') )  and itemnamed = '\(self.productspinr.text!)')"
                      
                    if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                        print("error preparing get: \(errmsg)")
                        return
                    }
                    
                  print("getSelectedItem=" + query )
                    while(sqlite3_step(stmt1) == SQLITE_ROW){
                        self.itemid = String(cString: sqlite3_column_text(stmt1, 0))
                        self.setItemTable()
                    }
       
    }
    func getSiteId()
    {
        var stmt1: OpaquePointer?
        let query = "select  siteid  from USERDISTRIBUTOR  where sitename = '\(self.dealerspinr.text!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            self.siteidVal = String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    func deleteItemtable(){
        let query = "delete from SOLINE where SONO='\(CustomerCard.orderid!)'"
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting Table ProductDay ")
            return
        }
        print("SOLINE table deleted")
    }
    
    
    @IBAction func discCheck(_ sender: SkyFloatingLabelTextField) {
        var allowdiscount: Int64
        //  if !discount.text!.isEmpty && productspinr.text == "" {
        if !discount.text!.isEmpty {
            allowdiscount = Int64(discount.text!)!
            if discount.text == "0" || discount.text == ""
            {
                self.showtoast(controller: self, message: "Please Enter Valid Discount", seconds: 1.5)
            }
            else{
                if allowdiscount > allowdis
                {
                    self.showtoast(controller: self, message: "Discount Percent Not Applicable", seconds: 1.5)
                    self.discount.text = ""
                }
            }
        }
        if !discount.text!.isEmpty
        {
            self.deleteItemtable()
            if productspinr.text != "" {
                setItemTable()
            }
            self.createSoOrder(userid: UserDefaults.standard.string(forKey: "usercode"), todaydate: self.getTodaydatetime(), siteid: self.siteid, customercode: self.customercode, latitude: "0", longitude: "0", percent: self.discount.text, sono: self.ordrid)
            setdetail()
        }
    }
    
    func allowdiscount()
    {
        var stmt1: OpaquePointer?
        let query = "select alloweddisc from ProfileDetail"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            allowdis = Int64(String(sqlite3_column_int64(stmt1, 0)))
        }
    }
    
    func getDiscount()
    {
        var stmt1: OpaquePointer?
        let query = "select discperc from SOHEADER WHERE SONO = '\(CustomerCard.orderid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let discountper = String(cString: sqlite3_column_text(stmt1, 0))
            if discountper == "0"
            {
                
            }
            else{
                discount.text = discountper
            }
        }
    }
    
    @objc func setdetail()
    {
        var stmt1: OpaquePointer?
        let query = "select CAST(ifnull(sum(QTY),0)  AS nvarchar(12)) as totalQty,CAST(count(QTY) AS nvarchar(12)) as  noitem,CAST(ROUND(ifnull(sum(LINEAMOUNT),0),2) AS nvarchar(12)) as totalval from SOLINE WHERE SONO = '\(CustomerCard.orderid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            itemincart.text = String(cString: sqlite3_column_text(stmt1, 1)) + "items in cart"
            totalamount.text = "₹" + String(cString: sqlite3_column_text(stmt1, 2))
            totalqty.text = "Total Qty:" + String(cString: sqlite3_column_text(stmt1, 0))
        }
    }
    
    @objc func clicksubmit(){
        if discount.text == "" || discount.text == "0" {
            self.showtoast(controller: self, message: "Please Enter Valid Discount", seconds: 1.5)
        }
        else if (Int64(discount.text!)! > allowdis){
            self.showtoast(controller: self, message: "Discount Percent Not Applicable", seconds: 1.5)
            self.discount.text = ""
        }
            
        else{
            if productspinr.text != "" {
                self.setItemTable()
            }
//           self.setItemTable()
           let item: MyCart = self.storyboard?.instantiateViewController(withIdentifier: "mycart") as! MyCart
                       
            item.siteid = self.siteid!
            item.customername = self.customername
            item.customercode = self.customercode
            item.titletext = self.titletext
            item.stateid = self.stateid
            item.pricegroup = self.pricegroup
            item.isPrimary = false
            self.navigationController?.pushViewController(item, animated: true)
        }
    }
    
    func setpromotionalitem()
    {
        promotionaladapter.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "select 1 _id,B.rowid,*,case when isapprove='0' then 'PENDING' else 'APPROVED' end as status  from ProductDay B join (select distinct itemname,itemgroup, itemgroupid from ItemMaster) A on A.itemgroupid = B.itemgroupid where status='APPROVED' and B.isdate like '\(self.getdate())%' order by itemname "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 9 ))
            promotionaladapter.append(Prmotionaladapter(itemname: itemname, state: false))
        }
        promitionalitem.reloadData()
    }
    
    func setproductspinnr()
    {
        productspinr.optionArray.removeAll()
        productspinr.optionIds?.removeAll()
        itemidarr.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select distinct itemgroupid,substr(itemid,1,3) || ' - ' || itemname as itemname from ItemMaster where isblocked='false' and itembuyergroupid in (select itemgrpid as itembuyergroupid from USERDISTRIBUTORITEMLINK where siteid = '\(siteid!)' and itemsubgroup not in ('PRINTING & STATIONERY','BUSINESS PROMOTION') ) "
        
        print ("setproductspinnr==" + query)
        
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

//            productspinr.optionIds?.append(itemid)
            itemidarr.append(String(cString: sqlite3_column_text(stmt1, 0)))
        }
    }
    
    
    func setdealerspinr()
    {
        dealerspinr.optionArray.removeAll()
        dealerspinr.optionIds?.removeAll()
        sitearr.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select '0' as siteid,'Select' as sitename union select distinct siteid,sitename  from USERDISTRIBUTOR"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let sitename = String(cString: sqlite3_column_text(stmt1, 1))
            let siteid = String(cString: sqlite3_column_text(stmt1, 0))
            sitearr.append(String(cString: sqlite3_column_text(stmt1, 0)))
            dealerspinr.optionArray.append(sitename)
            dealerspinr.optionIds?.append(Int(siteid) ?? 0)

        //    dealerspinr.optionIds?.append(siteid)
            
            if String(cString: sqlite3_column_text(stmt1, 0)) == self.siteid
            {
                dealerspinr.text = String(cString: sqlite3_column_text(stmt1, 1))
            }
        }
    }
    
    func setItemTable()
    {
        orderitemadapter.removeAll()
        var stmt1:OpaquePointer?
        
        let query = "select distinct 1 as _id , A.itemid,A.itemvarriantsize,A.itemname,ifnull(C.QTY,'') as qty,B.price,A.itemgroupid,C.LineAmount from ItemMaster A  inner join UserPriceList B  on A.itemid = B.itemid  left outer join SOLINE C on A.itemid = C.ITEMID  and  C.SONO='\(CustomerCard.orderid!)' where itemgroupid = '\(self.itemid!)' and  B.pricegroupid= '\(Retailerlistvc.pricegroup!)' and B.price > 0 and isblocked = 'false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        var i: Int! = 0
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let itemvarriantsize = String(cString: sqlite3_column_text(stmt1, 2))
            let qty = String(cString: sqlite3_column_text(stmt1, 4))
            let price = String(cString: sqlite3_column_text(stmt1, 5))
            let iid = String(cString: sqlite3_column_text(stmt1, 1))
            orderitemadapter.append(OrderItemAdapter(size: itemvarriantsize, qty: qty,price: price,itemid: iid,sono: ordrid,siteid: siteid,custstate: stateid,customercode: customercode,index: i))
            i = i + 1
        }
        itemlist.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let list: OrderItemAdapter
        list = orderitemadapter[textField.tag]
        let qtyStr = (textField.text! as NSString)
        var qtyInt: Int
        let result: Int32
        if qtyStr == ""
        {
            qtyInt = 0
        }
        else{
            qtyInt = (textField.text! as NSString).integerValue
        }
        list.qty = "\(qtyInt)"
        result = self.insertSoLine(siteid: siteid, sono: CustomerCard.orderid!, customercode: customercode, itemid: list.itemid, qtyInt: qtyInt, price: list.price,discperc: "0", custstate: stateid)
        
        if result < 0
        {
            textField.text = ""
            showtoast(controller: self, message: "Tax Setup is not Available" , seconds: 2.0)
        }
        if let nextResponder = textField.superview?.superview?.superview?.superview?.viewWithTag(nextTag) as? UITextField
        {
            nextResponder.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        setdetail()
        return true
    }
//    MARK:- QTY - next button press
    
    func donext(textfield : UITextField) {
        let nextTag = textfield.tag + 1
        let list: OrderItemAdapter
        list = orderitemadapter[textfield.tag]
        let qtyStr = (textfield.text! as NSString)
        var qtyInt: Int
        let result: Int32
        if qtyStr == ""
        {
            qtyInt = 0
        }
        else{
            qtyInt = (textfield.text! as NSString).integerValue
        }
        list.qty = "\(qtyInt)"
        result = self.insertSoLine(siteid: siteid, sono: CustomerCard.orderid!, customercode: customercode, itemid: list.itemid, qtyInt: qtyInt, price: list.price,discperc: "0", custstate: stateid)
        
        if result < 0
        {
            textfield.text = ""
            showtoast(controller: self, message: "Tax Setup is not Available" , seconds: 2.0)
        }
        if let nextResponder = textfield.superview?.superview?.superview?.superview?.viewWithTag(nextTag) as? UITextField
        {
            nextResponder.becomeFirstResponder()
        }
        else
        {
            textfield.resignFirstResponder()
        }
        setdetail()
    }
    
    @IBAction func homebn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


