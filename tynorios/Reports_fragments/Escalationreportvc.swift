//
//  Escalationreportvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 09/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class Escalationreportvc: Executeapi, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return escalationreport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Escalationreportcell
        let list: Escalationcelladapter
        list = escalationreport[indexPath.row]
        
        cell.customername.text = list.customername
        cell.escalationno.text = list.escalationno
        cell.reason.text = list.reason
        cell.status.text = list.status
        cell.custtype.text = list.custtype
        cell.createdby.text = list.createdby
        
        return cell
    }
    var source: String? = ""
    var tabbar: Bool! = false
    var escalatioarr: [String]!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    var escalationreport = [Escalationcelladapter]()
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    let formatter = DateFormatter()
    @IBOutlet weak var Escalationtable: UITableView!
    @IBOutlet weak var escalationcode: UILabel!
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var closeremarks: UILabel!
    @IBOutlet weak var closestack: UIStackView!
    @IBOutlet weak var detailtxt: UITextView!
    @IBOutlet var rootview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubview(toBack: detailview)
        if tabbar == true
        {
            self.setnav(controller: self, title: " Escalation Report")
        }
        else{
            self.setnav(controller: self, title: "Report")
        }
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date

        self.Escalationtable.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        escalatioarr = []
        datePicker2 = UIDatePicker()
        datePicker2?.datePickerMode = .date
        self.tabBarController?.tabBar.isHidden = tabbar
        
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
        
        Escalationtable.delegate = self
        Escalationtable.dataSource = self
        
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getdetailview))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.Escalationtable.addGestureRecognizer(tapeno)
        
        let tapdetail = UITapGestureRecognizer(target: self, action: #selector(closedetail))
      //  tapdetail.numberOfTapsRequired=2
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
        let touchPoint = gestureRecognizer.location(in: self.Escalationtable)
        if let indexPath = Escalationtable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            self.getescalationdetail(eno: escalatioarr[index])
            print("\n \(self.escalatioarr[index])")
        }
    }
    @objc func singleTapped() {
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
          self.deleteescalationreport()
        self.getescalationreport()
        if(self.validateReportCheck(todate: todate.text!, fromdate: fromdate.text!)){
                print("sending request")
                    self.view.isUserInteractionEnabled = false
                   
                    print("sending request")
                    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
                    activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
                    activityIndicator.color = UIColor.black
                    view.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                    print("loader activated")
                    let URL_escalationreport = "GetUserEscalationEntry?&USERCODE=" + UserDefaults.standard.string(forKey: "usercode")! + "&DATAAREAID=" + UserDefaults.standard.string(forKey: "dataareaid")! + "&USERTYPE=" + UserDefaults.standard.string(forKey: "usertype")! + "&FROMDATE=" + self.fromdate.text! + "&TODATE=" + self.todate.text! + "&CUSTOMERCODE=-1"
                    DispatchQueue.global(qos: .userInitiated).async {
                        Alamofire.request(constant.Base_url + URL_escalationreport).validate().responseJSON {
                            response in
                            print("escalationreport====================================")
                            print(constant.Base_url + URL_escalationreport)

                            switch response.result {
                            case .success(let value): print("success=======>\(value)")
                            self.deleteescalationreport()
                            self.escalatioarr.removeAll()
                            if  let json = response.result.value{
                                let listarray : NSArray = json as! NSArray
                                if listarray.count > 0 {
                                    for i in 0..<listarray.count{
                                        
                                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                                        let escalationid = String (((listarray[i] as AnyObject).value(forKey:"escalationid") as? String)!)
                                        let reasoncode = String (((listarray[i] as AnyObject).value(forKey:"reasoncode") as? String)!)
                                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                        let siteid = String (((listarray[i] as AnyObject).value(forKey:"siteid") as? String)!)
                                        let submittime = String (((listarray[i] as AnyObject).value(forKey:"submittime") as? String)!)
                                        let createdby = String (((listarray[i] as AnyObject).value(forKey:"createdby") as? String)!)
                                        let status = String (((listarray[i] as AnyObject).value(forKey:"status") as? String)!)
                                        let remark = String (((listarray[i] as AnyObject).value(forKey:"remark") as? String)!)
                                        let username = String (((listarray[i] as AnyObject).value(forKey:"username") as? String)!)
                                        let closeremarks = String (((listarray[i] as AnyObject).value(forKey:"closeremarks") as? String)!)
                                        
                                        self.insertescalationreport(dataareaid: dataareaid as NSString, escalationid: escalationid as NSString, customercode: customercode as NSString, siteid: siteid as NSString, submittime: submittime as NSString, createdby: createdby as NSString, status: status as NSString, remark: remark as NSString, reasoncode: reasoncode as NSString, username: username as NSString, closeremarks: closeremarks as NSString, post: "2", latitude: "" , longitude: "")
                                    }
                                    self.Escalationtable.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                                    self.Escalationtable.separatorColor = UIColor.lightGray
                                }
                                else {
                                    self.showtoast(controller: self, message: "No Escalations Submitted", seconds: 2.0)
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
                                    self.getescalationreport()
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
    
    func getescalationreport()
    {
        self.escalationreport.removeAll()
        var stmt:OpaquePointer?
        var query: String?
        if (self.source! == "daily"){
            query = "select 1 _id,A.escalationCode as escalationCode,C.customername as customername,A.status as status,B.reasondescription as reasondescription,A.detail as detail,D.type as type,A.username as username from MarketEscalationActivity A left outer join EscalationReason B  on A.reason = B.reasoncode inner join RetailerMaster C on A.customercode= C.customercode left join usertype D on C.customertype = D.id  where A.post='2' and A.status='OPEN'" +
                " UNION " +
            " select 1 _id,D.escalationCode as escalationCode,substr(F.sitename,instr(F.sitename,'-')+1,500) as customername,D.status as status,E.reasondescription as reasondescription,D.detail as detail,'SUPER DEALER' as type,D.username as username from MarketEscalationActivity D left outer join EscalationReason E  on D.reason = E.reasoncode inner join USERDISTRIBUTOR F on D.customercode= F.siteid where D.post='2' and D.status='OPEN' and F.siteid not in(select customercode as siteid from Retailermaster) order by escalationCode"
        }
        else
        {
        query = "select 1 _id,A.escalationCode as escalationCode,C.customername as customername,A.status as status,B.reasondescription as reasondescription" +
            ",A.detail as detail,D.type as type ,A.username,A.closeremarks" +
            " from MarketEscalationActivity A left outer join EscalationReason B  on A.reason = B.reasoncode inner join RetailerMaster C on A.customercode= C.customercode left join usertype D on C.customertype = D.id  where A.post='2'" +
            " UNION " +
            " select 1 _id,D.escalationCode as escalationCode,substr(F.sitename,instr(F.sitename,'-')+1,500) as customername,D.status as status," +
            "E.reasondescription as reasondescription,D.detail as detail,'SUPER DEALER' as type ,D.username,D.closeremarks from MarketEscalationActivity D " +
            "left outer join EscalationReason E  on D.reason = E.reasoncode inner join USERDISTRIBUTOR F on D.customercode= F.siteid where D.post='2' and F.siteid" +
        " not in(select customercode as siteid from Retailermaster)"
        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let customername = String(cString: sqlite3_column_text(stmt, 2))
            let escalationno = String(cString: sqlite3_column_text(stmt, 1))
            let reason = String(cString: sqlite3_column_text(stmt, 4))
            let status = String(cString: sqlite3_column_text(stmt, 3))
            let custtype = String(cString: sqlite3_column_text(stmt, 6))
            let createdby = String(cString: sqlite3_column_text(stmt, 7))
            
            self.escalatioarr.append(escalationno)
            self.escalationreport.append(Escalationcelladapter(escalationno: escalationno, customername: customername, status: status, reason: reason, custtype: custtype, createdby: createdby))
        }
        self.Escalationtable.reloadData()
        print("got data")
    }
    
    func getescalationdetail(eno: String?)
    {
        var stmt:OpaquePointer?
        let query = "select escalationCode,detail,closeremarks,status from MarketEscalationActivity where escalationCode ='" + eno! + "'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }

        self.blurView(view: rootview)
        view.bringSubview(toFront: detailview)
        detailview.centerXAnchor.constraint(equalTo: rootview.centerXAnchor).isActive = true
        detailview.centerYAnchor.constraint(equalTo: rootview.centerYAnchor).isActive = true
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let descalation = String(cString: sqlite3_column_text(stmt, 0))
            let ddetail = String(cString: sqlite3_column_text(stmt, 1))
            let closeremark = String(cString: sqlite3_column_text(stmt, 2))
            let feedbackstatus = String(cString: sqlite3_column_text(stmt, 3))
            
            if feedbackstatus == "OPEN"
            {
                self.closestack.isHidden = true
            }
            let boldText  = "Description: "
            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

            let normalText = ddetail
            let normalString = NSMutableAttributedString(string:normalText)
            
            attributedString.append(normalString)

            self.detailtxt.attributedText = attributedString
            self.escalationcode.text = descalation
            self.closeremarks.text = closeremark
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
