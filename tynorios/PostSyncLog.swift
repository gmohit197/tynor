//
//  PostSyncLog.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3

class PostSyncLog: Executeapi,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadsyncadaptr.count

    }
    var count = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UploadSyncLogcell
        
        let list: DownloadSyncadapter
        list = downloadsyncadaptr[indexPath.row]
        
        cell.id.text = list.key
        cell.datelbl.text = list.datetime
        cell.pendinglbl.text = list.pending
        
        if Int(list.pending!)! <= 0 {
            cell.imagelbl.image = UIImage(named: "outbox")
        }
        else
        {
            cell.imagelbl.image = UIImage(named: "warning")
        }
        return cell
    }
    
    var downloadsyncadaptr = [DownloadSyncadapter]()

    @IBOutlet weak var tblview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "Sync Log")
        tblview.delegate = self
        tblview.dataSource = self
        tblview.tableFooterView = UIView()
        setdetail()
    }

    func setdetail()
    {
        downloadsyncadaptr.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "select logid,syncdate,logstat,tablename from userlog"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let methodname = String(cString: sqlite3_column_text(stmt1, 0))
            let datetime = String(cString: sqlite3_column_text(stmt1, 1))
            let status = String(cString: sqlite3_column_text(stmt1, 2))
            let tablename = String(cString: sqlite3_column_text(stmt1, 3))
            count = 0
            self.pendingvalue(tablename: tablename)
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm:ss"
            var goodDate = ""
            if let date = dateFormatterGet.date(from: datetime) {
                print(dateFormatterPrint.string(from: date))
                goodDate = dateFormatterPrint.string(from: date)
            }
            
            downloadsyncadaptr.append(DownloadSyncadapter(key: methodname, datetime: goodDate, status: status, pending: "\(count)"))
        }
        tblview.reloadData()
    }
    
    func pendingvalue(tablename: String?)
    {
        var stmt1: OpaquePointer?
        let query = "select * from \(tablename!) where post = '0'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
            while(sqlite3_step(stmt1) == SQLITE_ROW){
            self.count+=1
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.gotohome()
//        dismiss(animated: true, completion: nil)
    }
}
