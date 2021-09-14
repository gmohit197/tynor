//
//  Dashboardvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 25/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
//import Dropdowns
import SQLite3
import Charts
import SwiftEventBus

class Dashboardvc: Executeapi, ChartViewDelegate, IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
    
    var menu : menuvc!
    var trainee: String? = ""
    var trainer: String? = ""
    @IBOutlet weak var primaryspinner: DropDownUtil!
    @IBOutlet weak var detailsview: UIView!
    @IBOutlet weak var dailyresview: UIView!
    @IBOutlet weak var circularview: UIView!
    @IBOutlet weak var orderreportview: UIView!
    @IBOutlet weak var mycustomerview: UIView!
    @IBOutlet weak var teamtrainingview: UIView!
    @IBOutlet weak var myperformanceview: UIView!
    @IBOutlet weak var mytrainingview: UIView!
    @IBOutlet weak var detailstack: UIStackView!
    @IBOutlet weak var traininglable: UILabel!
    @IBOutlet weak var trainerlable: UILabel!
    
    @IBOutlet var primaryspinnertopmargin: NSLayoutConstraint!
    @IBOutlet var trainerlabeltopmargin: NSLayoutConstraint!
    @IBOutlet var traininglabeltopmargin: NSLayoutConstraint!
    @IBOutlet var primaryspinnerheight: NSLayoutConstraint!
    @IBOutlet var traininglabelheight: NSLayoutConstraint!
    @IBOutlet var trainerlabelheight: NSLayoutConstraint!
    @IBOutlet weak var trainerlabelmargin: NSLayoutConstraint!
    @IBOutlet weak var sactualrate: UILabel!
    @IBOutlet weak var pactualrate: UILabel!
    @IBOutlet weak var sreqrate: UILabel!
    @IBOutlet weak var preqrate: UILabel!
    
    var dailyres = "dailyresponsibility"
    var flag = 0;
    var months: [String]! = []
    var ptarget: [Double]! = []
    var pachievement: [Double]! = []
    weak var axisFormatDelegate: IAxisValueFormatter?
    @IBOutlet weak var barChartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    UserDefaults.standard.set(AppDelegate.usercodeLogin, forKey: "usercode")
        print("UserCode=====================================================================")
       
      //  print(UserDefaults.standard.String(forKey: "usercode"))
        
        if UserDefaults.standard.string(forKey: "executeapi") != self.getdate(){
            self.executeapifunc(view: self.view, alert: true)
            
        }
        
        self.setnav(controller: self, title: "Home")

        
        SwiftEventBus.onMainThread(self, name: "refreshdashboard")
        {_ in
           self.showalertdash(controller: self, msg: "Downloaded")
            
        }
        SwiftEventBus.onMainThread(self, name: "startrefesh")
        {_ in
            self.dash()
            self.viewDidLoad()
            
        }
//        if !( UserDefaults.standard.bool(forKey:"synced" )){
//             self.executeapifunc(view: self.view, alert: true)
//        }

        
        
//        self.traininglable.isHidden = true
//        self.trainerlable.isHidden = true
        traininglabelheight.constant=0
        traininglabeltopmargin.constant=0
        trainerlabelheight.constant=0
        trainerlabeltopmargin.constant=0
        
        let usertype:Int =  UserDefaults.standard.integer(forKey: "usertype")
        if usertype == 11 {
            self.hideview(view: teamtrainingview)
        }
        if usertype == 11 || usertype == 12
        {
//            self.hideview(view: primaryspinner)
            primaryspinnerheight.constant=0
            primaryspinnertopmargin.constant=0
            primaryspinner.isHidden = true
        }
        
        primaryspinner.optionArray = []
        getdashspinner()
        getmonth()
        initchart()
        if flag == 0 {
            if primaryspinner.optionArray.count > 0 {
                self.primaryspinner.text = primaryspinner.optionArray[0]
                self.getchartdata(selection: primaryspinner.optionArray[0])
                self.setdetailscard(selection: primaryspinner.optionArray[0])
                self.setChart()
            }
        }
        //        primaryspinner.optionArray = []
        barChartView.delegate = self
        //        getdashspinner()
        //        getmonth()
        //        initchart()
        axisFormatDelegate = self
        
        self.cardview(myview: barChartView)
        
        view.isUserInteractionEnabled = true
        AppDelegate.menubool = true
        menu = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") as! menuvc
        primaryspinner.didSelect { (selection, index, id) in
            self.flag = 1;
            self.getchartdata(selection: selection)
            self.setdetailscard(selection: selection)
            self.setChart()
        }
        let taporder = UITapGestureRecognizer(target: self, action: #selector(clickreport))
        taporder.numberOfTapsRequired=1
        orderreportview.addGestureRecognizer(taporder)
        
        let tapMyCustomer = UITapGestureRecognizer(target: self, action: #selector(clickMyCustomer))
        taporder.numberOfTapsRequired=1
        mycustomerview.addGestureRecognizer(tapMyCustomer)
        
        let dailyres = UITapGestureRecognizer(target: self, action: #selector(clickDailyres))
        dailyres.numberOfTapsRequired=1
        dailyresview.addGestureRecognizer(dailyres)
        
        let tapCircular = UITapGestureRecognizer(target: self, action: #selector(clickCircular))
        tapCircular.numberOfTapsRequired=1
        circularview.addGestureRecognizer(tapCircular)
        
        let tapteamtraining = UITapGestureRecognizer(target: self, action: #selector(clickTeamtraining))
        tapteamtraining.numberOfTapsRequired=1
        teamtrainingview.addGestureRecognizer(tapteamtraining)
        
        let tapmytraining = UITapGestureRecognizer(target: self, action: #selector(clickMytraining))
        tapmytraining.numberOfTapsRequired=1
        mytrainingview.addGestureRecognizer(tapmytraining)
        
        let myperfor = UITapGestureRecognizer(target: self, action: #selector(clickmyperformance))
        myperfor.numberOfTapsRequired=1
        myperformanceview.addGestureRecognizer(myperfor)
        
        let swiperyt = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swiperyt.direction = UISwipeGestureRecognizerDirection.right
        
        let swipelft = UISwipeGestureRecognizer(target: self, action: #selector(self.gesturerecognise))
        swipelft.direction = UISwipeGestureRecognizerDirection.left
        
        self.view.addGestureRecognizer(swiperyt)
        self.view.addGestureRecognizer(swipelft)
        
        //        if flag == 0 {
        //            self.primaryspinner.text = primaryspinner.optionArray[0]
        //            self.getchartdata(selection: primaryspinner.optionArray[0])
        //            self.setdetailscard(selection: primaryspinner.optionArray[0])
        //            self.setChart()
        //        }
        
        hideViews()
        AppDelegate.isDash = true
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.dash()
    }
    
    func dash(){
        checknet()
        if(AppDelegate.ntwrk > 0){
            self.URL_GetTrainingDetailbck()
            self.URL_PROFILEDETAILbck()
        }
        
        SwiftEventBus.onMainThread(self, name: "trainingdone") { Result in
            self.trainerbar()
        }
             
        SwiftEventBus.onMainThread(self, name: "profiledone") { Result in
          self.traineebar()
        }
    }
    
//    9988882283
    @objc func clickreport(){
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        if teamtrainingcheck()
        {
            let report: Orderreportvc = self.storyboard?.instantiateViewController(withIdentifier: "orderreport") as! Orderreportvc
            report.selectedViewController = report.viewControllers![0]
            report.modalPresentationStyle = .fullScreen
            self.present(report, animated: true, completion: nil)
        }
    }
    
    @objc func clickCircular(){
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        if teamtrainingcheck(){
            let circular: Circularvc = self.storyboard?.instantiateViewController(withIdentifier: "circular") as! Circularvc
            self.navigationController?.pushViewController(circular, animated: true)
        }
    }
    
    @objc func clickTeamtraining(){
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        let teamtraining: TeamTrainingvc = self.storyboard?.instantiateViewController(withIdentifier: "teamtraining") as! TeamTrainingvc
        self.navigationController?.pushViewController(teamtraining, animated: true)
    }
    
    @objc func clickMytraining(){
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        guard let url = URL(string: "https://tynor.goplayday.com/view/redirectmobilelink.html?value=tynor/3/")
            else {
                return
        }
        UIApplication.shared.open(url)
        print("MY Training is clicked")
    }
    
    @objc func clickmyperformance(){
        
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        
        if teamtrainingcheck(){
            let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
            let navigationController = MyPerformance(rootViewController: pageController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated:false, completion:nil)
        }
    }
     
    @objc func clickMyCustomer(){
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        if teamtrainingcheck(){
            let mycustomers: MyCustomer = self.storyboard?.instantiateViewController(withIdentifier: "mycustomers") as! MyCustomer
            mycustomers.selectedViewController = mycustomers.viewControllers![0]
            mycustomers.modalPresentationStyle = .fullScreen
            mycustomers.modalTransitionStyle = .coverVertical
            self.present(mycustomers, animated: false, completion: nil)
            
//            self.pushnext(identifier: "mycustomers", controller: self)
        }
    }
    
    
    
    func setdetailscard(selection: String?){
        var stmt1:OpaquePointer?
        let query = "select psalerate ,preqrate, ssalerate , sreqrate from USERTARGETSALERATE where usercode = '" + selection! + "'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let psalerate = String(cString: sqlite3_column_text(stmt1, 0))
            let preqrate = String(cString: sqlite3_column_text(stmt1, 1))
            let ssalerate = String(cString: sqlite3_column_text(stmt1, 2))
            let sreqrate = String(cString: sqlite3_column_text(stmt1, 3))
            
            if psalerate == "" || preqrate == "" || ssalerate == "" || sreqrate == ""
            {
                self.preqrate.text = "  0"
                self.pactualrate.text = "  0"
                self.sreqrate.text = "  0"
                self.sactualrate.text = "  0"
            }
            else {
                self.preqrate.text = "  " + preqrate
                self.pactualrate.text = "  " + psalerate
                self.sreqrate.text =  "  " + sreqrate
                self.sactualrate.text =  "  " +  ssalerate
            }
        }
    }
    
    func setChart() {
        
        barChartView.noDataText = "Please select Chart Data!"
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<self.months.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.ptarget[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.pachievement[i])
            dataEntries1.append(dataEntry1)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Primary Target")
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Primary Achievement")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet1.colors = [UIColor(red: 138/255, green: 17/255, blue: 84/255, alpha: 1)] //8a1154
        chartDataSet.colors = [UIColor(red: 21/255, green: 208/255, blue: 221/255, alpha: 1)] //15d0dd
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = self.months.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
        barChartView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        
        barChartView.notifyDataSetChanged()
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 2
        chartData.setValueFormatter(DefaultValueFormatter(formatter: leftAxisFormatter))
        
        barChartView.data = chartData
        //background color
        barChartView.backgroundColor = UIColor.white
        //chart animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    func initchart(){
        
        barChartView.noDataText = "Chart Data not available!"
        barChartView.chartDescription?.text = "(In ₹ Lacs)"
        
        
        barChartView.chartDescription!.font = UIFont.boldSystemFont(ofSize: (barChartView.chartDescription?.font.pointSize)!)
        /// barChartView.chartDescription?.position = CGPoint(x: 1.0, y: 2.0)
        
        barChartView.extraBottomOffset = 10
        barChartView.isUserInteractionEnabled = false
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let description = barChartView.chartDescription
        description?.xOffset = 10.0
        description?.yOffset = 310.0
        //   description?.position =
        
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xaxis.granularity = 1
        xaxis.wordWrapEnabled = true
        xaxis.enabled = true
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0.0
        yaxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        
    }
    
    func getchartdata(selection: String?){
        
        var stmt1:OpaquePointer?
        let query = "select ptarget, pachivement from UserPrimaryDashboard where usercode = '" + selection! + "' order by tmonth"
        self.ptarget.removeAll()
        self.pachievement.removeAll()
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        print("getchartdata"+query)
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let target = Double(String(cString: sqlite3_column_text(stmt1, 0)))
            let achievement = Double(String(cString: sqlite3_column_text(stmt1, 1)))
            
//            let targetstr = Double(round(100*target!)/100)
            ptarget.append(target!)
            pachievement.append(achievement!)
        }
    }
    
    @objc func gesturerecognise (gesture : UISwipeGestureRecognizer)
    {
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left :
            hidemenu()
            break
            
        case UISwipeGestureRecognizerDirection.right :
            showmenu()
            
            break
            
        default:
            break
        }
    }
    
    @IBAction func sidebtn(_ sender: UIBarButtonItem) {
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        if AppDelegate.menubool{
            showmenu()
            
        }
        else {
            hidemenu()
        }
    }
    
    func showmenu()
    {
        UIView.animate(withDuration: 0.4){ ()->Void in
            
            self.menu.view.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.menu.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.addChildViewController(self.menu)
            self.view.addSubview(self.menu.view)
            //self.navigationController?.edgesForExtendedLayout = []
            AppDelegate.menubool = false
        }
    }
    
    func hidemenu ()
    {
        UIView.animate(withDuration: 0.3, animations: { ()->Void in
            self.menu.view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finished) in
            self.menu.view.removeFromSuperview()
            
        }
        AppDelegate.menubool = true
    }
    
    func getdashspinner() {
        
        print("task in sync ==============> STARTED")
        var stmt1:OpaquePointer?
        let query = "select distinct usercode from UserPrimaryDashboard order by usercode desc"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        //    constant.syncstart.sync{
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let usercode = String(cString: sqlite3_column_text(stmt1, 0))
            primaryspinner.optionArray.append(usercode)
            print("spinner =========> \(primaryspinner.optionArray)")
        }
        //    }
        //    constant.syncstop.sync{
        ////        print("task in sync ==============> STOPED")
        //        if flag == 0 {
        //            self.primaryspinner.text = primaryspinner.optionArray[0]
        //            self.getchartdata(selection: primaryspinner.optionArray[0])
        //            self.setdetailscard(selection: primaryspinner.optionArray[0])
        //            self.setChart()
        //        }
        //    }
        
    }
    
    func getmonth() {
        
        var stmt1:OpaquePointer?
        let query = "select distinct targetmonth from UserPrimaryDashboard order by tmonth"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.months.removeAll()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let month = String(cString: sqlite3_column_text(stmt1, 0))
            self.months.append(month)
        }
    }
    
    func trainerbar()
    {
        var stmt1:OpaquePointer?
        let query = "select traineename from usertrainings"
        var temp: Int64? = 0
        var t: String? = ""
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            t = String(cString: sqlite3_column_text(stmt1, 0))
            if temp! > 0{
            trainee?.append(", "+t!)
            } else {
             trainee = t
            }
            temp! += 1;
        }
        if temp! > 0 {
//            self.traininglable.isHidden = false
            traininglabelheight.constant=30
            traininglabeltopmargin.constant=3
            self.traininglable.text = "You are training " + trainee!
        }
        else{
            traininglabelheight.constant=0
            traininglabeltopmargin.constant=0
//            self.hideview(view: traininglable)
            
        }
    }
    
    func traineebar(){
        
        var stmt1:OpaquePointer?
        let query = "select showtrainbar from ProfileDetail  where istraining='1'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
           trainer = String(cString: sqlite3_column_text(stmt1, 0))
//            self.trainerlable.isHidden = false
            trainerlabelheight.constant=30
            trainerlabeltopmargin.constant=3
            self.trainerlable.text = "You are being trained by " + trainer!
        }
            
        else {
            trainerlabelheight.constant=0
            trainerlabeltopmargin.constant=0
//            self.hideview(view: trainerlable)
        }
    }
    
    @objc func clickDailyres()
    {
        if !( UserDefaults.standard.bool(forKey:"synced" )){
            self.executeapifunc(view: self.view, alert: true)
        }
        if teamtrainingcheck(){
            if attendanceValidation(){
                var attndesc: String?
                attndesc  = self.checkattendance()
                if(!(attndesc=="Day Start" || attndesc=="")){
                    let usertype:Int =  UserDefaults.standard.integer(forKey: "usertype")
                    if usertype == 11{
                        //                        self.performSegue(withIdentifier: "SPO", sender: (Any).self)
                        self.pushnext(identifier: "SPO", controller: self)
                    }
                    else{
                        self.pushnext(identifier: "dailyres", controller: self)
                        //                        self.performSegue(withIdentifier: "DailyResponsibility", sender: (Any).self)
                    }
                }
                else if productDayValidation() {
                    let usertype:Int =  UserDefaults.standard.integer(forKey: "usertype")
                    if usertype == 11{
//                        self.performSegue(withIdentifier: "SPO", sender: (Any).self)
                        self.pushnext(identifier: "SPO", controller: self)
                    }
                    else{
                        self.pushnext(identifier: "dailyres", controller: self)
//                        self.performSegue(withIdentifier: "DailyResponsibility", sender: (Any).self)
                    }
                }
            }
        }
    }
    
    func productDayValidation() -> Bool
    {
        var stmt1: OpaquePointer?
        let query = "select 1 _id,B.rowid,*,case when isapprove='0' then 'PENDING' else 'APPROVED' end as status  from ProductDay B join ( select distinct itemname,itemgroup , itemgroupid from ItemMaster ) A on A.itemgroupid = B.itemgroupid where B.isdate like '\(self.getdate())%' and isapprove<>'0' "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        var count:Int! = 0
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            count = count + 1
        }
        if count < 5  {
//            self.performSegue(withIdentifier: "product", sender: (Any).self)
            self.pushnext(identifier: "productday", controller: self)
            return false
        }
        return true
    }
    
    func hideViews(){
        if constant.onlyhidden {
            self.hideview(view: circularview)
            self.hideview(view: mycustomerview)
            self.hideview(view: teamtrainingview)
            self.hideview(view: myperformanceview)
            self.hideview(view: mytrainingview)
            
            let usertype:Int =  UserDefaults.standard.integer(forKey: "usertype")
            if usertype == 11 {
                self.hideview(view: dailyresview )
                self.hideview(view: orderreportview)
            }
        }
    }
}

