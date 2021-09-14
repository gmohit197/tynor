//
//  PendingEscalation.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.


import UIKit
import SQLite3
import SwiftEventBus

class PendingEscalation: Executeapi, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingescalationadapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PendingEscalationcell
        
        let list: PendingEscalationadapter
        
        list = pendingescalationadapter[indexPath.row]
        
        list.date?.removeLast(9)
        cell.name.text = list.name
        cell.type.text = list.type
        cell.escalatedby.text = list.escalatedby
        cell.date.text = list.date
        
        return cell
    }
    
    
    @IBOutlet weak var escalationtable: UITableView!
    var pendingescalationadapter = [PendingEscalationadapter]()
    var escalatioarr: [String]!
    
    
    @IBOutlet weak var spinr: DropDownUtil!
    
    var spinrvalues: [String]! = ["Retailer","Sub Dealer","Doctor","Hospital","Super Dealer"]
    var customertype: [String]! = ["CG0001","CG0004","CG0003","CG0005","CG0002"]
    static var ispendingescalated = false
    var siteidarr: [String]!
    var customercodearr: [String]!
    var pricegrouparr: [String]!
    var stateidarr : [String]!
    var plantcodearr: [String]!
    var plantstateidarr: [String]!
 
    var titlebar: String!
    var CustomertypeNew = ""
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Escalation")
        siteidarr = []
        customercodearr = []
        stateidarr = []
        pricegrouparr = []
        escalatioarr = []
        plantcodearr = []
        plantstateidarr = []
        self.titlebar = self.navigationItem.title!
        let tapeno = UITapGestureRecognizer(target: self, action: #selector(passescalation))
        tapeno.numberOfTapsRequired=1
        tapeno.delegate = self as? UIGestureRecognizerDelegate
        self.escalationtable.addGestureRecognizer(tapeno)
        
        if UserDefaults.standard.string(forKey: "usertype") == "15" {
            spinrvalues.append("Super Dealer")
        }
        if(AppDelegate.spinnetextPE == ""){
            self.spinr.text = self.spinrvalues[0]
        }
        else{
            self.spinr.text = AppDelegate.spinnetextPE
        }
        self.checknet()
        if AppDelegate.ntwrk > 0 {
          DispatchQueue.global(qos: .userInitiated).async {
          self.getPendingEscalation()
        }
        }
        if(!(AppDelegate.customerTypePE == "")){
            setlist(customertype: AppDelegate.customerTypePE)
         }
        else {
            setlist(customertype: self.customertype[0])
        }
        
        
        spinr.didSelect { (selected, index, id) in
            self.setlist(customertype: self.customertype[index])
             self.isListEmpty()
           // AppDelegate.customerTypeIndex = String(self.customertype[index])
            self.CustomertypeNew = self.customertype[index]
            AppDelegate.spinnetextPE = self.spinrvalues[index]
            print("SpinnerText==="+AppDelegate.spinnetextPE)
        }
        for spinrvalue in spinrvalues{
            spinr.optionArray.append(spinrvalue)
    }
  }
    
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.pendingEscalationCustomerName = ""
            SwiftEventBus.onMainThread(self, name: "gotescalaltion") { Result in
                if(!(AppDelegate.customerTypePE == "")){
                    self.setlist(customertype: AppDelegate.customerTypePE)
                 }
                else {
                    self.setlist(customertype: self.customertype[0])
                }
//                self.setlist(customertype: self.customertype[0])
             }
       }
    
    @objc func passescalation(_ gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.escalationtable)
        
        if let indexPath = escalationtable.indexPathForRow(at: touchPoint) {
            let index = indexPath.row
            print("\n \(self.escalatioarr[index])")
            print("\n \(self.customercodearr[index])")
            print("\n \(self.siteidarr[index])")
            print("\n \(self.stateidarr[index])")
            print("\n \(self.pricegrouparr[index])")
       //     print("\n \(self.plantcodearr[index])")
            
            let customercard: CustomerCard = self.storyboard?.instantiateViewController(withIdentifier: "addretailer") as! CustomerCard
            
            
            if( self.CustomertypeNew  == "CG0002"){
                CustomerCard.plantcode = self.plantcodearr[index]
                CustomerCard.plantstateid = self.plantstateidarr[index]
            }
            
            customercard.customercode = self.customercodearr[index]
            CustomerCard.siteid = self.siteidarr[index]
            AppDelegate.siteid = self.siteidarr[index]
            customercard.pricegroup = self.pricegrouparr[index]
            customercard.titletxt = self.titlebar
            CustomerCard.stateid = self.stateidarr[index]
            
            
            customercard.isescalated = ""
            customercard.customername = self.escalatioarr[index]
            AppDelegate.pendingEscalationCustomerName = self.escalatioarr[index]
            customercard.backscreen = "TM"
            AppDelegate.backscreenDel="TM"
            PendingEscalation.ispendingescalated = true
            
            if isescalated(customercode: self.customercodearr[index])
            {
             self.navigationController?.pushViewController(customercard, animated: true)
            }
            
        }
    }
    
    func isListEmpty(){
           if pendingescalationadapter.count == 0
           {
             self.showtoast(controller: self, message: "No Escalations", seconds: 1.0)
           }
           else {
               
           }
       }
    
    func setlist(customertype: String!)
    {
        escalatioarr.removeAll()
        pendingescalationadapter.removeAll()
        var stmt1: OpaquePointer?
        var flag = 0;
        
        var query = "select distinct 1 _id,C.customername,B.reasondescription as reasondescription,D.empname as createdby,A.date as date,A.customercode as customercode,A.siteid as siteid, C.pricegroup as pricegroup,C.stateid as stateid from MarketEscalationActivity A left outer join EscalationReason B on A.reason = B.reasoncode left join RetailerMaster C on A.customercode= C.customercode  inner join USERHIERARCHY D on A.createdby = D.usercode where C.customertype='\(customertype!)' and A.siteid <>''";
        
        if(customertype == "CG0002"){
            query = "select distinct 1 _id ,C.sitename as customername,B.reasondescription as reasondescription,A.createdby as createdby,A.date as date,C.siteid as customercode,C.siteid as siteid,C.pricegroup as pricegroup,C.stateid as stateid,C.plantstateid as referencecode,C.plantcode as plantcode,D.empname as empname from MarketEscalationActivity A left outer join EscalationReason B on A.reason = B.reasoncode inner join USERDISTRIBUTOR C on A.customercode= C.siteid inner join USERHIERARCHY D on A.createdby = D.usercode and A.siteid <>''";
        }
        AppDelegate.customerTypePE = customertype
        
        print(query)
        

        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        self.customercodearr.removeAll()
        self.siteidarr.removeAll()
        self.stateidarr.removeAll()
        self.pricegrouparr.removeAll()

        if(customertype == "CG0002")
        {
            self.plantcodearr.removeAll()
        }

            while(sqlite3_step(stmt1) == SQLITE_ROW){
                flag = flag+1;
                let name = String(cString: sqlite3_column_text(stmt1, 1))
                let type = String(cString: sqlite3_column_text(stmt1, 2))
                let escalatedby = String(cString: sqlite3_column_text(stmt1, 3))
                let date = String(cString: sqlite3_column_text(stmt1, 4))
                let customercode = String(cString: sqlite3_column_text(stmt1, 5))
                let siteid = String(cString: sqlite3_column_text(stmt1, 6))
                let pricegroup = String(cString: sqlite3_column_text(stmt1, 7))
                let stateid = String(cString: sqlite3_column_text(stmt1, 8))

                if(customertype == "CG0002")
                {
                 let plantcode = String(cString: sqlite3_column_text(stmt1, 10))
                 let plantstateid = String(cString: sqlite3_column_text(stmt1, 9))
                 self.plantcodearr.append(plantcode)
                 self.plantstateidarr.append(plantstateid)
                }
                
                self.customercodearr.append(customercode)
                self.siteidarr.append(siteid)
                self.stateidarr.append(stateid)
                self.pricegrouparr.append(pricegroup)
                self.escalatioarr.append(name)
                
                self.pendingescalationadapter.append(PendingEscalationadapter(name: name, type: type, escalatedby: escalatedby, date: date))
            }
            escalationtable.reloadData()
           
 
         }
    

    @IBAction func backbtn(_ sender: Any) {
        let teammanagement: TeamManegement = self.storyboard?.instantiateViewController(withIdentifier: "teammanagement") as! TeamManegement
        self.navigationController?.pushViewController(teammanagement, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
    
}



