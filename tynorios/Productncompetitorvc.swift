//
//  Productncompetitorvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 22/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3

class Productncompetitorvc: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitoradapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Competitorcell
        let list: competitorcelladapter
        list = competitoradapter[indexPath.row]
        
        cell.sno.text = list.sno
        cell.brand.text = list.brand
        cell.qty.text = list.qty
        cell.product.text = list.product
        
        return cell
    }
    
    private func makeSearchViewControllerIfNeeded() -> PncBottomSheet {
        let currentPullUpController = childViewControllers
            .filter({ $0 is PncBottomSheet })
            .first as? PncBottomSheet
        let pullUpController: PncBottomSheet = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "pncbottom") as! PncBottomSheet
        
        return pullUpController
    }
    var competitoradapter = [competitorcelladapter]()
    @IBOutlet weak var competitortable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        settable()
    }
    
    func settable(){
        var stmt:OpaquePointer?
        var sno = 0;
        let query = "select 1 _id,B.rowid,case when A.compititorname = 'OTHER' COLLATE NOCASE then B.brandname else A.compititorname end as compititorname,A.itemname,B.ispreffered,B.qty,B.preffindex from COMPETITORDETAIL A \n INNER JOIN COMPETITORDETAILPOST B ON A.itemid = B.itemid where B.CUSTOMERCODE='\(AppDelegate.customercode)' order by preffindex,compititorname"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let compname = String(cString: sqlite3_column_text(stmt, 2))
            let itemname = String(cString: sqlite3_column_text(stmt, 3))
            let qty = String(cString: sqlite3_column_text(stmt, 5))
            sno = sno + 1;
            self.competitoradapter.append(competitorcelladapter(sno: String(sno), qty: qty, product: itemname, brand: compname, ispreffered: "", preindex: ""))
        }
    }
//    private func addPullUpController() {
//        let pullUpController = makeSearchViewControllerIfNeeded()
//        _ = pullUpController.view // call pullUpController.viewDidLoad()
//
//        addPullUpController(pullUpController,initialStickyPointOffset: pullUpController.initialPointOffset,animated: true)
//    }

    @IBAction func addproductbtn(_ sender: Any) {
//      addPullUpController()
    }
    
}
