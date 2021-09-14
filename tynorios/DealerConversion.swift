//
//  DealerConversion.swift
//  tynorios
//
//  Created by Acxiom Consulting on 01/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SQLite3


class DealerConversion: Postapi{
    
    var custcode: String!
    var siteid: String!
    var custname: String?
    var titletext: String?
    
    @IBOutlet weak var customercode: UILabel!
    @IBOutlet weak var customername: UILabel!
    @IBOutlet weak var address: UILabel!
    
    
    @IBOutlet weak var monthalysale: SkyFloatingLabelTextField!
    @IBOutlet weak var discount: SkyFloatingLabelTextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Sub Dealer Conversion")
        monthalysale.text = ""
        discount.text = ""
        
        self.customercode.text = custcode
        setData()
        
    }
    func setData(){
        var stmt1: OpaquePointer?
        let query = "select address,customername from retailermaster where customercode = '\(custcode!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            custname = String(cString: sqlite3_column_text(stmt1, 1))
            self.address.text = String(cString: sqlite3_column_text(stmt1,0))
            self.customername.text = custname
        }
    }
    
    func showalertmsg(){
        let alert = UIAlertController(title: "Are You Sure to convert the store into the Sub Dealer", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                self.insertsubdealers(customercode: self.custcode! as NSString , expectedsale: self.monthalysale.text! as NSString, expectedDiscount: self.discount.text! as NSString, dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, recid: "0", submitdate: self.getTodaydatetime() as NSString, status: "0", approvedby: "", siteid: self.siteid as NSString, createdtransactionid: "", modifiedtransactionid: "", post: "0")
                
                self.posthospitalMaster()
            }
            else {
                
                self.insertsubdealers(customercode: self.custcode! as NSString , expectedsale: self.monthalysale.text! as NSString, expectedDiscount: self.discount.text! as NSString, dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, recid: "0", submitdate: self.getTodaydatetime() as NSString, status: "0", approvedby: "", siteid: self.siteid as NSString, createdtransactionid: "", modifiedtransactionid: "", post: "0")
            }
            
            self.updatependingsubconv(customercode: self.custcode! as String)
            
            let customercard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            customercard.customername = self.custname
            customercard.customercode = self.custcode
            customercard.titletxt = self.titletext
            self.navigationController?.pushViewController(customercard, animated: true)
            self.showtoast(controller: self, message: "Sub Dealer Conversion Requested", seconds: 1.5)
            
            UIView.animate(withDuration: 0.3, animations: { ()->Void in
                self.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (finished) in
                self.view.removeFromSuperview()
                AppDelegate.menubool = true
            }
        }))
        present(alert, animated: true)
    }
    
    
    @IBAction func submitbtn(_ sender: Any) {
        
        if (monthalysale.text! != "")
        {
            if(discount.text! != "")
            {
                self.showalertmsg()
                
            } else{
                self.showtoast(controller: self, message: "Please Enter Discount", seconds: 1.5)
            }
        }
        else
        {
            self.showtoast(controller: self, message: "Please Enter Expected Sale", seconds: 1.5)
        }
    }
    
    @IBAction func cancelbtn(_ sender: Any) {
      //  dismiss(animated: true, completion: nil)
        
        let customercard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard

        customercard.customername = self.custname
        customercard.customercode = self.custcode
        customercard.titletxt = self.titletext
        self.navigationController?.pushViewController(customercard, animated: true)
        
       // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backbtn(_ sender: Any) {
   //    dismiss(animated: true, completion: nil)
        
        let customercard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
        customercard.customername = self.custname
        customercard.customercode = self.custcode
        customercard.titletxt = self.titletext
        self.navigationController?.pushViewController(customercard, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}
