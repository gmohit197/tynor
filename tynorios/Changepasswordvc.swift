//
//  Changepasswordvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire

class Changepasswordvc: Executeapi, UITextFieldDelegate {

    @IBOutlet weak var oldpwd: SkyFloatingLabelTextField!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var cnfpwd: SkyFloatingLabelTextField!
    
   
    var pass = UserDefaults.standard.string(forKey: "password")
    @IBOutlet weak var newpwd: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Change Password")
        
//        self.oldpwd.becomeFirstResponder()
//        self.oldpwd.selectAll(nil)
//
//        self.cnfpwd.becomeFirstResponder()
//        self.cnfpwd.selectAll(nil)
        
        cnfpwd.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        cnfpwd.text = ""
    
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(cleartextoldpwd))
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.oldpwd.addGestureRecognizer(tapeno)
        
        let tapeno1 = UITapGestureRecognizer(target: self, action: #selector(cleartextcnfpwd))
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.cnfpwd.addGestureRecognizer(tapeno1)
        
        let tapeno2 = UITapGestureRecognizer(target: self, action: #selector(cleartextnewpwd))
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.newpwd.addGestureRecognizer(tapeno2)
       
        func textFieldDidBeginEditing(textField: UITextField) {
             self.oldpwd.text?.removeAll()
             self.cnfpwd.text?.removeAll()
        }
    }
    @objc func cleartextoldpwd(){
        self.oldpwd.text?.removeAll()
        self.oldpwd.becomeFirstResponder()
     
    }
    @objc func cleartextcnfpwd(){
           self.cnfpwd.text?.removeAll()
           self.cnfpwd.becomeFirstResponder()
         
       }
    @objc func cleartextnewpwd(){
           self.newpwd.text?.removeAll()
           self.newpwd.becomeFirstResponder()
         
       }
  
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func cnfpwd(_ sender: SkyFloatingLabelTextField) {
        if newpwd.text! != cnfpwd.text! {
             self.cnfpwd.errorMessage = "Passwords do not match"
        }
        else {
            self.cnfpwd.errorMessage = ""
        }
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        
        if validate(){
            if oldpwd.text == UserDefaults.standard.string(forKey: "password")
            {
                if oldpwd.text != newpwd.text
                {
                    self.oldpwd.errorMessage = ""
                    if newpwd.text == cnfpwd.text  {
                        if (cnfpwd.text?.count)! >= 6 {
                            self.cnfpwd.errorMessage = ""
                            if (newpwd.text != UserDefaults.standard.string(forKey: "password") && cnfpwd.text != oldpwd.text) {
                                let parameters: [String: AnyObject] = [
                                    "USERID" : UserDefaults.standard.string(forKey: "usercode") as AnyObject,
                                    "OLDPASSWORD" : self.oldpwd.text! as AnyObject,
                                    "NEWPASSWORD": self.newpwd.text! as AnyObject,
                                    "RECONFIRMPASS" : self.cnfpwd.text! as AnyObject
                                ]
                                self.checknet()
                                if AppDelegate.ntwrk > 0 {
                                    Alamofire.request(constant.Base_url + constant.postresetpwd, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                        .validate()
                                        .responseJSON { response in
                                            print("Response =========>>>>\(response.response as Any)")
                                            print("Error ============>>>>\(response.error as Any)")
                                            print("Data =============>>>>\(response.data as Any)")
                                            print("Result =========>>>>>\(response.result)")
                                            switch response.result {
                                            case .success(let value) : print("success ========> \(value)")
                                            self.getToHome(controller: self)
                                            self.showtoast(controller: self, message: "Password changed successfully...", seconds: 1.6)
                                            UserDefaults.standard.removeObject(forKey: "password")
                                            UserDefaults.standard.set(self.cnfpwd.text!, forKey: "password")
                                                break
                                                
                                            case .failure(let error): print("post error ========> \(error)")
                                            self.showtoast(controller: self, message: "Upload Status: ERROR", seconds: 2.0)
                                                break
                                            }  }  }
                                else {
                                    self.showtoast(controller: self, message: "Please check your Internet connection", seconds: 2.0)
                                }
                            }
                            else {
                                self.showtoast(controller: self, message: "Password didn't changed..", seconds: 1.6)
                            }
                        }
                        else {
                            self.showtoast(controller: self, message: "Password should be of min. 6 characters", seconds: 2.0)
                        }
                    }
                    else {
                        self.showtoast(controller: self, message: "Passwords do not match..", seconds: 1.5)
                        self.cnfpwd.errorMessage = "Passwords didn't matched"
                    }
                }
                else{
                    self.showtoast(controller: self, message: "Old and New password cannot be same", seconds: 1.5)
                }
            }
            else {
                self.oldpwd.errorMessage = "Invalid Password"
                self.showtoast(controller: self, message: "Incorrect Old Password", seconds: 1.5)
            }
        }
    }
    
    func validate() -> Bool {
        var validate = true
        if self.oldpwd.text == ""{
            self.showtoast(controller: self, message: "Please Enter The Old Password", seconds: 1.5)
            validate = false
        }
        
        else if self.newpwd.text == ""{
            self.showtoast(controller: self, message: "Please Enter New Password", seconds: 1.5)
            validate = false
        }
        
        else if self.cnfpwd.text == ""{
            self.showtoast(controller: self, message: "Please Enter Confirm Password", seconds: 1.5)
            validate = false
        }
        return validate
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}

