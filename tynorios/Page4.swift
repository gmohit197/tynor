//
//  Page4.swift
//  tynorios
//
//  Created by Acxiom Consulting on 01/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Charts
import SQLite3

class Page4: UIViewController {

    @IBOutlet weak var nochartdata: UILabel!
    @IBOutlet weak var piechart: PieChartView!
    var dataentry:[PieChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nochartdata.isHidden = true
        setchart()
    }
    
    func setchart()
    {
        var stmt1:OpaquePointer?
        var flag = 0
        let query = "select reasondescription,noofcount from UserNoOrderPerformance"
        dataentry.removeAll()
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var color: [UIColor] = []
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            flag += 1
            let pieDataEntry: PieChartDataEntry = PieChartDataEntry(value: 0)
            pieDataEntry.value = Double(String(cString: sqlite3_column_text(stmt1, 1))) ?? 0
            pieDataEntry.label = String(cString: sqlite3_column_text(stmt1, 0))
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let newcolor = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            color.append(newcolor)
           dataentry.append(pieDataEntry)
        }
        
        if flag == 0 {
            nochartdata.isHidden = false
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataentry, label: "")
        pieChartDataSet.colors = color
        piechart.radius.advanced(by: 30)
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 0
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: leftAxisFormatter))

        piechart.data = pieChartData
        piechart.centerText = ""
        piechart.chartDescription?.text = ""
        piechart.usePercentValuesEnabled = false
        piechart.drawHoleEnabled = false
        piechart.legend.orientation = .vertical
        piechart.legend.horizontalAlignment = .left
        piechart.legend.verticalAlignment = .bottom
        piechart.drawEntryLabelsEnabled = false
    }
}
