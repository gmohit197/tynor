//  Loginvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 19/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.

import UIKit
import Alamofire
import SwiftEventBus
import SkyFloatingLabelTextField
import CoreLocation


class Loginvc: Executeapi, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    var isblocked: Bool!
    @IBOutlet weak var remember: UIButton!
    @IBOutlet weak var rememberlbl: UILabel!
    @IBOutlet weak var forgot_pwd: UILabel!
    static var flagcount = 0;
    var usertype: String?
     var locationManager:CLLocationManager!
    var base = Baseactivity()
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        password.becomeFirstResponder()
    //    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        determineMyCurrentLocation()
      //  let locationManager = CLLocationManager()
       // locationAccess()
        
        Databaseconnection.createdatabase()
        forgot_pwd.isUserInteractionEnabled = true
        rememberlbl.isUserInteractionEnabled = true
        password.text = ""
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(forgotpwd))
        tap.numberOfTapsRequired = 1
        forgot_pwd.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(rememberaction))
        tap1.numberOfTapsRequired = 1
        rememberlbl.addGestureRecognizer(tap1)
        
        SwiftEventBus.onMainThread(self, name: "logincall") { Result in
            //            self.performSegue(withIdentifier: "loginbtnsegue", sender: (Any).self)
            let dash: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
            
            self.navigationController?.pushViewController(dash, animated: true)
        }
        password.addTarget(self, action: #selector(TextBoxOn(_:)),for: .editingDidBegin)
        
        username.text = UserDefaults.standard.string(forKey: "usercode")
        print("Username====")
        username.isUserInteractionEnabled = false
        remember.setImage(UIImage(named:"unselected"), for: .normal)
        remember.setImage(UIImage(named:"selected"), for: .selected)
        if UserDefaults.standard.bool(forKey: "islogged") {
            if UserDefaults.standard.string(forKey: "isblocked") == "1"
            {
                isblocked = true
            }
            else if UserDefaults.standard.string(forKey: "isblocked") == "0" {
                isblocked = false
            }
        }
        else
        {
            isblocked = false
        }
        print("UserCodeLoginViewDidLoad===="+UserDefaults.standard.string(forKey: "usercode")!)

    }
    
    @objc func forgotpwd(){
        
        pushnext(identifier: "forgotpwd", controller: self)
    }
    
    func determineMyCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
    //    print("user latitude = \(userLocation.coordinate.latitude)")
    //    print("user longitude = \(userLocation.coordinate.longitude)")
      //  lat = String(userLocation.coordinate.latitude)
     //   longi = String(userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @objc func TextBoxOn(_ textField: UITextField) {
        print("editing start")
    }
    
    @IBAction func loginbtn(_ sender: UIButton) {
        if(validate()){
        print("UserCodeLoginBtnClick===="+UserDefaults.standard.string(forKey: "usercode")!)

        self.checknet()
        if (password.text == "") {
            showtoast(controller: self, message: "Please Enter Password", seconds: 1.5)
        }
        else
        {
            if AppDelegate.ntwrk > 0 {
                getuserdetails()
            }
            else if UserDefaults.standard.bool(forKey: "islogged") {
                validateuser()
            }
            else {
                self.showtoast(controller: self, message: "Please Check your Internet connection", seconds: 2.0)
            }
        }
        }
    }
    
    @objc func rememberaction(){
        if self.remember.isSelected == false {
            if  !UserDefaults.standard.bool(forKey: "islogged") {
                animatebtn()
                showtoast(controller: self, message: "Please Login First", seconds: 1.5)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.animatebtn()
                }
            }
            else {
                password.text = UserDefaults.standard.string(forKey: "password")
                animatebtn()
            }
        }
        else {
            animatebtn()
        }
    }
    
    @IBAction func remember(_ sender: UIButton) {
        rememberaction()
    }
    
    func animatebtn(){
        print("animation started")
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            self.remember.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                self.remember.isSelected = !self.remember.isSelected
                self.remember.transform = .identity
            }, completion: nil)
        }
    }
    
    func validateuser () {
        print("\(String(describing: UserDefaults.standard.string(forKey: "isblocked")))")
        print("Password===========================================================================")
        print(UserDefaults.standard.string(forKey: "password"))
        print("Password=="+password.text!)
    //    UserDefaults.standard.set(AppDelegate.usercodeLogin, forKey: "usercode")
        if password.text == UserDefaults.standard.string(forKey: "password") {
            if !isblocked {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    print("dashboard ----- >>>")
                    if UserDefaults.standard.string(forKey: "executeapi") != self.getdate(){
                        UserDefaults.standard.set(true, forKey: "islogged")
                        self.postDownload()
                        print("self -> \(self.navigationController)")
                        //                        self.gotodash()
                        self.view.isUserInteractionEnabled = true
                        self.pushnext(identifier: "Dashboard", controller: self)
                        
                    }
                    else {
                        UserDefaults.standard.set(true, forKey: "islogged")
                        AppDelegate.usertype = UserDefaults.standard.string(forKey: "usertype")!
                        self.pushnext(identifier: "Dashboard", controller: self)
                    }                    
                }
            }
            else {
                
                base.BlockCheck()
                showtoast(controller: self, message: "User Blocked", seconds: 1.5)
            }
        }
        else {
            showtoast(controller: self, message: "Invalid Password", seconds: 1.5)
        }
    }
    func gotodash(){
        //        let SB2 = UIStoryboard(name: "Main", bundle:nil)
        //        let nvc = SB2.instantiateViewController(withIdentifier: "login") as! UIViewController
        //        print("self nav ========> \(nvc)")
        //        let forgot = (nvc.storyboard?.instantiateViewController(withIdentifier: "Dashboard"))!
        //        nvc.navigationController?.pushViewController(forgot, animated: true)
        
    }
    func  getuserdetails(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            
            view.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
            print("loader activated")
           // let usercode = UserDefaults.standard.string(forKey: "usercode")!
          //  UserDefaults.standard.set(usercode, forKey: "usercode")
            print("UserCodeLoginBtnClick===="+UserDefaults.standard.string(forKey: "usercode")!)

            //          DispatchQueue.global(qos: .userInitiated).async {
            Alamofire.request(constant.Base_url + constant.configInfo() + self.password.text! + "&ismobile=1").validate().responseJSON {
                response in
                print("getuserdetails=========="+constant.Base_url + constant.configInfo() + self.password.text! + "&ismobile=1")
                switch response.result {
                case .success(let value): print("success=======> \(value)")
                if let json = response.result.value{
                    let jsonarray: NSArray = json as! NSArray
                    if jsonarray.count > 0 {
                        self.usertype = "\(((jsonarray[0] as AnyObject).value(forKey: "usertype") as? Int)!)"
                        UserDefaults.standard.set(self.usertype!, forKey: "usertype")
                        AppDelegate.usertype = self.usertype!
                        
                        UserDefaults.standard.set((jsonarray[0] as AnyObject).value(forKey: "password") as? String, forKey: "password")
                        if ((jsonarray[0] as AnyObject).value(forKey: "isblocked") as? Bool) == true {
                            self.isblocked = true
                            UserDefaults.standard.set("1", forKey: "isblocked")
                        }
                        else {
                            self.isblocked = false
                            UserDefaults.standard.set("0", forKey: "isblocked")
                        }
                    }
                    else {
                        self.showtoast(controller: self, message: "Invalid password", seconds: 2.0)
                    }
                }
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                print("loader deactivated")
                
                self.validateuser()
                    break
                    
                case .failure(let error): print("error====||=====> \(error)")
                self.showtoast(controller: self, message: "Oops...Somethimg went wrong", seconds: 1.5)
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                    break
                }
            }
            
        }
        else {
            self.showtoast(controller: self, message: "Please Check your Internet connection", seconds: 2.0)
        }
    }
    override func callback(){
    }
    func locationAccess(){
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
           case .notDetermined:
              CLLocationManager().requestWhenInUseAuthorization()
           return
           case .denied, .restricted:
              let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alert.addAction(okAction)
              present(alert, animated: true, completion: nil)
           return
           case .authorizedAlways, .authorizedWhenInUse:
           break
        }
    }
    
    func validate() -> Bool {
        var validate = true
        
        let locStatus = CLLocationManager.authorizationStatus()
        if(CLLocationManager.locationServicesEnabled()){
            switch locStatus {
               case .notDetermined:
                  CLLocationManager().requestWhenInUseAuthorization()
               validate = true
                print("1")
               case .denied, .restricted:
                  let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
                  let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                  alert.addAction(okAction)
                  present(alert, animated: true, completion: nil)
                 validate = false
                print("2")
               case .authorizedAlways, .authorizedWhenInUse:
               validate = true
                print("3")
               break
            }
        }
        else {
            let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            validate = false
        }
        
        return validate
    }
}
