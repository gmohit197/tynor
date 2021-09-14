//
//  Superdealervc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 01/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class Superdealervc: Executeapi , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superdealeradapter.count
    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        superdeaelrtxt = textField.text!
    //        self.setlist(query: superdeaelrtxt)
    //
    //        return true
    //    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Superdealercell
        let list: Retailerlistadapter
        list = superdealeradapter[indexPath.row]
        
        cell.custname.text = list.customername
        cell.c.text = list.complain
        cell.curmonth.text = list.currmonth
        cell.mobile.text = list.sitename
        cell.lastvisit.text = list.lastvisit
        if (signarr[indexPath.row] == "-1"){
            cell.sign.isHidden = true
        }else if (signarr[indexPath.row] == "0"){
            cell.sign.isHidden = true
        }else if (signarr[indexPath.row] == "1"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "greentick")
        }else if (signarr[indexPath.row] == "2"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "red_tick")
        }else if (signarr[indexPath.row] == "3"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "esc_arrow")
        }else if (signarr[indexPath.row] == "4"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "question")
        }else if (signarr[indexPath.row] == "5"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "escalationsign")
        }else if (signarr[indexPath.row] == "6"){
            cell.sign.isHidden = false
            cell.sign.image = UIImage(named: "likelytobuy")
        }
        return cell
    }
    
    @IBAction func search(_ sender: UITextField) {
        superdealer = sender.text
        self.setlist(query: superdealer)
    }
    
    @IBOutlet weak var nodataview: UIView!
    @IBOutlet weak var superdealertable: UITableView!
    var superdealeradapter = [Retailerlistadapter]()
    var siteidarr: [String]!
    
    @IBOutlet weak var search: UITextField!
    var superdeaelrtxt: String! = ""
    var titlebar: String! = ""
    var lastvisit: String!
    var customername: String!
    var mobile: String!
    var currentmonth: String!
    var complain: String!
    var siteid: String!
    var isecalate: String!
    static var statieid: String!
    static  var statieidarr: [String]!
    var pricegrouparr: [String]!
    var pricegroup: String!
    var isecalatedarr: [String]!
    var plantcodearr: [String]!
    static var plantstateidarr: [String]!
    var customernamear: [String]!
    var signarr: [String]!
    
    var superdealer: String!
    var loadingalert:UIAlertController?
    var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidAppear(_ animated: Bool) {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            loadingalert = UIAlertController(title: "Syncing....", message: "Please wait...", preferredStyle: .alert)
            loadingalert!.view.tintColor = UIColor.black
            loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10,y: 5,width: 50, height: 50)) as UIActivityIndicatorView
             loadingIndicator!.hidesWhenStopped = true
            loadingIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator!.startAnimating();
            loadingalert!.view.addSubview(loadingIndicator!)
            self.present(loadingalert!, animated: false)
            self.postDownload()
            self.downloadall()
        }
        PendingEscalation.ispendingescalated = false
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Super Dealer List")
        siteidarr = []
        pricegrouparr = []
        isecalatedarr = []
        Superdealervc.statieidarr = []
        customernamear = []
        plantcodearr = []
        Superdealervc.plantstateidarr = []
        signarr = []
        
        SwiftEventBus.onMainThread(self, name: "downloadedSyncSuperDealer") { (Result) in
            self.loadingIndicator?.stopAnimating()
            self.loadingalert?.dismiss(animated: false, completion: nil)
            self.setlist(query: "")
            self.view.isUserInteractionEnabled = true
        }
        search.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 16))
        let image = UIImage(named: "search1.png")
        imageView.image = image
        search.leftView = imageView
        
        setlist(query: "")
        self.navigationItem.title = titlebar + " List"
        //        search.delegate = self
        superdealertable.delegate = self
        superdealertable.dataSource = self
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(getcustomer))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.superdealertable.addGestureRecognizer(tapeno)
    }
    
    @objc func getcustomer(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.superdealertable)
        if let indexPath = superdealertable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            
            print("\n \(self.siteidarr[index])  ")
            let custcard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            CustomerCard.siteid = self.siteidarr[index]
            custcard.customercode = self.siteidarr[index]
            custcard.pricegroup = self.pricegrouparr[index]
            CustomerCard.stateid = Superdealervc.statieidarr[index]
            custcard.isescalated = self.isecalatedarr[index]
            CustomerCard.plantcode = self.plantcodearr[index]
            CustomerCard.plantstateid = Superdealervc.plantstateidarr[index]
            custcard.titletxt = "Super Dealer"
//            custcard.customername = "\(self.customernamear[index].prefix(14)).."
            custcard.customername = "\(self.customernamear[index])"

            AppDelegate.customercode = self.siteidarr[index]
            AppDelegate.siteid = self.siteidarr[index]
            self.navigationController?.pushViewController(custcard, animated: true)
        }
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
       // self.dismiss(animated: true, completion: nil)
        let daily: DailyResponsibility = self.storyboard?.instantiateViewController(withIdentifier: "dailyres") as! DailyResponsibility
        self.navigationController?.pushViewController(daily, animated: true)
        
//        self.navigationController?.popViewController(animated: false)
//        let daily: DailyResponsibility = self.storyboard?.instantiateViewController(withIdentifier: "dailyres") as! DailyResponsibility
//        self.navigationController?.pushViewController(daily, animated: true)
    }
    
    func setlist(query: String!)
    {
        superdealeradapter.removeAll()
        var stmt1:OpaquePointer?
        let date = self.getdate()
        var sign = ""
        let querystr =  "select DISTINCT 1 _id,A.sitename,ifnull(D.lastvisit,'-'),substr(A.mobile,1,10),ifnull(D.complain,'-'),ifnull(D.currentmonth,'-') ,A.siteid,A.pricegroup,ifnull(D.isescalated,'-'),A.stateid as disstate, case when (select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.siteid and A1.lastvisit LIKE '%\(date)%')=0 then 'No Order' when(select count(*) from USERCUSTOMEROTHINFO A1 where A1.customercode = A.siteid and A1.lastvisit LIKE '%\(date)%') > 0 then 'Done' else 'Open' end as status,A.plantcode,A.plantstateid,ifnull(D.lastactivityid,'-') from userdistributor A left join USERCUSTOMEROTHINFO D on A.siteid = D.customercode left join CityMaster E on A.city =E.CityID where A.distributortype <> 'DT000001' and isdisplay = 'true' and  (city like '%\(query!)%' or sitename like '%\(query!)%' )"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, querystr, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        siteidarr.removeAll()
        Superdealervc.statieidarr.removeAll()
        pricegrouparr.removeAll()
        isecalatedarr.removeAll()
        customernamear.removeAll()
        plantcodearr.removeAll()
        Superdealervc.plantstateidarr.removeAll()
        signarr.removeAll()
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            siteid = String(cString: sqlite3_column_text(stmt1, 6))
            checkRetailersign(customercode: siteid)
            let lastvisitdate = String(cString: sqlite3_column_text(stmt1, 2))
            customername = String(cString: sqlite3_column_text(stmt1, 1))
            pricegroup = String(cString: sqlite3_column_text(stmt1, 7))
            mobile = String(cString: sqlite3_column_text(stmt1, 3))
            isecalate = String(cString: sqlite3_column_text(stmt1, 8))
            currentmonth = String(cString: sqlite3_column_text(stmt1, 5))
            Superdealervc.statieid = String(cString: sqlite3_column_text(stmt1, 9))
            complain = String(cString: sqlite3_column_text(stmt1, 4))
            Superdealervc.statieidarr.append(Superdealervc.statieid)
            siteidarr.append(siteid)
            pricegrouparr.append(pricegroup)
            isecalatedarr.append(isecalate)
            customernamear.append(customername)
            plantcodearr.append(String(cString: sqlite3_column_text(stmt1, 11)))
            Superdealervc.plantstateidarr.append(String(cString: sqlite3_column_text(stmt1, 12)))
            sign = String(cString: sqlite3_column_text(stmt1, 13))
            lastvisit = lastvisitdate.replacingOccurrences(of: "T", with: " ")
            if  lastvisit == "1900-01-01 00:00:00"{
                lastvisit = "No Visit"
            }
            if (sign != "3" && isecalate != "true" && lastvisit.prefix(10) != self.getTodaydatetime().prefix(10)){
                sign = "0"
            }
            signarr.append(sign)
            superdealeradapter.append(Retailerlistadapter(customername: customername, lastvisit: lastvisit, cityname: "", sitename: mobile, currmonth: currentmonth, complain: complain, mi: "", customercode: siteid))
        }
        superdealertable.reloadData()
        if superdealeradapter.count == 0 {
            self.nodataview.isHidden = false
        }
        else {
            self.nodataview.isHidden = true
        }
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}
