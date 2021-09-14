//
//  ExpenseReport.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3
import SwiftEventBus

class ExpenseReport: Executeapi, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        ExpenseReportcell
        let list: Expensereportdata
        list = expensedata[indexPath.row]
        
        cell.date.text = list.date
        cell.TA.text = list.TA
        cell.DA.text = list.DA
        cell.misscelions.text = list.misscelions
        cell.total.text = list.total
        cell.city.text = list.city
        
        return cell
    }
    
    
    @IBOutlet weak var Expencereporttable: UITableView!
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    var expensedata = [Expensereportdata]()
    
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    var isExpenseToday = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setnav(controller: self, title: "Expense Report")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        UserDefaults.standard.removeObject(forKey: "fromdate")
        UserDefaults.standard.removeObject(forKey: "todate")
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        
        
        self.validateExpense()
    //   self.view.isUserInteractionEnabled = true
        
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
//
//        fromdate.text = result
//        todate.text = result
        
        Expencereporttable.delegate = self
        Expencereporttable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         SwiftEventBus.onMainThread(self, name: "gotexpensetoday") { Result in
            self.isExpenseToday = false
           // self.hideloader()
          //   self.view.isUserInteractionEnabled = true
          }
        
        SwiftEventBus.onMainThread(self, name: "notexpensetoday") { Result in
            self.showtoast(controller: self, message: "Please check your Internet Connection and Try Again Later !", seconds: 2.0)
         // self.isExpenseToday  = true
          //  self.hideloader()
         // self.view.isUserInteractionEnabled = true
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
    
    @IBAction func viewbtn(_ sender: Any) {
        
        self.deleteexpensereport()
        self.setlist()
        if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){
                    self.view.isUserInteractionEnabled = false
                    print("sending request")
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                    activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                    activityIndicator.color = UIColor.black
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    print("loader activated")
                    
                    let URL_expensereport = "GETEXPENSEENTRY?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&ISMOBILE=1" + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text!
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        Alamofire.request(constant.Base_url + URL_expensereport).validate().responseJSON {
                            response in
                            
                            switch response.result {
                            case .success(let value): print("success==========> \(value)")
                            
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        let expenseid = String (((listarray[i] as AnyObject).value(forKey:"expenseid") as? String)!)
                                        let expensedate = String (((listarray[i] as AnyObject).value(forKey:"expensedate") as? String)!)
                                        let da = String (((listarray[i] as AnyObject).value(forKey:"daamt") as? Double)!)
                                        let ta = String (((listarray[i] as AnyObject).value(forKey:"taamt") as? Double)!)
                                        let hotelexpense = String (((listarray[i] as AnyObject).value(forKey:"hotelamt") as? Double)!)
                                        let miscellanous = String (((listarray[i] as AnyObject).value(forKey:"miscamt") as? Double)!)
                                        let workingtype = String (((listarray[i] as AnyObject).value(forKey:"workingtype") as? String)!)
                                        let total = String (((listarray[i] as AnyObject).value(forKey:"totalexpense") as? Double)!)
                                        let cityid = String (((listarray[i] as AnyObject).value(forKey:"cityid") as? String)!)
                                        
                                        self.insertexpensereport(expenseid: expenseid as NSString, expensedate: expensedate as NSString, da: da as NSString, ta: ta as NSString, hotelexpense: hotelexpense as NSString,miscellanous: miscellanous as NSString, workingtype: workingtype as NSString, total: total as NSString, cityname: cityid as NSString)
                                    }}
                                else {
                                    self.showtoast(controller: self, message: "No Expense Submitted", seconds: 2.0)
                                }
                            }
                                break
                                
                            case .failure(let error): print("error============> \(error)")
                                break
                                
                            }
                            
                            DispatchQueue.main.async {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    
                                    // stop animating now that background task is finished
                                    activityIndicator.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                    print("loader deactivated")
                                    self.setlist()
                                    self.deleteexpensereport()
                  
                                }}
                        }
                    
            }
        }
    }
    
    func setlist()
    {
        self.expensedata.removeAll()
        var stmt2:OpaquePointer?
        
        let query = "select 1 _id,A.expensedate, A.ta, A.da, A.miscellanous, B.cityname as cityname ,A.total from ExpenseReport A left outer join CityMaster B on A.cityname=B.CityID "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt2, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
       
        while(sqlite3_step(stmt2) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            var expensedate = String(cString: sqlite3_column_text(stmt2, 1))
            let da = String(cString: sqlite3_column_text(stmt2, 3))
            let ta = String(cString: sqlite3_column_text(stmt2, 2))
            let miscellanous = String(cString: sqlite3_column_text(stmt2, 4))
            let total = String(cString: sqlite3_column_text(stmt2, 6))
            let cityname = String(cString: sqlite3_column_text(stmt2, 5))
            expensedate.removeLast(9)
            self.expensedata.append(Expensereportdata(date: expensedate, TA: ta, DA: da, misscelions: miscellanous, total: total, city: cityname))
            
            print("\(expensedate)  \(da)  \(ta) \(miscellanous) \(total)")
        }
        self.Expencereporttable.reloadData()
    
        self.view.isUserInteractionEnabled = true
        print("got data")
    }
    
    @IBAction func addexpensebtn(_ sender: Any) {
        if(self.validateExpense() && self.isExpenseToday){
            var stmt1: OpaquePointer?
            let cityQ = "select * from UserCurrentCity A inner join CityMaster B on A.city = B.CityID where A.date like '\(self.getdate())%' and isBlocked= 'false'"
            
            if sqlite3_prepare_v2(Databaseconnection.dbs, cityQ, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return;
            }
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                var stmt2:OpaquePointer?
                let query = "select expensedate from Expense where expensedate like '\(self.getdate())%'" //expensedate
                
                if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt2, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                    print("error preparing get: \(errmsg)")
                    return
                }
                
                 if(sqlite3_step(stmt2) == SQLITE_ROW){
                      self.showtoast(controller: self, message: "Expense Already Submitted...", seconds: 1.5)
                }
                else{
                    let expense: ExpenseAdd = self.storyboard?.instantiateViewController(withIdentifier: "expenseaddvc") as! ExpenseAdd
                    self.navigationController?.pushViewController(expense, animated: true)
                }
            }else{
                self.showtoast(controller: self, message: "Select Working Area First", seconds: 1.5)
            }
        }
        else {
            self.showtoast(controller: self, message: "Expense Already Submitted...", seconds: 1.5)
            
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        self.navigationController?.pushViewController(home, animated: true)
        
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
    
    func validateExpense()-> Bool{
        self.checknet()
        if(AppDelegate.ntwrk > 0){
           // self.showloader(title: "Syncing")
           // self.view.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.getExpense()
        }
           }
        else {
            self.showtoast(controller: self, message: "You are Offline", seconds: 1.5)
            return false
        }
        return true
    }
}


