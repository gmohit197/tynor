//
//  Complaintreportvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 09/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3
import Foundation

class Complaintreportvc: Executeapi, UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complaintreport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Complaintreportcell
        let list: Complaintreportcelladapter
        list = complaintreport[indexPath.row]
        
        cell.cno.text = list.cno
        cell.category.text = list.category
        cell.status.text = list.status
        cell.customername.text = list.customername
        cell.csttype.text = list.csttype
        cell.createdby.text = list.createdby
        let colorhex = list.colorstatus!
        let newhex = colorhex.replacingOccurrences(of: "#", with: "")
     
        cell.colorstatus.backgroundColor = UIColor().HexToColor(hexString: newhex, alpha: 1.0)
        
        return cell
    }
    var source: String? = ""
    var tabbar: Bool! = false
    var complaintarr: [String]!
    var i:Int = 1
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var complainttable: UITableView!
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    var complaintreport = [Complaintreportcelladapter]()
    
    @IBOutlet var rootview: UIView!
    @IBOutlet weak var complaincode: UILabel!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var remarklbl: UILabel!
    @IBOutlet weak var todate: UITextField!
    @IBOutlet weak var closingstack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubview(toBack: detailview)
        if tabbar == true
        {
            self.setnav(controller: self, title: "Complaint Report")
        }
        else
        {
            self.setnav(controller: self, title: "Report")
        }
        
        complaintarr = []
        self.complainttable.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        self.tabBarController?.tabBar.isHidden = tabbar
        self.cardview(myview: self.view)
        
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
        
        complainttable.delegate = self
        complainttable.dataSource = self
        
        let tapcno = UITapGestureRecognizer(target: self, action: #selector(getdetailview))
        tapcno.numberOfTapsRequired=1
        tapcno.delegate = self as? UIGestureRecognizerDelegate
        self.complainttable.addGestureRecognizer(tapcno)
        
        let tapdetail = UITapGestureRecognizer(target: self, action: #selector(closedetail))
//        tapdetail.numberOfTapsRequired=2
        self.view.addGestureRecognizer(tapdetail)
    }
    
    @objc func closedetail () {
        view.sendSubview(toBack: detailview)
        removeBlurView()
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
        let touchPoint = gestureRecognizer.location(in: self.complainttable)
        if let indexPath = complainttable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            self.getcomplaintdetail(cno: complaintarr[index])
            print("\n \(self.complaintarr[index])")
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
    
    @IBAction func viewbtn(_ sender: UIButton) {
        
          self.deletecomplaintreport()
          self.getcomplaintreport()
        
         if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){
            
                    self.view.isUserInteractionEnabled = false
                    print("sending request")
            
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                    activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                    activityIndicator.color = UIColor.black
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    print("loader activated")
                    let URL_complaintreport = "GetUserFeedbackEntry?USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! +  "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! +  "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text! + "&CUSTOMERCODE="
                    DispatchQueue.global(qos: .userInitiated).async {
                        Alamofire.request(constant.Base_url + URL_complaintreport + "-1").validate().responseJSON {
                            response in
                            print("complaintreport======================================")
                            print(constant.Base_url + URL_complaintreport + "-1")
                            switch response.result {
                            case .success(let value): print("success=======>\(value)")
                            self.deletecomplaintreport()
                            self.complaintarr.removeAll()
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        
                                        let cno = String (((listarray[i] as AnyObject).value(forKey:"feedbackcode") as? String)!)
                                        let status = String (((listarray[i] as AnyObject).value(forKey:"feedbackstatus") as? String)!)
                                        let category = String (((listarray[i] as AnyObject).value(forKey:"category") as? String)!)
                                        let remark = String (((listarray[i] as AnyObject).value(forKey:"closerremark") as? String)!)
                                        let colorcode = String (((listarray[i] as AnyObject).value(forKey:"colorstatus") as? String)!)
                                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"colorstatus") as? String)!)
                                        let feedbacktype = String (((listarray[i] as AnyObject).value(forKey:"feedbacktype") as? String)!)
                                        let itemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as? String)!)
                                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                        let feedbackdesc = String (((listarray[i] as AnyObject).value(forKey:"feedbackdesc") as? String)!)
                                        let submitdatetime = String (((listarray[i] as AnyObject).value(forKey:"submitdatetime") as? String)!)
                                        let usercodename = String (((listarray[i] as AnyObject).value(forKey:"usercodename") as? String)!)
                                        
                                        self.insertcomplaintreport(dataareaid: dataareaid as NSString, feedbackcode: cno as NSString, feedbacktype: feedbacktype as NSString, category: category as NSString, itemid: itemid as NSString, feedbackstatus: status as NSString, customercode: customercode as NSString, submitdatetime: submitdatetime as NSString, detail: feedbackdesc as NSString, colorstatus: colorcode as NSString, closerremark: remark as NSString, usercodename: usercodename as NSString)
                                    }
                                    self.complainttable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                                    self.complainttable.separatorColor = UIColor.lightGray
                                }
                                else {
                                    self.showtoast(controller: self, message: "No Complaints", seconds: 2.0)
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
                                    self.getcomplaintreport()
                               
                                }}
                        }
                        
            }
        }
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        if tabbar {
            if AppDelegate.usertype == "11" {
                let daily: DailyResponsibility = self.storyboard?.instantiateViewController(withIdentifier: "SPO") as! DailyResponsibility
                self.navigationController?.pushViewController(daily, animated: true)
            }
            else{
                let daily: DailyResponsibility = self.storyboard?.instantiateViewController(withIdentifier: "dailyres") as! DailyResponsibility
                self.navigationController?.pushViewController(daily, animated: true)
            }
        }
        else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func getcomplaintreport ()
    {
        self.complaintreport.removeAll()
        var stmt:OpaquePointer?
        var query: String? = ""
        
        if (self.source! == "daily"){
            query = "select 1 as _id, A.feedbackcode as fc,A.category as ft,ifnull(B.customername,'') as customername,A.feedbackstatus as fs,A.detail as \n" +
                "detail,A.colorstatus as colorstatus, A.closerremark as closerremark, ifnull(C.type,'DEALER') as type,A.usercodename as username from feedbacks A LEFT outer join (SELECT CUSTOMERCODE,CUSTOMERNAME,CUSTOMERTYPE FROM RetailerMaster\n" +
                "UNION SELECT SITEID AS CUSTOMERCODE,SITENAME CUSTOMERNAME,'CG0002' CUSTOMERTYPE FROM USERDISTRIBUTOR WHERE distributortype <> 'DT000001') B on  B.customercode=A.customercode LEFT OUTER join usertype C on  C.id = B.customertype\n" +
            " where A.feedbackstatus <> 'Resolved' order by fc"
        }
        else{
        query = "select 1 as _id,A.feedbackcode as fc,A.category as ft,C.customername as customername,A.feedbackstatus as fs,A.detail as detail,\n" +
            "                 A.colorstatus as colorstatus,A.closerremark as closerremark,case when D.type is null then 'SUPER DEALER' else D.type end as type, A.usercodename as username \n" +
            "                 from feedbacks A inner join (select customercode,customername,customertype from RetailerMaster \n" +
            "                 union \n" +
        "                 select siteid customercode,substr(sitename,instr(sitename,'-')+1,500) customername,'CG0002' as customertype from USERDISTRIBUTOR) C on  A.customercode= C.customercode left join usertype D on C.customertype=D.id order by fc"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        print (query)
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            //String(cString: sqlite3_column_text(stmt, 1))
            let feedbackcode = String(cString: sqlite3_column_text(stmt, 1))
            let category = String(cString: sqlite3_column_text(stmt, 2))
            let customername = String(cString: sqlite3_column_text(stmt, 3))
            let status = String(cString: sqlite3_column_text(stmt, 4))
            let csttype = String(cString: sqlite3_column_text(stmt, 8))
            let createdby = String(cString: sqlite3_column_text(stmt, 9))
            let colorstatus = String(cString: sqlite3_column_text(stmt, 6))
            
            self.complaintarr.append(feedbackcode)
            self.complaintreport.append(Complaintreportcelladapter(cno: feedbackcode, category: category, customername: customername, status: status, csttype: csttype, createdby: createdby, colorstatus: colorstatus))
            
        }
        
        self.complainttable.reloadData()
        //UserDefaults.standard.removeObject(forKey: "dtrspinnerselection")
        
        self.view.isUserInteractionEnabled = true
        print("got data")
    }
    
    func getcomplaintdetail(cno: String?)
    {
        var stmt:OpaquePointer?
      
        let query = "select feedbackcode,detail,closerremark,feedbackstatus from feedbacks where feedbackcode='" + cno! + "'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        self.blurView(view: rootview)
        view.bringSubview(toFront: detailview)
        detailview.centerXAnchor.constraint(equalTo: rootview.centerXAnchor).isActive = true
        detailview.centerYAnchor.constraint(equalTo: rootview.centerYAnchor).isActive = true
        self.closingstack.isHidden = true
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let dcno = String(cString: sqlite3_column_text(stmt, 0))
            let ddesc = String(cString: sqlite3_column_text(stmt, 1))
            let dremark = String(cString: sqlite3_column_text(stmt, 2))
            let feedbackstatus = String(cString: sqlite3_column_text(stmt, 3))
            
            if feedbackstatus == "Resolved"
            {
               self.closingstack.isHidden = false
            }
            
            let boldText  = "Description: "
            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            
            let normalText = ddesc
            let normalString = NSMutableAttributedString(string:normalText)
            
            attributedString.append(normalString)
            
            self.desc.attributedText = attributedString
            self.complaincode.text = dcno
            self.remarklbl.text = dremark
        }}
    
    @IBAction func homebtn(_ sender: Any) {
         self.gotohome()
             //   dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelbtn(_ sender: Any) {
        view.sendSubview(toBack: detailview)
        removeBlurView()
    }
}

extension String {
    subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
}

extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
    
}
