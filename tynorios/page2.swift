//
//  page1.swift
//  tynorios
//
//  Created by Acxiom Consulting on 01/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import Charts
import SQLite3
class page2: UIViewController, ChartViewDelegate, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return users[Int(value)]
    }

    @IBOutlet weak var barchart: BarChartView!
    var users:[String] = []
    var starget:[Double] = []
    var sachievement:[Double] = []
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        axisFormatDelegate = self
        barchart.delegate = self
        
        getchartdata()
        initchart()
        setChart()
    }
    
    
    func setChart() {
        barchart.noDataText = "Please select Chart Data!"
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<self.users.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.starget[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.sachievement[i])
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Secondary Target")
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Secondary Achievement")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet1.colors = [UIColor(red: 247/255, green: 168/255, blue: 62/255, alpha: 1)]
        chartDataSet.colors =  [UIColor(red: 31/255, green: 137/255, blue: 255/255, alpha: 1)]
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = self.users.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
        barchart.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barchart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barchart.notifyDataSetChanged()
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 2
        chartData.setValueFormatter(DefaultValueFormatter(formatter: leftAxisFormatter))
        
        barchart.data = chartData
        
        //background color
        barchart.backgroundColor = UIColor.white
        
        //chart animation
        barchart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
    }
    func initchart(){
        
        barchart.noDataText = "Chart Data not available!"
        barchart.chartDescription?.text = "(In ₹ Lacs)"
        barchart.chartDescription!.font = UIFont.boldSystemFont(ofSize: (barchart.chartDescription?.font.pointSize)!)
        barchart.extraBottomOffset = 10
        barchart.isUserInteractionEnabled = false
        //legend
        let legend = barchart.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        let description = barchart.chartDescription
        description?.xOffset = 10.0
        description?.yOffset = 265.0
        
        let xaxis = barchart.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.users)
        xaxis.granularity = 1
        xaxis.wordWrapEnabled = true
        xaxis.enabled = true
        
        let yaxis = barchart.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        barchart.rightAxis.enabled = false
        
    }
    
    func getchartdata(){
        var stmt1:OpaquePointer?
        let query = "select usercode,starget,sachivement from USERMYPERFORMANCE"
        self.starget.removeAll()
        self.sachievement.removeAll()
        self.users.removeAll()
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let target = Double(String(cString: sqlite3_column_text(stmt1, 1)))
            let achievement = Double(String(cString: sqlite3_column_text(stmt1, 2)))
            let user = String(cString: sqlite3_column_text(stmt1, 0))
            starget.append(target!)
            sachievement.append(achievement!)
            users.append(user)
        }
    }
}
