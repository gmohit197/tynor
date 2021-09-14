//
//  Primaryreportvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class Primaryreportvc: Executeapi, UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return primarycelladapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Primaryreportcell
        
        let list: Primarycelladapter
        list = primarycelladapter[indexPath.row]
        
        cell.createdby.text = list.createdby
        cell.orderno.text = list.orderno
        cell.date.text = list.date
        cell.status.text = list.status
        cell.value.text = list.value
        cell.customername.text = list.customername
        let sono1 = list.logicSono
        if sono1 == "Value"{
            cell.logicSoNo.text = sono1
            cell.logicSoNo.textColor = UIColor.lightGray
        }
        else{
            cell.logicSoNo.text = sono1
            cell.logicSoNo.textColor = UIColor.black
        }
        return cell
    }
    
    @IBOutlet weak var orderreporttable: UITableView!
    
    var site: String!
    var sono: String!
    var sitearr:  [String]!
    var sonoarr:  [String]!
    
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    
    var primarycelladapter = [Primarycelladapter]()
    
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    @IBOutlet weak var nodataview: UIView!
    
    @IBOutlet weak var distributrspinner: DropDownUtil!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setnav(controller: self, title: "Order Report")
        distributrspinner.isHidden = true
        nodataview.isHidden = true
        distributrspinner.optionIds = []
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
//        let result = formatter.string(from: date)
//
//        fromdate.text = result
//        todate.text = result
        
        self.datePicker?.fromdatecheck()
        self.datePicker2?.fromdatecheck()
        
        orderreporttable.delegate = self
        orderreporttable.dataSource = self
        
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getdetailview))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.orderreporttable.addGestureRecognizer(tapeno)
        
        distributrspinner.didSelect { (Selected, index, id) in
            print("Selected=========> \(Selected)")
            print("id=========> \(id)")
            self.setlist(siteid: Int16(id))
        }
        
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
    
    @objc func getdetailview(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.orderreporttable)
        if let indexPath = orderreporttable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            
            let orderDetail: Orderdetail = self.storyboard?.instantiateViewController(withIdentifier: "primary") as! Orderdetail
            
            orderDetail.siteid = self.sitearr[index]
            orderDetail.sono = self.sonoarr[index]
            orderDetail.id = "primary"
            
            self.navigationController?.pushViewController(orderDetail, animated: true)
            
        }
    }
    @objc func singleTapped() {
        // do something here
        view.endEditing(true)
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
    
    @IBAction func viewbtn(_ sender: Any) {
        self.deleteindentdetails()
        self.setorderspinnr()
        self.setlist(siteid: 0)
       if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){
                    self.view.isUserInteractionEnabled = false
                    print("sending request")
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                    activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                    activityIndicator.color = UIColor.black
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    print("loader activated")
                    
                    let URL_indentdetails = "IndentDetails?SITEID=\(UserDefaults.standard.string(forKey: "usercode")!)&INDENTNO=&DATAAREAID=\(UserDefaults.standard.string(forKey: "dataareaid")!)&FROMDATE=\(self.fromdate.text!)&TODATE=\(self.todate.text!)"
                    
                    DispatchQueue.main.async{
                        Alamofire.request(constant.Base_url + URL_indentdetails).validate().responseJSON {
                            response in
                            switch response.result {
                            case .success(let value): print("success==========> \(value)")
                            self.deleteindentdetails()
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                                        let indentno = String (((listarray[i] as AnyObject).value(forKey:"indentno") as? String)!)
                                        let indentdate = String (((listarray[i] as AnyObject).value(forKey:"indentdate") as? String)!)
                                        let lineno = String (((listarray[i] as AnyObject).value(forKey:"lineno") as? Int)!)
                                        let itemid = String(((listarray[i] as AnyObject).value(forKey:"itemid") as? String)!)
                                        let itemname = String (((listarray[i] as AnyObject).value(forKey:"itemname") as? String)!)
                                        let itemvarriantsize = String (((listarray[i] as AnyObject).value(forKey:"itemvarriantsize") as? String)!)
                                        let itemgroup = String (((listarray[i] as AnyObject).value(forKey:"itemgroup") as? String)!)
                                        let quantity = String(((listarray[i] as AnyObject).value(forKey:"quantity") as? Double)!)
                                        let rate = String (((listarray[i] as AnyObject).value(forKey:"rate") as? Double)!)
                                        let amount = String (((listarray[i] as AnyObject).value(forKey:"lineamount") as? Double)!)
                                        let action = String(((listarray[i] as AnyObject).value(forKey:"action") as? String)!)
                                        let createdby = String(((listarray[i] as AnyObject).value(forKey:"createdby") as? String)!)
                                        let sono = String(((listarray[i] as AnyObject).value(forKey:"sono") as? String)!)
                                        
                                        self.insertIndentDetails(siteid: siteid as NSString, indentno: indentno as NSString, indentdate: indentdate as NSString, lineno: lineno as NSString, itemid: itemid as NSString, itemname: itemname as NSString, itemvarriantsize: itemvarriantsize as NSString, itemgroup: itemgroup as NSString, quantity: quantity as NSString, rate: rate as NSString, amount: amount as NSString, action: action as NSString, createdby: createdby as NSString, sono: sono as NSString)
                                        self.distributrspinner.isHidden = false
                                        self.nodataview.isHidden = true
                                    }}
                                else {
                                    self.showtoast(controller: self, message: "No Orders", seconds: 2.0)
                                    self.distributrspinner.isHidden = true
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
                            
                            self.setorderspinnr()
                            self.setlist(siteid: 0)
                            
                             }
                        
                             }
                        }
                    }
    

    
    func setlist(siteid: Int16?)
    {
        self.primarycelladapter.removeAll()
        var stmt1:OpaquePointer?
        var query: String?
        self.sitearr = []
        self.sonoarr = []
        if siteid == 0
        {
            query = "select 1 _id, A.siteid ,A.indentno,A.indentdate,CAST(ROUND(sum(rate * quantity),2)  AS nvarchar(12)) as amount,A.action as status,B.sitename,A.createdby,A.sono from IndentDetails A inner join USERDISTRIBUTOR B on A.siteid = B.siteid group by A.siteid,indentno,A.indentdate,A.action,B.sitename"
        }
        else{
            query = "select 1 _id, A.siteid ,A.indentno,A.indentdate,CAST(ROUND(sum(rate * quantity),2)  AS nvarchar(12)) as amount,A.action as status,B.sitename,A.createdby,A.sono from IndentDetails A  inner join USERDISTRIBUTOR B on A.siteid = B.siteid  where B.siteid='\(siteid!)' group by A.siteid,indentno,A.indentdate,A.action,B.sitename"
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let customername = String(cString: sqlite3_column_text(stmt1, 6))
            let orderno = String(cString: sqlite3_column_text(stmt1, 2))
            let date = String(cString: sqlite3_column_text(stmt1, 3))
            let value = String(cString: sqlite3_column_text(stmt1, 4))
            let status = String(cString: sqlite3_column_text(stmt1, 5))
            let createdby = String(cString: sqlite3_column_text(stmt1, 7))
            let siteid1 = String(cString: sqlite3_column_text(stmt1, 1))
            var logicsono = String(cString: sqlite3_column_text(stmt1, 8))
            if logicsono == ""{
                logicsono = "Value"
            }
            
            self.primarycelladapter.append(Primarycelladapter(createdby: createdby, orderno: orderno, date: date, status: status, value: value, customername: customername, logicSono: logicsono))
            
            self.sonoarr.append(orderno)
            self.sitearr.append(siteid1)
        }
        
        self.orderreporttable.reloadData()
        
        self.view.isUserInteractionEnabled = true
        print("got data")
    }
    
    func setorderspinnr()
    {
        var stmt1: OpaquePointer?
        
        let query = "select 0 as siteid,'Select Super Dealer' as sitename union select distinct A.siteid,A.sitename from userdistributor A inner join IndentDetails B on A.siteid = B.siteid"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let siteid = String(cString: sqlite3_column_text(stmt1, 0))
            
            let sitename = String(cString: sqlite3_column_text(stmt1, 1))
            distributrspinner.optionArray.append(sitename)
            distributrspinner.optionIds?.append(Int(siteid) ?? 0)
          //  distributrspinner.optionIds?.append(siteid)
            print("spinner =========> \(distributrspinner.optionArray)")
        }
        self.distributrspinner.text = distributrspinner.optionArray[0]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dealervc = segue.destination as?  UINavigationController,
            let vc = dealervc.topViewController as? Orderdetail {
            if (segue.identifier == "primary"){
                vc.siteid = self.site
                vc.sono = self.sono
                vc.id = "primary"
            }
        }
    }
    
    @IBAction func homebtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
          self.getToHome(controller: self)
    }
}
