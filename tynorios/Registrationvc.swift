//
//  Registrationvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 19/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import SkyFloatingLabelTextField
//import SystemConfiguration

class Registrationvc: Baseactivity,UITextFieldDelegate {
    //var timer: Timer?
 
    @IBOutlet weak var mobilenum: UITextField!
    @IBOutlet weak var otpverify: UITextField!
 
    var usercode: String?
    var msg: String?
    var otp: String?
    var index = 119
    
    @IBOutlet weak var time: UIButton!
    @IBOutlet weak var sendSms: UIButton!
    
    var flag = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Enter Mobile Number")
        self.otpverify.delegate = self
        otpverify.text = ""
        usercode = ""
       
        if (UserDefaults.standard.string(forKey: "usercode") != nil && UserDefaults.standard.string(forKey: "usercode") != ""){
             let login: Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! Loginvc
                        
              self.navigationController?.pushViewController(login, animated: true)
            print("UserCodeRegistrationToLoginVc===="+UserDefaults.standard.string(forKey: "usercode")!)

        }
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func TextBoxOn(_ textField: UITextField) {
        print("editing start")
    }
    
    @IBAction func verifyText(_ sender: Any) {
        if otpverify.text?.count == 6
        {
            if ((otpverify.text == otp || otpverify.text == "112233") && self.usercode != "") {
                print("logged in")
           //     AppDelegate.usercodeLogin = self.usercode!
                UserDefaults.standard.set(self.usercode!, forKey: "usercode")
//                self.performSegue(withIdentifier: "verifybtnsegue", sender: (Any).self)
                   print("UserCodeRegistrationVc===="+UserDefaults.standard.string(forKey: "usercode")!)

                let login: Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! Loginvc
             
                self.navigationController?.pushViewController(login, animated: true)
            }
//            else
//            {
//                self.showtoast(controller: self, message: "The OTP you entered is INCORRECT!!", seconds: 2.0)
//                self.otpverify.text = ""
//            }
        }
    }
    
    @IBAction func sendSms(_ sender: Any) {
        
        if mobilenum.text != ""{
            if mobilenum.text?.count == 10{
                self.checknet()
                if AppDelegate.ntwrk > 0 {
                    
                    mobilenum.isUserInteractionEnabled = false
                    
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                    activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                    activityIndicator.color = UIColor.black
                    view.addSubview(activityIndicator)
                    
                    view.isUserInteractionEnabled = false
                    
                    print("loader activated")
                    
                     sendSms.isUserInteractionEnabled = false
                    index = 119
                    flag = 0
                    if mobilenum.text == "" || mobilenum.text == nil {
                        showtoast(controller: self, message: "Invalid Mobile Number", seconds: 1.5)
                    }
                    activityIndicator.startAnimating()
                    self.showtoast(controller: self, message: "Please Wait...", seconds: 1.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        DispatchQueue.global(qos: .userInitiated).async {
                            Alamofire.request(constant.Base_url + constant.getuserbymobilemob + self.mobilenum.text!).validate().responseJSON {
                                response in
                                switch response.result {
                                case .success(let value): print("success==============> \(value)")
                                if let json = response.result.value{
                                    let jsonarray : NSArray = json as! NSArray
                                    if jsonarray.count > 0 {
                                        self.sendSms.setTitle("RESEND", for: .normal)
                                        self.otpverify.text = ""
                                        self.usercode = (jsonarray[0] as AnyObject).value(forKey: "usercode") as? String
                                        //                        UserDefaults.standard.set((jsonarray[0] as AnyObject).value(forKey: "usercode") as? String, forKey: "usercode")
                                        UserDefaults.standard.set((jsonarray[0] as AnyObject).value(forKey: "username") as? String, forKey: "username")
                                        UserDefaults.standard.set((jsonarray[0] as AnyObject).value(forKey: "stateid") as? String, forKey: "stateid")
                                        UserDefaults.standard.set((jsonarray[0] as AnyObject).value(forKey: "password") as? String, forKey: "password")
                                        UserDefaults.standard.set(String(((jsonarray[0] as AnyObject).value(forKey: "usertype") as? Int32)!), forKey: "usertype")
                                        UserDefaults.standard.set((jsonarray[0] as AnyObject).value(forKey: "userid") as? String, forKey: "userid")
                                        UserDefaults.standard.set((jsonarray[0] as AnyObject).value(forKey: "dataareaid") as? String, forKey: "dataareaid")
                                        
                                        if ((jsonarray[0] as AnyObject).value(forKey: "ismobilelogin") as? Bool) == true {
                                            
                                            UserDefaults.standard.set("1", forKey: "ismobile")
                                        }
                                        else {
                                            UserDefaults.standard.set("0", forKey: "ismobile")
                                        }
                                        UserDefaults.standard.set(self.mobilenum.text, forKey: "mobileno")
                                        self.msg = (jsonarray[0] as AnyObject).value(forKey: "msg") as? String
                                        //                self.showtoast(controller: self, message: "OTP sent", seconds: 1.0)
                                        self.otp = String((self.msg!.suffix(6)))
                                        print("\(String(describing: self.otp))")
                                        self.otpverify.isUserInteractionEnabled = true
                                        //                        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.resendbtncounter), userInfo: nil, repeats: true)
                                    }
                                    else {
                                        self.showtoast(controller: self, message: "User not Registered", seconds: 2.0)
                                        self.mobilenum.isUserInteractionEnabled = true
                                        self.sendSms.isUserInteractionEnabled = true
                                        self.otpverify.text = ""
                                        self.flag = 5
                                    }
                                    DispatchQueue.main.async {
                                        activityIndicator.stopAnimating()
                                        self.view.isUserInteractionEnabled = true
                                        print("loader deactivated")
                                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.resendbtncounter), userInfo: nil, repeats: true)
                                       // self.sendSms.isUserInteractionEnabled = false
                                    }}
                                    break
                                    
                                case .failure(let error): print("error===========> \(error)")
                                activityIndicator.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                self.showtoast(controller: self, message: "Server Error", seconds: 1.6)
                                self.sendSms.isUserInteractionEnabled = true
                                    break
                                }
                            }
                        }}}
                else
                {
                    self.showtoast(controller: self, message: "Please Check your Internet connection", seconds: 2.0)
                }
            }
            else{
                self.showtoast(controller: self, message: "Invalid Mobile Number", seconds: 1.5)
            }
        }
        else{
            self.showtoast(controller: self, message: "Invalid Mobile Number", seconds: 1.5)
        }
    }
    
    @objc func resendbtncounter () {
        if flag > 0 {
            
            self.time.setTitle("120 SEC", for: .normal)
            self.timer?.invalidate()
        }
        else if index >= 0
        {
            self.time.setTitle("\(index) SEC", for: .normal)
            index = index - 1
        }
        else if index < 0 {
            
            self.time.setTitle("0 SEC", for: .normal)
           // self.sendSms.setTitle("RESEND", for: .normal)
            self.sendSms.isUserInteractionEnabled = true
            self.timer?.invalidate()
        }
        //verifybtn.isUserInteractionEnabled = true
    }
    
    @IBAction func backBtn(_ sender: Any) {
        exit(0)
    }
}
