//
//  ComplaintReport.swift
//  tynorios
//
//  Created by Acxiom Consulting on 01/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import  SQLite3
import  Alamofire

class ComplaintReport: Executeapi, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate {
    var controller:ComplaintBottomSheet?
    var BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var BlurEffectView = UIVisualEffectView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return complaintreport.count
    }
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        print("touch")
//        return touch.view == gestureRecognizer.view
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! Complaintcell
        let list: Complaintapater
        list = complaintreport[indexPath.row]
        
        cell.complaintno.text = list.cno
        cell.type.text = list.type
        cell.date.text = list.date
        cell.status.text = list.status
        cell.cretedBy.text = list.cretedBy
        let colorhex = list.statusImage!
        let newhex = colorhex.replacingOccurrences(of: "#", with: "")
        
        cell.statusImage.backgroundColor = UIColor().HexToColor(hexString: newhex, alpha: 1.0)
        
        return cell
    }
    
    @IBOutlet weak var complainttable: UITableView!
    var complaintarr: [String]!
    @IBOutlet weak var detailcard: CardView!
    var complaintreport = [Complaintapater]()
    
    @IBOutlet var closingremarklabel: UILabel!
    @IBOutlet var closingremark: UILabel!
    @IBOutlet weak var dremark: UITextView!
    @IBOutlet weak var dcno: UILabel!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    public var datePicker: UIDatePicker?
    public var datePicker2 : UIDatePicker?
    let date = Date()
    var customercode: String?
    let formatter = DateFormatter()
    
    private func makeSearchViewControllerIfNeeded() -> ComplaintBottomSheet {
        
        let currentPullUpController = childViewControllers
            .filter({ $0 is ComplaintBottomSheet })
            .first as? ComplaintBottomSheet
        let pullUpController: ComplaintBottomSheet = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "complaintbottom") as! ComplaintBottomSheet
        pullUpController.isproductbtn = true
        pullUpController.customercode = self.customercode
        pullUpController.category = "Product"
        return pullUpController
    }
    private func makeServiceSearchViewControllerIfNeeded() -> ComplaintBottomSheet {
        
        let currentPullUpController = childViewControllers
            .filter({ $0 is ComplaintBottomSheet })
            .first as? ComplaintBottomSheet
        let pullUpController: ComplaintBottomSheet = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "complaintbottom") as! ComplaintBottomSheet
        pullUpController.isproductbtn = false
        pullUpController.customercode = self.customercode
        pullUpController.category = "Service"
        return pullUpController
    }
    override func viewDidLoad() {
        view.sendSubview(toBack: detailcard)
        super.viewDidLoad()
        self.setnav(controller: self, title: "Complaint Report")
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        complaintarr = []
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
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

//        fromdate.text = self.getdate()
//        todate.text = self.getdate()
        
        self.datePicker?.fromdatecheck()
        self.datePicker2?.fromdatecheck()
        
        complainttable.delegate = self
        complainttable.dataSource = self
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getdetailview))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.complainttable.addGestureRecognizer(tapeno)
        
        let tapdetail = UITapGestureRecognizer(target: self, action: #selector(closedetail))
//        tapdetail.numberOfTapsRequired=2
        tapdetail.delegate=self
        self.view.addGestureRecognizer(tapdetail)
    }
    @objc func getdetailview(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.complainttable)
        if let indexPath = complainttable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            self.getcomplaintdetail(cno: complaintarr[index])
            print("\n \(self.complaintarr[index])")
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
                        Alamofire.request(constant.Base_url + URL_complaintreport + self.customercode!).validate().responseJSON {
                            response in
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
                                        let dataareaid = String (((listarray[i] as AnyObject).value(forKey:"dataareaid") as? String)!)
                                        let feedbacktype = String (((listarray[i] as AnyObject).value(forKey:"feedbacktype") as? String)!)
                                        let itemid = String (((listarray[i] as AnyObject).value(forKey:"itemid") as? String)!)
                                        let customercode = String (((listarray[i] as AnyObject).value(forKey:"customercode") as? String)!)
                                        let feedbackdesc = String (((listarray[i] as AnyObject).value(forKey:"feedbackdesc") as? String)!)
                                        let submitdatetime = String (((listarray[i] as AnyObject).value(forKey:"submitdatetime") as? String)!)
                                        let usercodename = String (((listarray[i] as AnyObject).value(forKey:"usercodename") as? String)!)
                                        
                                        self.insertcomplaintreport(dataareaid: dataareaid as NSString, feedbackcode: cno as NSString, feedbacktype: feedbacktype as NSString, category: category as NSString, itemid: itemid as NSString, feedbackstatus: status as NSString, customercode: customercode as NSString, submitdatetime: submitdatetime as NSString, detail: feedbackdesc as NSString, colorstatus: colorcode as NSString, closerremark: remark as NSString, usercodename: usercodename as NSString)
                                    }}
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
                                }}}}
                }
        
    }
    
    func getcomplaintdetail(cno: String?)
    {
        var stmt:OpaquePointer?
        let query = "select feedbackcode, detail, closerremark,feedbackstatus from feedbacks where feedbackcode='" + cno! + "'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.blurView(view: view)
        view.bringSubview(toFront: detailcard)
//        self.detailcard.isHidden = false
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let dcno = String(cString: sqlite3_column_text(stmt, 0))
            let ddesc = String(cString: sqlite3_column_text(stmt, 1))
            let dcloseremark = String(cString: sqlite3_column_text(stmt, 2))
            let feedbackstatus = String(cString: sqlite3_column_text(stmt, 3))
            let boldText  = "Description: "
            let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
            
            let normalText = ddesc
            let normalString = NSMutableAttributedString(string:normalText)
            
            attributedString.append(normalString)
            
            self.dremark.attributedText = attributedString
            if(feedbackstatus=="Pending to Attend"){
                self.closingremarklabel.isHidden=true
            }
            else{
                self.closingremarklabel.isHidden=false
            }
            self.closingremark.text=dcloseremark
            self.dcno.text = dcno
        }}
    
    func getcomplaintreport ()
    {
        self.complaintreport.removeAll()
        var stmt:OpaquePointer?
        
        let query = "select 1 as _id,feedbackcode as fc,category as ft,substr(submitdatetime,1,10) ,feedbackstatus as fs,detail as detail, colorstatus as colorstatus,closerremark,usercodename  from feedbacks where customercode = '\(customercode!)'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            //String(cString: sqlite3_column_text(stmt, 1))
            let feedbackcode = String(cString: sqlite3_column_text(stmt, 1))
            let category = String(cString: sqlite3_column_text(stmt, 2))
            let date = String(cString: sqlite3_column_text(stmt, 3))
            let status = String(cString: sqlite3_column_text(stmt, 4))
            let cretedBy = String(cString: sqlite3_column_text(stmt, 8))
            let statusColor = String(cString: sqlite3_column_text(stmt, 6))
            
            self.complaintarr.append(feedbackcode)
            
            self.complaintreport.append(Complaintapater(cno: feedbackcode, type: category, date: date, status: status, cetedBy: cretedBy, statusImage: statusColor))
        }
        self.complainttable.reloadData()
        //UserDefaults.standard.removeObject(forKey: "dtrspinnerselection")
        
        self.view.isUserInteractionEnabled = true
        print("got data")
        
    }
    @objc func closedetail () {
         view.sendSubview(toBack: detailcard)
         self.removeBlurView()
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
    
    @IBAction func productBtn(_ sender: Any) {
        var a=[UIView]()
        a = view.window!.subviews
        BlurView(view:view.window!.subviews[a.count - 1])
        controller = storyboard!.instantiateViewController(withIdentifier: "complaintbottom") as! ComplaintBottomSheet
        let screenSize = UIScreen.main.bounds.size
        controller?.isproductbtn=true
        controller?.customercode=self.customercode
        controller?.category="Product"
        self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
//        self.addChildViewController(self.controller!)
        UIApplication.shared.keyWindow!.addSubview(self.controller!.view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            
            
            self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height - self.view.frame.height + 90 , width: screenSize.width, height:  self.view.frame.height)
        }, completion: nil)
        
        let tapblurview = UITapGestureRecognizer(target: self, action: #selector(hidesheet))
        tapblurview.numberOfTapsRequired = 1
        AppDelegate.blureffectview.addGestureRecognizer(tapblurview)
//        addPullUpController()
    }
    @objc func hidesheet(sender: UITapGestureRecognizer){
        print("tappedd")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.controller!.view.frame  = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
            
        })
        { (finished) in
            self.controller!.willMove(toParentViewController: nil)
            self.controller!.view.removeFromSuperview()
            self.controller!.removeFromParentViewController()
        }
        AppDelegate.blureffectview.removeFromSuperview()
        
    }
    func BlurView(view: UIView){
        
        BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        BlurEffectView = UIVisualEffectView(effect: blurEffect)
        BlurEffectView.backgroundColor = UIColor.lightGray
        BlurEffectView.alpha = 0.2
        BlurEffectView.frame = view.bounds
        AppDelegate.blureffectview=BlurEffectView
        view.addSubview(AppDelegate.blureffectview)
    }
//    private func addPullUpController() {
//        let pullUpController = makeSearchViewControllerIfNeeded()
//        _ = pullUpController.view // call pullUpController.viewDidLoad()
//
//        addPullUpController(pullUpController, initialStickyPointOffset: pullUpController.initialPointOffset, animated: true)
//    }
//    private func addServicePullUpController() {
//        let pullUpController = makeServiceSearchViewControllerIfNeeded()
//        _ = pullUpController.view // call pullUpController.viewDidLoad()
//
//        addPullUpController(pullUpController, initialStickyPointOffset: pullUpController.initialPointOffset, animated: true)
//    }
    
    @IBAction func serviceBtn(_ sender: Any) {
        var a=[UIView]()
        a = view.window!.subviews
        BlurView(view:view.window!.subviews[a.count - 1])
        controller = storyboard!.instantiateViewController(withIdentifier: "complaintbottom") as! ComplaintBottomSheet
        controller?.isproductbtn=false
        controller?.customercode=self.customercode
        controller?.category="Service"
        let screenSize = UIScreen.main.bounds.size
        self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
        UIApplication.shared.keyWindow!.addSubview(self.controller!.view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            
            self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height - self.view.frame.height + 90 , width: screenSize.width, height:  self.view.frame.height)
        }, completion: nil)
        
        let tapblurview = UITapGestureRecognizer(target: self, action: #selector(hidesheet))
        tapblurview.numberOfTapsRequired = 1
        AppDelegate.blureffectview.addGestureRecognizer(tapblurview)
//        addServicePullUpController()
    }
    
    @IBAction func backbtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        view.sendSubview(toBack: detailcard)
        self.removeBlurView()
    }
}
