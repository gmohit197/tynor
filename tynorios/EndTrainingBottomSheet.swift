//
//  EndTrainingBottomSheet.swift
//  tynorios
//
//  Created by Acxiom Consulting on 24/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SwiftEventBus

class EndTrainingBottomSheet: UIViewController, UITextViewDelegate {

    @IBOutlet weak var datelbl: UILabel!
    public var portraitSize: CGSize = .zero
    @IBOutlet weak var secondpreview: UIView!
    @IBOutlet weak var remarklbl: UITextView!
    let base = Baseactivity()
    var toolbar = UIToolbar()
    var usercode: String?
    var trainingid: String?
    var trainingdate: String?
    
    
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var endTraining: UILabel!
    @IBOutlet weak var counter: UILabel!
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = textView.text
        
        var numberOfChars:Int?
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 && newText!.count==0 {
                return true
            }
            if isBackSpace == -92{
                numberOfChars = newText!.count-1
            }
            else{
                numberOfChars = newText!.count + 1
            }
        }
        //        guard range.location == 0 else {
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            //                    SwiftEventBus.post("getcount")
            if numberOfChars! > 250 && isBackSpace == -92{
                //                    return true
            }
            else if numberOfChars! <= 250 {
                self.counter.text = String(250 - numberOfChars!) + "/250"
            }
            else {
                let base = Baseactivity()
                base.showtoast(controller: self, message: "Maximum Limit Reached", seconds: 1.0)
            }
        }
        //            return true
        //        }
        
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
     var doneButton = UIBarButtonItem()
    @objc func doneClicked()
    {
        remarklbl.resignFirstResponder()
    }
    
    enum InitialState {
        case contracted
        case expanded
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondpreview.layer.shadowColor = UIColor.black.cgColor
        secondpreview.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        secondpreview.layer.shadowOpacity = 2.0
        self.datelbl.text = trainingdate
        remarklbl.delegate = self
        if self.usercode == "escalationclosing" {
             endTraining.text = "Approve Order"
        }
        else if (self.usercode == "leaveAttendance"){
            endTraining.text = "Leave Remark"
        }
        else{
             endTraining.text = "End Training"
        }
        
        doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)
        remarklbl.inputAccessoryView = toolbar
        if #available(iOS 11.0, *){
            secondpreview.clipsToBounds = false
            secondpreview.layer.cornerRadius = 15
            secondpreview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = secondpreview.frame
            rectShape.position = secondpreview.center
            rectShape.path = UIBezierPath(roundedRect: secondpreview.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
            secondpreview.layer.backgroundColor = UIColor.green.cgColor
            secondpreview.layer.mask = rectShape
        }
        
        remarklbl.text = "Description..."
        remarklbl.textColor = UIColor.lightGray
        
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: secondpreview.frame.maxY)
        
//        SwiftEventBus.onMainThread(self, name: "getcount")
//        {
//            Result in
//            let newText = self.remarklbl.text
//            let numberOfChars = newText!.count
//            if numberOfChars <= 250{
//                self.counter.text = String(250 - numberOfChars) + "/250"
//            }
//            else{
//                let base = Baseactivity()
//                base.showtoast(controller: self, message: "Maximum Limit Reached", seconds: 1.0)
//            }
//        }

    }
    @IBAction func submitBtn(_ sender: Any) {
     
        if (self.remarklbl.text! == "Description..." || self.remarklbl.text!.isEmpty)
        {
            base.showtoast(controller: self, message: "Please Enter Remark", seconds: 2.0)
        }
        else{
          
           base.checknet()
            let post = Postapi()
            if AppDelegate.ntwrk > 0
            {
                let db = Databaseconnection()
                if self.usercode == "escalationclosing"
                {
                    submitbtn.isEnabled = false
                     base.showtoast(controller: self, message: "Order Generated", seconds: 0.5)
                    AppDelegate.custCardSync = 0
//                    db.approveorder(orderno: CustomerCard.orderid!, approvedate: self.trainingdate!,Remark: "")
                    db.approveorder(orderno: CustomerCard.orderid!, approvedate: self.trainingdate!,Remark: remarklbl.text)
                    db.updatelastvisitid(lastvistactivityid: "1", customercode: AppDelegate.customercode)
                    post.posthospitalMaster()
                    
                }
                
                else if (self.usercode == "leaveAttendance"){
                    //self.lat as NSString,
                    base.showtoast(controller: self, message: "Attendance Submitted Successfully", seconds: 0.5)
                    db.insertattendance(usercode: UserDefaults.standard.string(forKey: "usercode")! as NSString, status: "3", lat: "0.0", lon: "0.0", attendancedate: self.datelbl.text! as NSString, post: "0", usertype: UserDefaults.standard.string(forKey: "usertype")! as NSString, dataareaid: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, isblocked: "false")
                             let post = Postapi()
                             post.postAttendence()
                }
                else
                {
                    db.endTraining(trainingid: trainingid, remark: remarklbl.text, traingendtime: datelbl.text)
                    post.postEndTraining()
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: constant.key), object: self)
            
            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+2.00) {
               
               self.removebottomsheet()
               print("CloseTileremovebottomsheet")
//            }
        //   removebottomsheet()
          
        
//            removePullUpController(self, animated: true)
        }
    }
    
    @objc func clickremark () {
        remarklbl.isEditable = true
    }
    
    @IBAction func cancelbtn(_ sender: UIButton) {
       removebottomsheetSelf()
//        removePullUpController(self, animated: true)
    }
    func removebottomsheet(){
        print("cancel")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
            
        })
        { (finished) in
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            if self.usercode == "escalationclosing"
            {
          //       DispatchQueue.main.asyncAfter(deadline: .now()+2.00) {
                    
                 SwiftEventBus.post("CloseTile")
                 print("CloseTileFired")
                 
            }
        }
        AppDelegate.blureffectview.removeFromSuperview()

    }
    func removebottomsheetSelf(){
        print("cancel")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
            
        })
        { (finished) in
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
        AppDelegate.blureffectview.removeFromSuperview()

    }

    func Intent () {
        let orderlist: OrderListViewController = self.storyboard?.instantiateViewController(withIdentifier: "orderlist") as! OrderListViewController
//        orderlist.customercode = self.customercode
//        orderlist.customername = self.customername
//        orderlist.siteid = self.siteid
//        orderlist.pricegroup = self.pricegroup
//        orderlist.stateid = self.stateid
//        orderlist.titletext = self.titletext
//        self.updatelastvisitid(lastvistactivityid: "1", customercode: customercode)
        self.navigationController?.pushViewController(orderlist, animated: true)
    }
}
