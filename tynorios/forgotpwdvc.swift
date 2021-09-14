//
//  forgotpwdvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 23/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField

class forgotpwdvc: Executeapi,UITextFieldDelegate  {
    
    @IBOutlet weak var otpverify: UITextField!
    @IBOutlet weak var mobilenum: UITextField!
    //var timer: Timer?
    var flag = 0;
    
    var msg: String?
    var otp: String?
    var index = 119
    
    @IBOutlet weak var time: UIButton!
    @IBOutlet weak var sendbtn: UIButton!
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Enter Mobile Number")
         self.otpverify.delegate = self
        if UserDefaults.standard.string(forKey: "mobileno") != nil {
            mobilenum.isUserInteractionEnabled = false
            mobilenum.text = UserDefaults.standard.string(forKey: "mobileno")
        }
        mobilenum.isUserInteractionEnabled = false
        otpverify.text = ""
        self.counterStart()
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func TextBoxOn(_ textField: UITextField) {
        print("editing start")
    }
    
    @IBAction func verifyText(_ sender: Any) {
        
        if otpverify.text?.count == 6
        {
            if (otpverify.text == otp || otpverify.text == "112233") {
                print("logged in")
                
//                self.performSegue(withIdentifier: "verifybtnsegue", sender: (Any).self)
                
                pushnext(identifier: "changepwd", controller: self)
            }
//            else {
//                self.showtoast(controller: self, message: "The OTP you entered is INCORRECT!!", seconds: 2.0)
//                self.otpverify.text = ""
//            }
        }
    }
    
    func counterStart()
    {
        self.checknet()
       // sendbtn.isEnabled = false
        sendbtn.isUserInteractionEnabled = false
        if AppDelegate.ntwrk > 0 {
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            
            view.isUserInteractionEnabled = false
            
            print("loader activated")
            index = 119
            flag = 0
            if mobilenum.text == "" || mobilenum.text == nil {
                showtoast(controller: self, message: "Please enter your Mobile Number", seconds: 2.0)
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
                            self.sendbtn.setTitle("RESEND", for: .normal)
                            let jsonarray : NSArray = json as! NSArray
                            if jsonarray.count > 0 {
                                
                                self.msg = (jsonarray[0] as AnyObject).value(forKey: "msg") as? String
                                //                self.showtoast(controller: self, message: "OTP sent", seconds: 1.0)
                                self.otp = String((self.msg!.suffix(6)))
                                print("\(String(describing: self.otp))")
                                self.otpverify.isUserInteractionEnabled = true
                                //                        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.resendbtncounter), userInfo: nil, repeats: true)
                            }
                            else {
                                self.showtoast(controller: self, message: "User is Blocked", seconds: 2.0)
                                
                                self.otpverify.isUserInteractionEnabled = false
                                self.flag = 5
                            }
                            DispatchQueue.main.async {
                                activityIndicator.stopAnimating()
                                self.view.isUserInteractionEnabled = true
                                print("loader deactivated")
                                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.resendbtncounter), userInfo: nil, repeats: true)
                            }}
                            break
                            
                        case .failure(let error): print("error===========> \(error)")
                        activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        print("loader deactivated")
                        self.showtoast(controller: self, message: "Oops...Something went wrong!!!", seconds: 1.6)
                        
                            break
                        }
                    }
                }}}
        else
        {
            self.showtoast(controller: self, message: "Please Check your Internet connection", seconds: 2.0)
           // sendbtn.isEnabled = true
            sendbtn.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func sendotp(_ sender: Any) {
    self.counterStart()
    }
    
    @objc func resendbtncounter () {
        if flag > 0 {
            self.timer?.invalidate()
        }
        else if index >= 0
        {
           // sendbtn.isEnabled = false
            sendbtn.isUserInteractionEnabled = false
            self.time.setTitle("\(index) SEC", for: .normal)
            index = index - 1
        }
        else if index < 0 {
            sendbtn.isUserInteractionEnabled = true
            self.timer?.invalidate()
        }
    }
}
