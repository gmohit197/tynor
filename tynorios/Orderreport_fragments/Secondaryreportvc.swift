//
//  Secondaryreportvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class Secondaryreportvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondaryadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Secondaryreportcell
        
        let list: Secondarycelladapter
        list = secondaryadapter[indexPath.row]
        
        var datevalue = list.date
        datevalue?.removeLast(9)
        
        cell.orderno.text = list.orderno
        cell.date.text = datevalue!
        cell.status.text = list.status
        cell.value.text = list.value
        cell.customername.text = list.customername
        
        return cell
    }
    var site: String!
    var sono: String!
    var sitearr:  [String]!
    var sonoarr:  [String]!
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    
    var secondaryadapter  = [Secondarycelladapter]()
    @IBOutlet weak var secondarytableview: UITableView!
    
    @IBOutlet weak var secondaryspinnr: DropDownUtil!
    @IBOutlet weak var nodataview: UIView!
    
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController?.viewControllers?.count == 1 {
         self.tabBarController?.tabBar.isHidden = true
        }else{
                     self.tabBarController?.tabBar.isHidden = false
        }

        self.setnav(controller: self, title: "Order Report")
        nodataview.isHidden = true
        secondaryspinnr.optionIds = []
        site = ""
        sono = ""
        secondaryspinnr.isHidden = true
        secondaryspinnr.didSelect { (Selected, index, id) in
            print("Selected=========> \(Selected)")
            print("id=========> \(id)")
            self.setlist(siteid: Int(id))
        }
        
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getdetailview))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.secondarytableview.addGestureRecognizer(tapeno)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        UserDefaults.standard.removeObject(forKey: "fromdate")
        UserDefaults.standard.removeObject(forKey: "todate")
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        
        
               let toolbar = UIToolbar();
               let toolbar1 = UIToolbar();
               toolbar.sizeToFit()
               toolbar1.sizeToFit()
               let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
               let donetButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatetPicker));
               let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
               let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
               let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
               let canceltButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

               toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
               
               fromdate.inputAccessoryView = toolbar
               fromdate.inputView = datePicker
               
               toolbar1.setItems([donetButton,spacetButton,canceltButton], animated: false)
               
               todate.inputAccessoryView = toolbar1
               todate.inputView = datePicker2
        
        self.datePicker?.fromdatecheck()
        self.datePicker2?.fromdatecheck()
        
        formatter.dateFormat = "yyyy-MM-dd"
//        let result = formatter.string(from: date)

//        fromdate.text = result
//        todate.text = result
        
    }
    @objc func getdetailview(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.secondarytableview)
        if let indexPath = secondarytableview.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            self.site = self.sitearr[index]
            self.sono = self.sonoarr[index]
            print("\n \(self.sitearr[index])        \(self.sonoarr[index])")
            self.performSegue(withIdentifier: "secondary", sender: (Any).self)
        }
    }
    @objc func singleTapped() {
        // do something here
        view.endEditing(true)
    }
    
    @objc func donedatePicker(){
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          fromdate.text = formatter.string(from: self.datePicker!.date)
          self.view.endEditing(true)
      }
      @objc func donedatetPicker(){
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd"
          todate.text = formatter.string(from: self.datePicker2!.date)
          self.view.endEditing(true)
      }
      @objc func cancelDatePicker(){
          self.view.endEditing(true)
      }
    
    @objc func fromdate(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.fromdate.text = dateFormatter.string(from: datePicker.date)
    }
    @objc func todate(datePicker2: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.todate.text = dateFormatter.string(from: datePicker2.date)
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func invoiced(_ sender: Any) {
        
        executeapi(status: "1")
    }
    
    @IBAction func canceled(_ sender: Any) {
        executeapi(status: "2")
    }
    
    @IBAction func pending(_ sender: Any) {
        executeapi(status: "0")
    }
    
    func executeapi(status: String?)
    {
        self.deletesodeatils()
        self.setdealerspinnr()
        if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                    activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                    activityIndicator.color = UIColor.black
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    print("loader activated")
                    
                    let URL_sodetails = "GetUserSODetails?USERCODE=\(UserDefaults.standard.string(forKey: "usercode")!)&USERTYPE=\(UserDefaults.standard.string(forKey: "usertype")!)&DATAAREAID=\(UserDefaults.standard.string(forKey: "dataareaid")!)&STATUS=\(status!)&FROMDATE=\(self.fromdate.text!)&TODATE=\(self.todate.text!)"
                    
                    DispatchQueue.main.async {
                        
                        Alamofire.request(constant.Base_url + URL_sodetails).validate().responseJSON {
                            response in
                            
                            switch response.result {
                            case .success(let value): print("success==========> \(value)")
                            
                            self.deletesodeatils()
                            
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                                        let sono = String (((listarray[i] as AnyObject).value(forKey:"sono") as? String)!)
                                        let sodate = String(((listarray[i] as AnyObject).value(forKey:"sodate") as? String)!)
                                        let sovalue = String (((listarray[i] as AnyObject).value(forKey:"sovalue") as? Double)!)
                                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? String)!)
                                        let lineno = String (((listarray[i] as AnyObject).value(forKey:"qty") as? Double)!)
                                        let itemid = String(((listarray[i] as AnyObject).value(forKey:"itemid") as? String)!)
                                        let discamt = String (((listarray[i] as AnyObject).value(forKey:"discamt") as? Double)!)
                                        let taxprec = String (((listarray[i] as AnyObject).value(forKey:"taxprec") as? Double)!)
                                        let taxamt = String(((listarray[i] as AnyObject).value(forKey:"taxamt") as? Double)!)
                                        let amount = String(((listarray[i] as AnyObject).value(forKey:"amount") as? Double)!)
                                        
                                        self.insertSoDetails(siteid: siteid as NSString, customercode: customercode as NSString, dataareaid: dataareaid as NSString, sono: sono as NSString, sodate: sodate as NSString, sovalue: sovalue as NSString, status: status as NSString
                                            , lineno: lineno as NSString, itemid: itemid as NSString, discamt: discamt as NSString, taxprec: taxprec as NSString, taxamt: taxamt as NSString, amount: amount as NSString)
                                        self.secondaryspinnr.isHidden = false
                                        self.nodataview.isHidden = true
                                    }}
                                    
                                else {
                                    self.showtoast(controller: self, message: "No Orders", seconds: 2.0)
                                    self.secondaryspinnr.isHidden = true
                                    self.nodataview.isHidden = false
                                }
                            }
                            
                                break
                                
                            case .failure(let error): print("error============> \(error)")
                                break
                                
                            }
                            
                            //                DispatchQueue.main.async {
                            //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            //
                            //                        // stop animating now that background task is finished
                            activityIndicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                            print("loader deactivated")
                            
                            self.setdealerspinnr()
                            
                        }
            }
                        
            }
                }
    

    
    func setdealerspinnr ()
    {
        secondaryspinnr.optionArray.removeAll()
        secondaryspinnr.optionIds?.removeAll()
        
        var stmt1: OpaquePointer?
        let query = "select '0' as siteid,'Select Super Dealer' as sitename union select distinct A.siteid,A.sitename from userdistributor A inner join sodetails B on A.siteid = B.siteid "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
//            let siteid = Int(String(cString: sqlite3_column_text(stmt1, 0)))
            let siteid=String(cString: sqlite3_column_text(stmt1, 0))
            let sitename = String(cString: sqlite3_column_text(stmt1, 1))
             print("siteid =========> \(siteid)")
            secondaryspinnr.optionArray.append(sitename)
            secondaryspinnr.optionIds?.append(Int(siteid) ?? 0)

//            secondaryspinnr.optionIds?.append(siteid)
            print("spinner =========> \(secondaryspinnr.optionArray)")
        }
        self.secondaryspinnr.text = secondaryspinnr.optionArray[0]
        setlist(siteid: 0)
        
    }
    
    func setlist(siteid: Int?)
    {
        self.secondaryadapter.removeAll()
        var stmt1:OpaquePointer?
        var query: String?
        self.sitearr = []
        self.sonoarr = []
        if siteid == 0
        {
            query = "Select distinct 1 _id,B.customername,sono,sodate,status,sovalue,A.siteid,C.type from sodetails A inner join RetailerMaster B on A.customercode=B.customercode  inner join  usertype C on B.customertype =C.id"
            
        }
        else{
            query = "Select distinct 1 _id,B.customername,sono,sodate,status,sovalue,A.siteid,C.type from sodetails A inner join RetailerMaster B on A.customercode=B.customercode  inner join  usertype C on B.customertype =C.id  where A.siteid='\(siteid!)'"
            
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let customername = String(cString: sqlite3_column_text(stmt1, 1))
            let orderno = String(cString: sqlite3_column_text(stmt1, 2))
            let date = String(cString: sqlite3_column_text(stmt1, 3))
            let value = String(cString: sqlite3_column_text(stmt1, 5))
            let status = String(cString: sqlite3_column_text(stmt1, 4))
            let siteid1 = String(cString: sqlite3_column_text(stmt1, 6))
            
            self.secondaryadapter.append(Secondarycelladapter(orderno: orderno, date: date, status: status, value: value, customername: customername))
            sonoarr.append(orderno)
            sitearr.append(siteid1)
        }
        
        self.secondarytableview.reloadData()
        
        self.view.isUserInteractionEnabled = true
        print("got data")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dealervc = segue.destination as?  UINavigationController,
            let vc = dealervc.topViewController as? Orderdetail {
            if (segue.identifier == "secondary"){
                vc.siteid = self.site
                vc.sono = self.sono
                vc.id = "secondary"
            }
        }
    }
    
    @IBAction func homebtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.getToHome(controller: self)
    }
}
