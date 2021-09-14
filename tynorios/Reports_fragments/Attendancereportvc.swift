 //
 //  Attendancereportvc.swift
 //  tynorios
 //
 //  Created by Acxiom Consulting on 09/10/18.
 //  Copyright © 2018 Acxiom. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import SQLite3
 
 class Attendancereportvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendancedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Attendancereportcell
        let list: Attendancereport
        list = attendancedata[indexPath.row]
        
        cell.date.text = list.date
        cell.usercode.text = list.usercode
        cell.daystart.text = list.daystart
        cell.dayend.text = list.dayend
        cell.hours.text = list.hours
        
        return cell
    }
    
    
    @IBOutlet weak var attendancereporttable: UITableView!
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    var attendancedata = [Attendancereport]()
    
    
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Report")
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
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        self.datePicker?.fromdatecheck()
        self.datePicker2?.fromdatecheck()

        attendancereporttable.delegate = self
        attendancereporttable.dataSource = self
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
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewbtn(_ sender: UIButton) {
         self.deleteattendancereport()
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
                    let URL_attendancereport = "GETUSERATTNDETAILS?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text!
                    DispatchQueue.global(qos: .userInitiated).async {
                        Alamofire.request(constant.Base_url + URL_attendancereport).validate().responseJSON {
                            response in
                            switch response.result {
                            case .success(let value): print("success==========> \(value)")
                            
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        let date = String (((listarray[i] as AnyObject).value(forKey:"attndate") as? String)!)
                                        let usercode = String (((listarray[i] as AnyObject).value(forKey:"usercode") as? String)!)
                                        var daystart = String (((listarray[i] as AnyObject).value(forKey:"starttime") as? String)!)
                                        var dayend = String (((listarray[i] as AnyObject).value(forKey:"endtime") as? String)!)
                                        var hours = String(((listarray[i] as AnyObject).value(forKey:"hours") as? String)!)
                                        
                                        if daystart.contains(":"){
                                            daystart.removeLast(3)
                                        }
                                        if dayend.contains(":"){
                                            dayend.removeLast(3)
                                        }
                                        if hours.contains(":"){
                                            hours.removeLast(3)
                                        }
                                        self.insertattenreport(date: date as NSString, usercode: usercode as NSString, daystart: daystart as NSString, dayend: dayend as NSString, hours: hours as NSString)
                                    }}
                                else {
                                    self.showtoast(controller: self, message: "No Record", seconds: 2.0)
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
                                    self.deleteattendancereport()
                                    
                                    //print("\(String(describing: self.spinnerselection!))")
                               
                                }}
                        }
                        
            }
        }
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
    func setlist ()
    {
        self.attendancedata.removeAll()
        var stmt1:OpaquePointer?
        
        let query = "SELECT * FROM attendancereport"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let date = String(cString: sqlite3_column_text(stmt1, 0))
            let usercode = String(cString: sqlite3_column_text(stmt1, 1))
            let daystart = String(cString: sqlite3_column_text(stmt1, 2))
            let dayend = String(cString: sqlite3_column_text(stmt1, 3))
            let hours = String(cString: sqlite3_column_text(stmt1, 4))
            self.attendancedata.append(Attendancereport(date: date, usercode: usercode, daystart: daystart, dayend: dayend, hours: hours))
            print("\(date)       \(usercode)      \(daystart)     \(dayend)     \(hours)")
        }
        self.attendancereporttable.reloadData()
        //UserDefaults.standard.removeObject(forKey: "dtrspinnerselection")  --)(): po hours
        
        self.view.isUserInteractionEnabled = true
        print("got data")
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.gotohome()
     //   dismiss(animated: true, completion: nil)
    }
   
 }
