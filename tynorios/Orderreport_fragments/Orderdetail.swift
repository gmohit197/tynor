//
//  Orderdetail.swift
//  tynorios
//
//  Created by Acxiom Consulting on 29/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class Orderdetail: Executeapi, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ordercelladapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Orderdetailcell
        
        let list: Ordercelladapter
        list = ordercelladapter[indexPath.row]
        
        cell.productname.text = list.productname
        cell.size.text = list.size
        cell.qty.text = list.qty
        cell.amount.text = list.amount
        
        return cell
    }
    
    @IBOutlet weak var orderdetailtable: UITableView!
    
     var siteid: String!
     var sono: String!
     var id: String!
    
    var ordercelladapter = [Ordercelladapter]()
    
    @IBOutlet weak var orderno: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Order Detail")
        self.orderno.text = sono
        
        self.orderdetailtable.tableFooterView = UIView()
        if id ==  "primary"{
            primarylist()
        }
        else{
            secondarylist()
        }
        orderdetailtable.delegate = self
        orderdetailtable.dataSource = self
    }
    
    @IBAction func backbtn(_ sender: Any) {
        if id == "primary"{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            dismiss(animated: true, completion: nil)
        }
    }

    func primarylist()
    {
        var stmt1:OpaquePointer?
        
        let query = "select 1 _id,itemname,itemvarriantsize,quantity,amount from IndentDetails where indentno='\(sono!)' and siteid ='\(siteid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let productname = String(cString: sqlite3_column_text(stmt1, 1))
            let size = String(cString: sqlite3_column_text(stmt1, 2))
            let qty = String(cString: sqlite3_column_text(stmt1, 3))
            let amount = String(cString: sqlite3_column_text(stmt1, 4))
           
            self.ordercelladapter.append(Ordercelladapter(productname: productname, size: size, qty: qty, amount: amount))
            
        }
        self.orderdetailtable.reloadData()
        
        self.view.isUserInteractionEnabled = true
        print("got data")
    }
    
    func secondarylist()
    {
        var stmt1:OpaquePointer?

        let query = "select 1 _id,A.itemname,B.amount,A.itemvarriantsize,round(B.lineno,0) as lineno from sodetails B left join ItemMaster A  on A.ITEMID = B.ITEMID WHERE B.sono='\(sono!)' and B.siteid='\(siteid!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let productname = String(cString: sqlite3_column_text(stmt1, 1))
            let size = String(cString: sqlite3_column_text(stmt1, 3))
            let qty = String(sqlite3_column_int64(stmt1, 4))
            let amount = String(cString: sqlite3_column_text(stmt1, 2))
            self.ordercelladapter.append(Ordercelladapter(productname: productname, size: size, qty: qty, amount: amount))
            
        }
        self.orderdetailtable.reloadData()
        self.view.isUserInteractionEnabled = true
        print("got data")
    }
    
    @IBAction func homebtn(_ sender: Any) {
      //  dismiss(animated: true, completion: nil)
          self.getToHome(controller: self)
    }
}
