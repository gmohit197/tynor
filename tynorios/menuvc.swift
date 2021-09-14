//
//  menuvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 08/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SwiftEventBus

class menuvc: Executeapi {
    
    @IBOutlet weak var homeimg: UIImageView!
    @IBOutlet weak var logoutimg: UIImageView!
    @IBOutlet weak var passwordimg: UIImageView!
    @IBOutlet weak var synclogimg: UIImageView!
    @IBOutlet weak var downloadimg: UIImageView!
    @IBOutlet weak var uploadimg: UIImageView!
    @IBOutlet weak var reportsimg: UIImageView!
    @IBOutlet weak var productimg: UIImageView!
    @IBOutlet weak var myprofileimg: UIImageView!
    @IBOutlet weak var expenseimg: UIImageView!
    @IBOutlet weak var attendanceimg: UIImageView!
    @IBOutlet weak var settingimg: UIImageView!
    @IBOutlet weak var plusminusimg: UIImageView!
    
    @IBOutlet weak var homelbl: UILabel!
    @IBOutlet weak var expenselbl: UILabel!
    @IBOutlet weak var attendancelbl: UILabel!
    @IBOutlet weak var logoutlbl: UILabel!
    @IBOutlet weak var passwordlbl: UILabel!
    @IBOutlet weak var syncloglbl: UILabel!
    @IBOutlet weak var downloadlbl: UILabel!
    @IBOutlet weak var uploadlbl: UILabel!
    @IBOutlet weak var reportslbl: UILabel!
    @IBOutlet weak var productlbl: UILabel!
    @IBOutlet weak var profilelbl: UILabel!
    @IBOutlet weak var settinglbl: UILabel!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var settingstack: UIStackView!
    @IBOutlet weak var collepsestack: UIStackView!
    @IBOutlet var backView: UIView!
    
    var flag: Int = 0
    
    var menu : menuvc!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "red_bg_footer")!)
        
        menu = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as? menuvc
        
        SwiftEventBus.onMainThread(self, name: "downloaded") { result in
            self.showalert(controller: self, msg: "Downloaded")
        }
        SwiftEventBus.onMainThread(self, name: "uploaded") { result in
            self.showalert(controller: self, msg: "Posted")
        }
        
      // self.hideview(view: collepsestack)
        self.collepsestack.isHidden = true
        self.scrollview.isScrollEnabled = false
        
        homelbl.isUserInteractionEnabled = true
        homeimg.isUserInteractionEnabled = true
        
        let taphome = UITapGestureRecognizer(target: self, action: #selector(clickHome))
        let taphomeimg = UITapGestureRecognizer(target: self, action: #selector(clickHome))
        taphome.numberOfTapsRequired=1
        taphomeimg.numberOfTapsRequired=1
        homelbl.addGestureRecognizer(taphome)
        homeimg.addGestureRecognizer(taphomeimg)
        
        settinglbl.isUserInteractionEnabled = true
        settingimg.isUserInteractionEnabled = true
        plusminusimg.isUserInteractionEnabled = true

        let tapsetting = UITapGestureRecognizer(target: self, action: #selector(clickSettingstack))
        let tapsettingimg = UITapGestureRecognizer(target: self, action: #selector(clickSettingstack))
        let tapplusminus = UITapGestureRecognizer(target: self, action: #selector(clickSettingstack))
        tapsetting.numberOfTapsRequired=1
        tapsettingimg.numberOfTapsRequired=1
        tapplusminus.numberOfTapsRequired=1
        settinglbl.addGestureRecognizer(tapsetting)
        settingimg.addGestureRecognizer(tapsettingimg)
        plusminusimg.addGestureRecognizer(tapplusminus)

        
        attendancelbl.isUserInteractionEnabled = true
        attendanceimg.isUserInteractionEnabled = true
        
        let tapattendence = UITapGestureRecognizer(target: self, action: #selector(clickAttendence))
        let tapattendenceimg = UITapGestureRecognizer(target: self, action: #selector(clickAttendence))
        tapattendence.numberOfTapsRequired=1
        tapattendenceimg.numberOfTapsRequired=1
        attendancelbl.addGestureRecognizer(tapattendence)
        attendanceimg.addGestureRecognizer(tapattendenceimg)
        
        expenselbl.isUserInteractionEnabled = true
        expenseimg.isUserInteractionEnabled = true
        
        let tapexpense = UITapGestureRecognizer(target: self, action: #selector(clickExpense))
        let tapexpenseimg = UITapGestureRecognizer(target: self, action: #selector(clickExpense))
        tapexpense.numberOfTapsRequired=1
        tapexpenseimg.numberOfTapsRequired=1
        expenselbl.addGestureRecognizer(tapexpense)
        expenseimg.addGestureRecognizer(tapexpenseimg)
        
        reportslbl.isUserInteractionEnabled = true
        reportsimg.isUserInteractionEnabled = true
        
        let tapreport = UITapGestureRecognizer(target: self, action: #selector(clickreport))
        let tapreportimg = UITapGestureRecognizer(target: self, action: #selector(clickreport))
        tapreport.numberOfTapsRequired=1
        tapreportimg.numberOfTapsRequired=1
        reportslbl.addGestureRecognizer(tapreport)
        reportsimg.addGestureRecognizer(tapreportimg)
        
        logoutlbl.isUserInteractionEnabled = true
        logoutimg.isUserInteractionEnabled = true
        
        let taplogout = UITapGestureRecognizer(target: self, action: #selector(clicklogout))
        let taplogoutimg = UITapGestureRecognizer(target: self, action: #selector(clicklogout))
        taplogout.numberOfTapsRequired=1
        taplogoutimg.numberOfTapsRequired=1
        logoutlbl.addGestureRecognizer(taplogout)
        logoutimg.addGestureRecognizer(taplogoutimg)
        
        downloadlbl.isUserInteractionEnabled = true
        downloadimg.isUserInteractionEnabled = true
        
        let tapdownload = UITapGestureRecognizer(target: self, action: #selector(clickdownload))
        let tapdownloadimg = UITapGestureRecognizer(target: self, action: #selector(clickdownload))
        tapdownload.numberOfTapsRequired=1
        tapdownloadimg.numberOfTapsRequired=1
        downloadlbl.addGestureRecognizer(tapdownload)
        downloadimg.addGestureRecognizer(tapdownloadimg)
        
        let tapsync = UITapGestureRecognizer(target: self, action: #selector(clicksync))
        let tapsyncimg = UITapGestureRecognizer(target: self, action: #selector(clicksync))
        tapsync.numberOfTapsRequired=1
        tapsyncimg.numberOfTapsRequired=1
        syncloglbl.addGestureRecognizer(tapsync)
        synclogimg.addGestureRecognizer(tapsyncimg)
        
        productlbl.isUserInteractionEnabled = true
        productimg.isUserInteractionEnabled = true
        
        let tapproductlbl = UITapGestureRecognizer(target: self, action: #selector(clickproductday))
        let tapproductimg = UITapGestureRecognizer(target: self, action: #selector(clickproductday))
        tapproductlbl.numberOfTapsRequired=1
        tapproductimg.numberOfTapsRequired=1
        productlbl.addGestureRecognizer(tapproductlbl)
        productimg.addGestureRecognizer(tapproductimg)
        
        passwordlbl.isUserInteractionEnabled = true
        passwordimg.isUserInteractionEnabled = true
        
        let tappwd = UITapGestureRecognizer(target: self, action: #selector(clickpwd))
        let tappwdimg = UITapGestureRecognizer(target: self, action: #selector(clickpwd))
        tappwd.numberOfTapsRequired=1
        tappwdimg.numberOfTapsRequired=1
        passwordlbl.addGestureRecognizer(tappwd)
        passwordimg.addGestureRecognizer(tappwdimg)
        
        profilelbl.isUserInteractionEnabled = true
        myprofileimg.isUserInteractionEnabled = true
        
        let tapprofilelbl = UITapGestureRecognizer(target: self, action: #selector(clickprofile))
        let tapprofileimg = UITapGestureRecognizer(target: self, action: #selector(clickprofile))
        tapprofilelbl.numberOfTapsRequired=1
        tapprofileimg.numberOfTapsRequired=1
        profilelbl.addGestureRecognizer(tapprofilelbl)
        myprofileimg.addGestureRecognizer(tapprofileimg)
        
        syncloglbl.isUserInteractionEnabled = true
        synclogimg.isUserInteractionEnabled = true
        
        let tapsyncloglbl = UITapGestureRecognizer(target: self, action: #selector(clicksynclog))
        let tapsynclogimg = UITapGestureRecognizer(target: self, action: #selector(clicksynclog))
        tapsyncloglbl.numberOfTapsRequired=1
        tapsynclogimg.numberOfTapsRequired=1
        syncloglbl.addGestureRecognizer(tapsyncloglbl)
        synclogimg.addGestureRecognizer(tapsynclogimg)
        
        uploadlbl.isUserInteractionEnabled = true
        uploadimg.isUserInteractionEnabled = true
        
        let tapuploadlbl = UITapGestureRecognizer(target: self, action: #selector(clickUpload))
        let tapuploadimg = UITapGestureRecognizer(target: self, action: #selector(clickUpload))
        tapsyncloglbl.numberOfTapsRequired=1
        tapsynclogimg.numberOfTapsRequired=1
        uploadlbl.addGestureRecognizer(tapuploadlbl)
        uploadimg.addGestureRecognizer(tapuploadimg)
        
    }
    
    @objc func clickUpload(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
//           self.showloader(title: "Uploading...")
                       
            self.postall(loadingbool: true)
            print("callback is being called\n")
            // self.callback()
            print("callback called\n")
            //self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
                self.view.isUserInteractionEnabled = true
                //self.showalert(msg: "Data Posted Successfully")
            }
        }
        else
        {
            self.showtoast(controller: self, message: "You are Offline! Please check your Internet connection", seconds: 2.0)
        }
    }
   
    @objc func clickHome(){
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        self.navigationController?.pushViewController(home, animated: true)
        
        print("Home is clicked");
        
    }
    
    @objc func clickAttendence(){
        if teamtrainingcheck(){
            self.performSegue(withIdentifier: "Attendence", sender: (Any).self)
        }
    }
    
    @objc func clicksync(){
        self.performSegue(withIdentifier: "orderdetail", sender: (Any).self)
    }
    
    @objc func clickpwd(){
        let pwd: Changepasswordvc = self.storyboard?.instantiateViewController(withIdentifier: "changepwdvc") as! Changepasswordvc
        self.navigationController?.pushViewController(pwd, animated: true)
    }
    
    @objc func clickproductday(){
        if teamtrainingcheck(){
            if attendanceValidation(){
             var attndesc: String?
             attndesc  = self.checkattendance()
              if(attndesc=="Day Start"){
             let product: ProductOfDay = self.storyboard?.instantiateViewController(withIdentifier: "productday") as! ProductOfDay
              self.navigationController?.pushViewController(product, animated: true)
               }
              else{
             self.showtoast(controller: self, message: "Attendance Marked : " + attndesc! , seconds: 2.0)
            }
          }
        }
    }
    
    @objc func clickExpense(){
        if teamtrainingcheck(){
            if attendanceValidation(){
               var attndesc: String?
               attndesc  = self.checkattendance()
                if(attndesc=="Day Start" || attndesc=="Day End"){
                    let expense: ExpenseReport = self.storyboard?.instantiateViewController(withIdentifier: "expense") as! ExpenseReport
                    self.navigationController?.pushViewController(expense, animated: true)
                }
                else{
                    self.showtoast(controller: self, message: "Attendance Marked : " + attndesc! , seconds: 2.0)
                }
            }
        }
    }
    
    @objc func clickSettingstack(){
        if(flag == 0)
        {
            self.plusminusimg.image = UIImage(named: "minus.png")
            self.collepsestack.isHidden = false
            self.scrollview.isScrollEnabled = true
            flag+=1
        }
        else{
            //self.hideview(view: collepsestack)
            self.collepsestack.isHidden = true
            self.scrollview.isScrollEnabled = false
            self.scrollview.scrollToTop(animated: true)
            self.plusminusimg.image = UIImage(named: "plus.png")
            flag = 0;
        }
    }

    
    @objc func clickreport(){
        if teamtrainingcheck(){
            let report: Reportsvc = self.storyboard?.instantiateViewController(withIdentifier: "reports") as! Reportsvc
            report.selectedViewController = report.viewControllers![0]
             report.modalPresentationStyle = .fullScreen
          //  self.navigationController?.pushViewController( report, animated: true)
          //   self.pushnext(identifier: "reports", controller: self)
        //    self.navigationController?.pushViewController(report, animated: true)
           self.present(report, animated: true, completion: nil)
        }
    }
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
           let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
           self.navigationController?.pushViewController(home, animated: true)
       }
    
    @objc func clicksynclog(){
        let synclog: SyncLog = self.storyboard?.instantiateViewController(withIdentifier: "synclog") as! SyncLog
        synclog.selectedViewController = synclog.viewControllers![0]
        synclog.modalPresentationStyle = .fullScreen
        self.present(synclog, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "reportssegue", sender: (Any).self)
        print("synclog is clicked");
        
    }
    
    @objc func clickprofile(){
        let profile: Profiledetail = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! Profiledetail
        self.navigationController?.pushViewController(profile, animated: true)
        
        print("profile is clicked");
        
    }
    
    @objc func clicklogout(){
        pushnext(identifier: "login", controller: self)
    //    self.performSegue(withIdentifier: "logout", sender: (Any).self)
        print("logout is clicked");
        
    }

    @objc func clickdownload(){
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            self.postDownload()
            self.executeapifunc(view: self.view, alert: true)
        }
        else
        {
            self.showtoast(controller: self, message: "You are Offline! Please check your Internet connection", seconds: 2.0)
        }
    }
}
