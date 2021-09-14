//
//  PrimaryOrderItem.swift
//  tynorios
//
//  Created by Acxiom Consulting on 12/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//  

import UIKit

protocol QTY1{
    func nextbtn(at index: IndexPath, textfield: UITextField)
}

class PrimaryOrderItem: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var shipperqty: UILabel!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var price: UILabel!
    
    var itemid: String?
    var ispcsapply: String?
    var siteid: String?
    var orderid: String?
    var itemgroupid: String?
    var plantstateid: String?
    var stateid: String?
    var toolbar = UIToolbar()
    var doneButton = UIBarButtonItem()
    var controller: UIViewController?
     var delegate: QTY1!
     var index: IndexPath!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextClicked));
            toolbar.sizeToFit()
            toolbar.setItems([doneButton,spacetButton,nextButton], animated: false)
            qty.inputAccessoryView = toolbar
      //  qty.delegate = self
    }
    
    @objc func doneClicked()
    {
        qty.resignFirstResponder()
    }
    
    @objc func nextClicked()
     {
         self.delegate.nextbtn(at: index, textfield: qty)
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   
   
    @IBAction func qtychange(_ sender: Any) {
        let base = Baseactivity()

        let qtyStr = (qty.text! as NSString)
        var qtyInt: Int
        let _: Int32
        if qtyStr == ""
        {
           qtyInt = 0
        }
        else{
            qtyInt = (qty.text! as NSString).integerValue
        }
        let shipperInt: Int = (self.shipperqty.text! as NSString).integerValue
        let ispcsapply: String = self.ispcsapply!
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
                let db: Databaseconnection = Databaseconnection()
                let i:Int  = db.insertindentline(siteid: self.siteid, indentid: self.orderid, itemid: self.itemid, itemgroupid: self.itemgroupid, packsize: self.shipperqty.text, shipper: "0", qty: qtyInt, price: price.text, plantstateid: self.plantstateid, stateid: self.stateid)
                NotificationCenter.default.post(name: Notification.Name(rawValue: constant.key), object: controller)

                if(i == 0){
                    self.qty.text = ""
                    base.showtoast(controller: self.controller!, message: "Tax setup not available", seconds: 1.5)
                }
            }
            else{
                self.qty.text = ""
                base.showtoast(controller: self.controller!, message: "Quantity must be in shipper", seconds: 1.5)
            }
        }
        
    }

