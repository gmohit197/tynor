//
//  Subdealersreportvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 09/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class Subdealersreportvc: Executeapi,UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subdealeradapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Subdealerreportcell
        let list: Subdealercelladapter
        list = subdealeradapter[indexPath.row]
        
        cell.conversionstatus.text = list.conversionstatus
        cell.retailername.text = list.retailername
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("Row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! Subdealerreportcell
        if(cell.conversionstatus.text=="REJECTED"){
            view.bringSubview(toFront: detailcard)
            self.detailcard.isHidden=false
            let list: Subdealercelladapter
            list = subdealeradapter[indexPath.row]
            self.rejectionreason.text = list.rejectreason
        }
    }
    
    @IBOutlet var detailcard: CardView!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    
    @IBOutlet var rejectionreason: UITextView!
    @IBOutlet weak var subdealertable: UITableView!
    var subdealeradapter = [Subdealercelladapter]()
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
     @objc func getdetailview(_ gestureRecognizer: UIGestureRecognizer){
        if detailcard.isHidden{
            let touchPoint = gestureRecognizer.location(in: self.subdealertable)
            if let indexPath = subdealertable.indexPathForRow(at: touchPoint) {
                let index = indexPath.row
                let cell = subdealertable.cellForRow(at: indexPath) as! Subdealerreportcell
                subdealertable.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                if(cell.conversionstatus.text=="REJECTED"){
                    let list: Subdealercelladapter
                    list = subdealeradapter[indexPath.row]
//                    self.rejectionreason.text = list.rejectreason
                    self.blurView(view: view)
                    view.bringSubview(toFront: detailcard)
                    self.detailcard.isHidden=false
                    let boldText  = "Description: "
                    let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
                    let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
                    
                    let normalText = list.rejectreason!
                    let normalString = NSMutableAttributedString(string:normalText)
                    
                    attributedString.append(normalString)
                    rejectionreason.attributedText=attributedString
                    customername.text=list.retailername
                    
        }
        
            }
            
        }
        else{
            view.sendSubview(toBack: detailcard)
            self.detailcard.isHidden=true
            self.removeBlurView()
        }
        
        
    }
    @IBOutlet var customername: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Report")
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        view.sendSubview(toBack: detailcard)
        self.detailcard.isHidden=true
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
//        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getdetailview))
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.subdealertable.addGestureRecognizer(tapeno)
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
        
        self.datePicker?.fromdatecheck()
        self.datePicker2?.fromdatecheck()
        
//        fromdate.text = result
//        todate.text = result
        
        subdealertable.delegate = self
        subdealertable.dataSource = self
        subdealertable.tableFooterView = UIView()
    }
    
    @objc func singleTapped() {
        // do something here
        view.endEditing(true)
        if !detailcard.isHidden{
         view.sendSubview(toBack: detailcard)
            detailcard.isHidden=true
            self.removeBlurView()
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
    
    
    @IBAction func bsckbtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func viewbtn(_ sender: Any) {
         self.deletsubdelaerentry()
         self.getsubdealer()
          if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){
                    print("sending request")
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                    activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                    activityIndicator.color = UIColor.black
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    print("loader activated")
                    
                    let URL_subDealerEntry = "GetDealerConvertEntry?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text! + "&CREATEDTRANSACTIONID=0&MODIFIEDTRANSACTIONID=0&ISMOBILE=1"
                    DispatchQueue.global(qos: .userInitiated).async {
                        Alamofire.request(constant.Base_url + URL_subDealerEntry).validate().responseJSON {
                            response in
                            switch response.result {
                            case .success(let value): print("success=======>\(value)")
                            self.deletsubdelaerentry()
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        
                                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                                        let recid = String (((listarray[i] as AnyObject).value(forKey:"recid") as? Int)!)
                                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                        let submitdate = String (((listarray[i] as AnyObject).value(forKey:"submitdate") as? String)!)
                                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? Int)!)
                                        let approvedby = String (((listarray[i] as AnyObject).value(forKey:"approvedby") as? String)!)
                                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                                        let expsale = String (((listarray[i] as AnyObject).value(forKey:"expsale") as? Double)!)
                                        let expdiscount = String (((listarray[i] as AnyObject).value(forKey:"expdiscount") as? Double)!)
                                        let createdtransactionid = String (((listarray[i] as AnyObject).value(forKey:"createdtransactionid") as? Int)!)
                                        let modifiedtransactionid = String (((listarray[i] as AnyObject).value(forKey:"modifiedtransactionid") as? Int)!)
                                        let rejectreason = String (((listarray[i] as AnyObject).value(forKey:"rejectreason") as! NSObject).description)
                                        
                                        self.insertdealerreport(customercode: customercode as NSString, expectedsale: expsale as NSString, expectedDiscount: expdiscount as NSString, dataareaid: dataareaid as NSString, recid: recid as NSString, submitdate: submitdate as NSString, status: status as NSString, approvedby: approvedby as NSString, siteid: siteid as NSString, createdtransactionid: createdtransactionid as NSString, modifiedtransactionid: modifiedtransactionid as NSString, rejectreason: rejectreason as NSString)
                                    }
                                    self.subdealertable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                                    self.subdealertable.separatorColor = UIColor.lightGray
                                }
                                else {
                                    self.showtoast(controller: self, message: "No Record Found", seconds: 2.0)
                                }
                            }
                                break
                                
                            case .failure(let error): print("error=========>\(error)")
                                break
                                
                            }
                            DispatchQueue.main.async {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    
                                    // stop animating now that background task is finished
                                    activityIndicator.stopAnimating()
                                    self.view.isUserInteractionEnabled = true
                                    print("loader deactivated")
                                    self.getsubdealer()
                                }}
                        }
                    
                }
        }
           
}
        
    func getsubdealer()
    {
        self.subdealeradapter.removeAll()
        var stmt:OpaquePointer?
        let query = "select 1 as _id,customername,case when status='0' then 'PENDING' when status='2' then 'REJECTED' else 'APPROVED' end as status,rejectreason from SubDealersEntry A inner join RetailerMaster B on A.customercode= B.customercode"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let conversionstatus = String(cString: sqlite3_column_text(stmt, 2))
            let retailername = String(cString: sqlite3_column_text(stmt, 1))
            let rejectreason = "    " + String(cString: sqlite3_column_text(stmt, 3))
            
            self.subdealeradapter.append(Subdealercelladapter(retailername: retailername, conversionstatus: conversionstatus, rejectreason: rejectreason))
            print("got data")
        }
        self.subdealertable.reloadData()
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.gotohome()
            //   dismiss(animated: true, completion: nil)
    }
    
}
