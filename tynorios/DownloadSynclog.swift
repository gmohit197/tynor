//
//  DownloadSynclog.swift
//  tynorios
//
//  Created by Acxiom Consulting on 16/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3

class DownloadSynclog: Executeapi,UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadsyncadaptr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Downloadsynclogcell
        
        let list: DownloadSyncadapter
        list = downloadsyncadaptr[indexPath.row]
        
        cell.keylbl.text = list.key
        cell.datetimelbl.text = list.datetime
        
        if (list.status?.contains("success"))!{
            cell.uploadimg.image = UIImage(named: "downloaded")
        }else{
            cell.uploadimg.image = UIImage(named: "warning")
        }
        return cell
    }
    
    var downloadsyncadaptr = [DownloadSyncadapter]()
    
    @IBOutlet weak var downloadsyntable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Sync Log")
        downloadsyntable.delegate = self
        downloadsyntable.dataSource = self
        downloadsyntable.tableFooterView = UIView()
        
        setdetail()
    }

    func setdetail()
    {
        downloadsyncadaptr.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "select methodname,syncdatetime,logstat from initiallog"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let methodname = String(cString: sqlite3_column_text(stmt1, 0))
            let datetime = String(cString: sqlite3_column_text(stmt1, 1))
            let status = String(cString: sqlite3_column_text(stmt1, 2))
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm:ss"
            var goodDate = ""
            if let date = dateFormatterGet.date(from: datetime) {
                print(dateFormatterPrint.string(from: date))
                goodDate = dateFormatterPrint.string(from: date)
            }
            downloadsyncadaptr.append(DownloadSyncadapter(key: methodname, datetime: goodDate, status: status, pending: ""))
        }
        downloadsyntable.reloadData()
    }
    
  
    @IBAction func backbtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.gotohome()
      //  dismiss(animated: true, completion: nil)
    }
}
