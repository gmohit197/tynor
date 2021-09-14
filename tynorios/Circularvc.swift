//
//  Circularvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SQLite3

class Circularvc: Executeapi, UIDocumentInteractionControllerDelegate, UITableViewDelegate,UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return circularadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Circulercell
        
        let list: Circularadapter
        list = circularadapter[indexPath.row]
      
        cell.desc.text = list.desc
        
        return cell
    }
    
    @IBOutlet weak var webview: UIWebView!
    var urlarr: [String]!
    var circularadapter = [Circularadapter]()
    
    @IBOutlet weak var circulartable: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var cancelbutton: UIButton!

    @IBAction func cancelbtn(_ sender: Any) {
            webview.isHidden = true
            cancelbutton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Circulars")
        self.noDataView.isHidden = true
        urlarr = []
        let tappdf = UITapGestureRecognizer(target: self, action: #selector(getpdf))
        tappdf.numberOfTapsRequired = 1
        circulartable.addGestureRecognizer(tappdf)
        webview.isHidden = true
        cancelbutton.isHidden = true
        self.checknet()
        if AppDelegate.ntwrk > 0{
            self.URL_GetCircular()
        }
        setlist()
    }
    
    @objc func getpdf(_ gestureRecognizer: UITapGestureRecognizer)
    {
        self.checknet()
        let touchPoint = gestureRecognizer.location(in: self.circulartable)
        if AppDelegate.ntwrk > 0{
            if let indexPath = circulartable.indexPathForRow(at: touchPoint) {
                
                
                //     webview.isHidden = false
                //      cancelbutton.isHidden = false
                let url: URL! = URL(string:  self.urlarr[indexPath.row])
                //   self.showActionSheet(url: self.urlarr[indexPath.row]);
                //  print("url=======> \(url)")
                UIApplication.shared.open(url)
                //     webview.loadRequest(URLRequest(url: url))
            }
        }
        else{
            showtoast(controller: self, message: "You are offline", seconds: 1.0)
        }
    }
    func showActionSheet(url: String) {

        let actionSheet = UIAlertController(title: "Information", message: "Which browser do you want to use ?", preferredStyle: .actionSheet)

        if UIApplication.shared.canOpenURL(URL(string: url)!) {
            actionSheet.addAction(UIAlertAction(title: "Safari", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }))
        }

        /* I tried also this for below line .canOpenURL(URL(string: "googlechrome://")!) */

        if UIApplication.shared.canOpenURL(URL(string: "googlechrome://\(url)")!) {
            actionSheet.addAction(UIAlertAction(title: "Chrome", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                UIApplication.shared.open(URL(string: "googlechrome://\(url)")!, options: [:], completionHandler: nil)
            }))
        } else {
            actionSheet.addAction(UIAlertAction(title: "Chrome", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                UIApplication.shared.open(URL(string: "https://apps.apple.com/tr/app/google-chrome/id535886823")!, options: [:], completionHandler: nil)
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    
    func URL_GetCircular(){
        Alamofire.request(constant.Base_url + constant.URL_GetpdffileConst()).validate().responseJSON {
            response in
            
            switch response.result {
            case .success(let value): print("success==========> \(value)")
            self.deleteCircular()
            if  let json = response.result.value{
                let listarray : NSArray = json as! NSArray
                if listarray.count > 0 {
                    for i in 0..<listarray.count{
                        
                        let sno = String (((listarray[i] as AnyObject).value(forKey:"s.no") as? Int)!)
                        let filename = String (((listarray[i] as AnyObject).value(forKey:"filename") as! NSObject).description)
                        let filetype = String (((listarray[i] as AnyObject).value(forKey:"filetype") as! NSObject).description)
                        let filepath = String (((listarray[i] as AnyObject).value(forKey:"filepath") as! NSObject).description)
                        let description = String(((listarray[i] as AnyObject).value(forKey:"description") as! NSObject).description)
                        let territorycode = String (((listarray[i] as AnyObject).value(forKey:"territorycode") as! NSObject).description)
                        let sectorcode = String (((listarray[i] as AnyObject).value(forKey:"sectorcode") as! NSObject).description)
                        let pocketcode = String (((listarray[i] as AnyObject).value(forKey:"pocketcode") as! NSObject).description)
                        let uploaddate = String(((listarray[i] as AnyObject).value(forKey:"uploaddate") as! NSObject).description)
                        let uploadtime = String (((listarray[i] as AnyObject).value(forKey:"uploadtime") as! NSObject).description)
                        
                        self.insertCircular(sno: sno, filename: filename, type: filetype, url: filepath, description: description, uploaddate: uploaddate, uploadtime: uploadtime)
                    }
                    Loginvc.flagcount = Loginvc.flagcount + 1
                    self.updatelog(tablename: "Circular", status: "success", datetime: self.getTodaydatetime())
                }
                self.updateprogress()
            }
            break
            case .failure(let error):  print("error===========\(error)")
            self.updatelog(tablename: "Circular",status: error as? String, datetime: self.getTodaydatetime())
            self.showtoast(controller: self, message: "Ooops... Something went wrong!! ", seconds: 1.3)
                break
            }}}
    
    func setlist()
    {
        circularadapter.removeAll()
        var stmt1: OpaquePointer?
        var flag = 0
        
        let query = "select filename,url,description from Circular"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            flag += 1
            
            let url = String(cString: sqlite3_column_text(stmt1, 1))
            let description = String(cString: sqlite3_column_text(stmt1, 2))
            
            urlarr.append(url)
            self.circularadapter.append(Circularadapter(pdfname: "", desc: description))
        }
        circulartable.reloadData()
        
        if flag == 0{
            self.noDataView.isHidden = false
            //showtoast(controller: self, message: "Circular Activity is Empty", seconds: 2.0)
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
}
