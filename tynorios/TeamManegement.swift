//
//  TeamManegement.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class TeamManegement: Executeapi {
    
    @IBOutlet weak var pendingsubdealer: CardView!
    @IBOutlet weak var pendingescation: CardView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setnav(controller: self, title: "Team Management")
        AppDelegate.customerTypePE = ""
        AppDelegate.spinnetextPE = ""
        pendingsubdealer.isUserInteractionEnabled = true
        let tapsubdealer = UITapGestureRecognizer(target: self, action: #selector(clicksubdealer))
        tapsubdealer.numberOfTapsRequired = 1
        pendingsubdealer.addGestureRecognizer(tapsubdealer)

        pendingescation.isUserInteractionEnabled = true
        let tapescalation = UITapGestureRecognizer(target: self, action: #selector(clickescalation))
        tapescalation.numberOfTapsRequired = 1
        pendingescation.addGestureRecognizer(tapescalation)
        
    }
    
    @objc func clicksubdealer()
    {
        let subdealer: PendingSubdealervc = self.storyboard?.instantiateViewController(withIdentifier: "pendingsubdealer") as! PendingSubdealervc 
        self.navigationController?.pushViewController(subdealer, animated: true)
    }
    
    
    
    @objc func clickescalation()
    {
        let escalation: PendingEscalation = self.storyboard?.instantiateViewController(withIdentifier: "pendingescalation") as! PendingEscalation
          self.navigationController?.pushViewController(escalation, animated: true)
    }
    
    
//    @objc func clickescalation()
//    {
//        self.checknet()
//        if AppDelegate.ntwrk > 0 {
//            self.view.isUserInteractionEnabled = false
//
//            print("sending request")
//            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
//            activityIndicator.color = UIColor.black
//            view.addSubview(activityIndicator)
//            activityIndicator.startAnimating()
//            print("loader activated")
//
//           DispatchQueue.main.async {
//                Alamofire.request(constant.Base_url + constant.URL_getpendingescalation).validate().responseJSON {
//                    response in
//                    switch response.result {
//                    case .success(let value): print("success==========> \(value)")
//                    self.deleteescalationreport()
//                    if  let json = response.result.value{
//                        let listarray : NSArray = json as! NSArray
//                        if listarray.count > 0 {
//                            for i in 0..<listarray.count{
//                               let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
//                                let escalationid = String (((listarray[i] as AnyObject).value(forKey:"escalationid") as? String)!)
//                                let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as? String)!)
//                                let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
//                                let siteid = String(((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
//                                let submittime = String (((listarray[i] as AnyObject).value(forKey:"submittime") as? String)!)
//                                let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Int)!)
//                                let createdby = String (((listarray[i] as AnyObject).value(forKey:"createdby") as? String)!)
////                                let username = String (((listarray[i] as AnyObject).value(forKey:"username") as? String)!)
////                                let closeremarks = String (((listarray[i] as AnyObject).value(forKey:"closeremarks") as? String)!)
//
//                                self.insertescalationreport(dataareaid: dataareaid as NSString, escalationid: escalationid as NSString, customercode: customercode as NSString, siteid: siteid as NSString, submittime: submittime as NSString, createdby: createdby as NSString, status: status as NSString, remark: "", reasoncode: reasoncode as NSString, username: "", closeremarks: "", post: "2", latitude: "", longitude: "")
//                            }
//                        }
//                        else {
//                            let escalation: PendingEscalation = self.storyboard?.instantiateViewController(withIdentifier: "pendingescalation") as! PendingEscalation
//                            self.navigationController?.pushViewController(escalation, animated: true)
//                            self.showtoast(controller: self, message: "No Escalations", seconds: 2.0)
//                        }
//                    }
//                    break
//
//                    case .failure(let error): print("error============> \(error)")
//                        break
//
//                    }
//                            activityIndicator.stopAnimating()
//                            self.view.isUserInteractionEnabled = true
//                            print("loader deactivated")
//                    let escalation: PendingEscalation = self.storyboard?.instantiateViewController(withIdentifier: "pendingescalation") as! PendingEscalation
//                    self.navigationController?.pushViewController(escalation, animated: true)
//                }
//            }}
//        else {
//            self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
//        }
//
//    }
    
    @IBAction func backbtn(_ sender: Any) {
        
        let dailyres: DailyResponsibility = self.storyboard?.instantiateViewController(withIdentifier: "dailyres") as! DailyResponsibility
        self.navigationController?.pushViewController(dailyres, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
}
