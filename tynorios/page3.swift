//
//  page3.swift
//  tynorios
//
//  Created by Acxiom Consulting on 03/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import Charts

class page3: UIViewController {

    
    @IBOutlet weak var nochartdata: UILabel!
    @IBOutlet weak var piechart: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        nochartdata.isHidden = true
        setchart()
    }
   // var total = PieChartDataEntry(value: 1.85)
    
    var tpositive = PieChartDataEntry(value: 0.16)
    var tnegative = PieChartDataEntry(value: 0.03)
    
    func setchart()
    {
        var stmt1:OpaquePointer?
        var flag = 0
        let query = "select (select count(*) from RetailerMaster where keycustomer = 'true' and isblocked = 'false') tynorp,(select count(*) from RetailerMaster where keycustomer ='false' and isblocked = 'false') tynorn,(select count(*) from RetailerMaster where isblocked = 'false') total"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            flag += 1
//            total.value = Double(String(cString: sqlite3_column_text(stmt1, 2))) ?? 0
//            total.label = "Total Customer"
            tpositive.value =  Double(String(sqlite3_column_int64(stmt1, 0))) ?? 0
            tpositive.label = "Tynor+"
            tnegative.value =  Double(String(sqlite3_column_int64(stmt1, 1))) ?? 0
            tnegative.label = "Tynor-"
        }
        
        if flag == 0 {
            nochartdata.isHidden = false
        }
        
      //  let tynorcust = UIColor(red: 0.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
        let tynorpos = UIColor(red: 138 / 255.0, green: 17 / 255.0, blue: 84 / 255.0, alpha: 1.0)
        let tynoyneg = UIColor(red: 32 / 255.0, green: 173 / 255.0, blue: 183 / 255.0, alpha: 1.0)
        let arr = [tpositive,tnegative]
        print(arr)
        let pieChartDataSet = PieChartDataSet(values: arr, label: "")
        pieChartDataSet.colors = [tynorpos,tynoyneg]
        piechart.radius.advanced(by: 30)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        print(pieChartData)
        piechart.data = pieChartData
        piechart.centerText = ""
        piechart.chartDescription?.text = ""
        piechart.usePercentValuesEnabled = false
        piechart.drawHoleEnabled = false
        piechart.legend.orientation = .vertical
        piechart.legend.horizontalAlignment = .left
        piechart.drawEntryLabelsEnabled = false
    }
}
