//
//  TeamTrainingvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 23/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class TeamTrainingvc: Executeapi,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traineeadapter.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Teamtrainingcell
        
        let list: Teamtrainingadapter
        list = traineeadapter[indexPath.row]
        
        if list.status == "p"{
            cell.endbtn.isHidden = false
            cell.startbtn.isHidden = true
            cell.donebtn.isHidden = true
        }
        else if list.status == "d"{
            cell.endbtn.isHidden = true
            cell.startbtn.isHidden = true
            cell.donebtn.isHidden = false
        }
        else if list.status == "s"{
            cell.endbtn.isHidden = true
            cell.startbtn.isHidden = false
            cell.donebtn.isHidden = true
        }
        
        cell.traineename.text = list.empname
        cell.trainingid = list.trainingid
        cell.status = list.status
        cell.usercode = list.usercode
        cell.controller = self
        
        return cell
    }
    
    var traineeadapter = [Teamtrainingadapter]()
    
    @IBOutlet weak var teamtrainingtable: UITableView!  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Team Training")
        setdetail()
        SwiftEventBus.onMainThread(self, name: "trainingdone") { Result in
            self.setdetail()
        }
        SwiftEventBus.onMainThread(self, name: "trainingdonenot") { Result in
            self.showtoast(controller: self, message: "Data not Downloaded...", seconds: 1.5)
        }
        SwiftEventBus.onMainThread(self, name: "startpost") { Result in
            self.URL_GetTrainingDetailbck()
        }
        SwiftEventBus.onMainThread(self, name: "startpostnot") { Result in
            self.showtoast(controller: self, message: "Data not Uploaded...", seconds: 1.5)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setdetail), name: NSNotification.Name(rawValue: constant.key), object: nil)
    }
    
    @objc func setdetail()
    {
        traineeadapter.removeAll()
        var stmt1: OpaquePointer?
        let query = "select 1 as _id,A.rowid,A.empname,A.usercode,B.TRAININGID ,case when (B.status = '1' and B.TRAININGENDTIME like '"+getdate()+"%') then 'd' when (B.status = '0') then 'p' else 's' end as status from USERHIERARCHY A join TrainingDetail B on B.TRAINEDTO =A.usercode where A.usertype<>'"+AppDelegate.usertype+"' ORDER BY A.usertype"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let empname = String(cString: sqlite3_column_text(stmt1, 2))
            let usercode = String(cString: sqlite3_column_text(stmt1, 3))
            let trainingid = String(cString: sqlite3_column_text(stmt1, 4))
            let status = String(cString: sqlite3_column_text(stmt1, 5))
            
            self.traineeadapter.append(Teamtrainingadapter(empname: empname, trainingid: trainingid, status: status, usercode: usercode))
            
        }
        teamtrainingtable.reloadData()
    }
    
    @IBAction func backbtn(_ sender: Any) {
        
        let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
        
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
}
