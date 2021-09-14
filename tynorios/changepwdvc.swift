//
//  changepwdvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 24/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import  Alamofire
import SkyFloatingLabelTextField

class changepwdvc: Executeapi {

    @IBOutlet weak var cnfpwd: SkyFloatingLabelTextField!
    @IBOutlet weak var newpwd: SkyFloatingLabelTextField!
    var toolbar = UIToolbar()
    var controller: UIViewController?
    
    var doneButton = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Update Password")
        self.hideKeyboardWhenTappedAround()
//       navigationItem.hidesBackButton = true
//       navigationController?.navigationBar.isUserInteractionEnabled = true
        doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: false)
        cnfpwd.inputAccessoryView = toolbar
        newpwd.inputAccessoryView = toolbar
    }
    @objc func doneClicked()
    {
        cnfpwd.resignFirstResponder()
        newpwd.resignFirstResponder()
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
        
        if newpwd.text == cnfpwd.text  {
             self.cnfpwd.errorMessage = ""
            if (self.cnfpwd.text?.count)! >= 6{
                if newpwd.text != UserDefaults.standard.string(forKey: "password") {
                    let parameters: [String: AnyObject] = [
                        "USERID" : UserDefaults.standard.string(forKey: "usercode") as AnyObject,
                        "OLDPASSWORD" : UserDefaults.standard.string(forKey: "password") as AnyObject,
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
                            
                            //stat = response.result.description as NSString
                            //print("status =========>>>>>\(String(describing: stat!))")
                            switch response.result {
                            case .success(let value) : print("success ========> \(value)")
                            UserDefaults.standard.removeObject(forKey: "password")
                            UserDefaults.standard.set(self.cnfpwd.text!, forKey: "password")
                            self.showtoast(controller: self, message: "Password changed successfully...", seconds: 1.6)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
//                                self.performSegue(withIdentifier: "resetpwdsegue", sender: (Any).self)
                                let login: Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! Loginvc
                                self.navigationController?.pushViewController(login, animated: true)
                            }
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        
                        self.performSegue(withIdentifier: "resetpwdsegue", sender: (Any).self)
                    }
                }
            }
            else {
                self.showtoast(controller: self, message: "Password should be of min. 6 characters", seconds: 2.0)
            }
        }
        else {
            self.showtoast(controller: self, message: "Passwords do not match..", seconds: 1.5)
            }
    }
    @IBAction func backbtn(_ sender: Any) {
        
        let login: Loginvc = self.storyboard?.instantiateViewController(withIdentifier: "login") as! Loginvc
        self.navigationController?.pushViewController(login, animated: true)
    }
  
}
