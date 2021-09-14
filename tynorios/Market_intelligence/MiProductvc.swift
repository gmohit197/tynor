//  MiProductvc.swift
//  tynorios
//  Created by Acxiom Consulting on 02/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.

//MARK:- IMPORTS
import UIKit
import SQLite3
import SwiftEventBus

//MARK:- BEGINNING
class MiProductvc: Executeapi, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var rootview: UIView!
    var controller:PncBottomSheet?
    var BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var BlurEffectView = UIVisualEffectView()
    
    //MARK:- TABLE VIEW
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
        if list.preindex == "0"
        {
            cell.colorlbl.isHidden = false
            cell.colorlbl.backgroundColor = UIColor(red: 138.0 / 255.0, green: 17.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
        }
        else if list.preindex == "1"
        {
            if list.ispreffered == "true"
            {
                cell.colorlbl.isHidden = false
                cell.colorlbl.backgroundColor = UIColor(red: 21.0 / 255.0, green: 208.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
            }
            else{
                cell.colorlbl.isHidden = true
            }
        }
        else if list.preindex == "2"{
            cell.colorlbl.isHidden = false
            cell.colorlbl.backgroundColor = UIColor(red: 255.0 / 255.0, green: 118.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
        }
        else{
            cell.colorlbl.isHidden = true
        }
        return cell
    }
    //MARK:- SEARCHVIEWCONTROLLER
    private func makeSearchViewControllerIfNeeded() -> PncBottomSheet {
        let currentPullUpController = childViewControllers
            .filter({ $0 is PncBottomSheet })
            .first as? PncBottomSheet
        let pullUpController: PncBottomSheet = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "pncbottom") as! PncBottomSheet
        return pullUpController
    }
    
    var competitoradapter = [competitorcelladapter]()
    @IBOutlet weak var competitortable: UITableView!
    @IBOutlet weak var nxtbtn: UIButton!
    @IBOutlet var noproductView: UIView!
    @IBOutlet var productHeder: UILabel!
    var custcode = ""
    
    //MARK:-VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settable()
        self.competitortable.tableFooterView = UIView()
        competitortable.delegate = self
        competitortable.dataSource = self
        if(AppDelegate.isDebug){
            print("MiProductVcTitletext===\(AppDelegate.titletxt)")            
        }
        if AppDelegate.titletxt == "Doctor" || AppDelegate.titletxt == "Hospital"
        {
            if(AppDelegate.chemistcheck && AppDelegate.isDocScreen){
                self.nxtbtn.setTitle("Save", for: .normal)
            }
           else if(!(AppDelegate.chemistcheck)){
                self.nxtbtn.setTitle("Save", for: .normal)
            }
        }
        if (AppDelegate.titletxt == "Doctor" && AppDelegate.isDocScreen == true) {
            if(AppDelegate.isChemist){
                AppDelegate.chemcustcode = AppDelegate.doccustomercode
            }
            else{
                AppDelegate.customercode = AppDelegate.doccustomercode
            }
        }
        else if (AppDelegate.titletxt == "Hospital" && AppDelegate.isHosScreen == true ){
            AppDelegate.customercode = AppDelegate.hoscustomercode
            AppDelegate.customercode = gethoscust(hoscode: AppDelegate.hoscode)
        }
        else if(AppDelegate.isRetScreen == true && AppDelegate.isFromRetailerScreen == true){
            AppDelegate.customercode = AppDelegate.retcustomercode
        }
        self.updateprog()
    }
    //MARK:- HOSCUSTOMERCODE
    func gethoscust(hoscode: String?)->String{
        var stmt1:OpaquePointer?
        var cust = ""
        let query = "select custrefcode from HospitalMaster where hoscode = '\(hoscode!)'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            cust = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return cust
    }
    
    //MARK:- INTENT TO LIST
    override func viewWillAppear(_ animated: Bool) {
        self.settable()
        self.updateprog()
        SwiftEventBus.onMainThread(self, name: "retailerdataposted") { Result in
            if(AppDelegate.isPosted == 0 && AppDelegate.isFromMiStock == false){
                AppDelegate.isPosted = 1
                self.hideloader()
                self.showOkalert(controller: self)
            }
        }
    }
    
    func showOkalert(controller: UIViewController){
        let alert = UIAlertController(title: "Alert", message: "Data Posted Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            if(AppDelegate.titletxt == "Hospital"){
                vc.titlebar = "Hospital"
            }
            else if (AppDelegate.titletxt == "Doctor"){
                vc.titlebar = "Doctor"
            }
//            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        present(alert, animated: true)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self, name: "retailerdataposted")
        SwiftEventBus.unregister(self, name: "retailerdatapostedNew")
    }
    
    //MARK:- UPDATE PROG
    func updateprog(){
        if(AppDelegate.isChemist){
            self.productHeder.text = "Product and Competitor" + "(\(Int(getcompetitor(customercode: AppDelegate.chemcustcode)))%)"
        }
        else {
            self.productHeder.text = "Product and Competitor" + "(\(Int(getcompetitor(customercode: AppDelegate.customercode)))%)"
        }
    }
    //MARK:- SET TABLE
    func settable(){
        var stmt:OpaquePointer?
        var sno = 0;
        self.competitoradapter.removeAll()
        var  query = ""
        if(AppDelegate.isChemist){
            query = "select 1 _id,B.rowid,case when A.compititorname = 'OTHER' COLLATE NOCASE then B.brandname else A.compititorname end as compititorname,A.itemname,B.ispreffered,B.qty,cast (B.preffindex as INT) as preffindex from COMPETITORDETAIL A \n INNER JOIN COMPETITORDETAILPOST B ON A.itemid = B.itemid where B.CUSTOMERCODE='\(AppDelegate.chemcustcode)'AND B.isblocked= 'false'  order by preffindex,compititorname"
        }
        else {
            query = "select 1 _id,B.rowid,case when A.compititorname = 'OTHER' COLLATE NOCASE then B.brandname else A.compititorname end as compititorname,A.itemname,B.ispreffered,B.qty,cast (B.preffindex as INT) as preffindex from COMPETITORDETAIL A \n INNER JOIN COMPETITORDETAILPOST B ON A.itemid = B.itemid where B.CUSTOMERCODE='\(AppDelegate.customercode)'AND B.isblocked= 'false'  order by preffindex,compititorname"
        }
        if(AppDelegate.isDebug){
            print("MiProductvc=="+query)
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var compname=""
        var itemname=""
        var qty=""
        var ispreffered=""
        var preindex=""
        while(sqlite3_step(stmt) == SQLITE_ROW){
            compname = String(cString: sqlite3_column_text(stmt, 2))
            itemname = String(cString: sqlite3_column_text(stmt, 3))
            qty = String(sqlite3_column_int64(stmt, 5))
            ispreffered = String(cString: sqlite3_column_text(stmt, 4))
            preindex = String(sqlite3_column_int64(stmt, 6))
            sno = sno + 1;
            self.competitoradapter.append(competitorcelladapter(sno: String(sno), qty: qty, product: itemname, brand: compname, ispreffered: ispreffered,preindex: preindex))
        }
        self.competitortable.reloadData()
        if competitoradapter.count == 0 {
            view.bringSubview(toFront: noproductView)
        }
        else{
            view.sendSubview(toBack: noproductView)
        }
    }
    //MARK:- ADD PRODUCT BTN
    @IBAction func addproductbtn(_ sender: Any) {
        var a=[UIView]()
        a = view.window!.subviews
        BlurView(view:view.window!.subviews[a.count - 1])
        controller = storyboard!.instantiateViewController(withIdentifier: "pncbottom") as? PncBottomSheet
        let screenSize = UIScreen.main.bounds.size
        self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
        UIApplication.shared.keyWindow!.addSubview(self.controller!.view)
        controller?.btnClose.addTarget(self, action: #selector(hidesheet), for: .touchUpInside)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            self.controller!.view.frame  = CGRect(x: 0, y: screenSize.height - self.view.frame.height + 10, width: screenSize.width, height:  self.view.frame.height)
        }, completion: nil)
        let tapblurview = UITapGestureRecognizer(target: self, action: #selector(hidesheet))
        tapblurview.numberOfTapsRequired = 1
        AppDelegate.blureffectview.addGestureRecognizer(tapblurview)
    }
    //MARK:- HIDE SHEET
    @objc func hidesheet(){
        print("tappedd")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.controller!.view.frame  = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
        })
        { (finished) in
            self.controller!.willMove(toParentViewController: nil)
            self.controller!.view.removeFromSuperview()
            self.controller!.removeFromParentViewController()
        }
        self.settable()
        self.updateprog()
        AppDelegate.blureffectview.removeFromSuperview()
    }
    //MARK:-BLUR VIEW
    func BlurView(view: UIView) {
        BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        BlurEffectView = UIVisualEffectView(effect: BlurEffect)
        BlurEffectView.backgroundColor = UIColor.lightGray
        BlurEffectView.alpha = 0.2
        BlurEffectView.frame = view.bounds
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.addSubview(BlurEffectView)
        AppDelegate.blureffectview=BlurEffectView
        view.addSubview(AppDelegate.blureffectview)
    }
    //MARK:- NEXTBTN
    @IBAction func nextbtn(_ sender: Any) {
        if( AppDelegate.titletxt == "Doctor" && !(AppDelegate.chemistcheck)  && self.nxtbtn.titleLabel?.text == "Save" )
        {
            if(AppDelegate.popviewcontrolllercheck || AppDelegate.isFromCustomerCardList){
                if(AppDelegate.isFromRetailerScreen){
                    AppDelegate.customercode = AppDelegate.retcustomercode
                }
                AppDelegate.isDocScreen = false
                AppDelegate.isHosScreen = false
                AppDelegate.isRetScreen = true
                if(AppDelegate.isFromHospitalScreen){
                    AppDelegate.titletxt = "Hospital"
                    AppDelegate.customercode = AppDelegate.hoscustomercode
                    AppDelegate.hoscode = AppDelegate.oldhoscode
                }
                else{
                    AppDelegate.titletxt = "Retailer"
                }
               self.navigationController?.popViewController(animated: true)
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
                vc.titlebar = "Doctor"
                if AppDelegate.ntwrk > 0 {
                    self.showloader(title: "Syncing")
                    AppDelegate.isPosted = 0
                    AppDelegate.isFromMiStock = false
                    self.posthospitalMaster()
                }
                else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else if (AppDelegate.titletxt == "Hospital"  && !(AppDelegate.chemistcheck)   && self.nxtbtn.titleLabel?.text == "Save" )
        {
            if(AppDelegate.popviewcontrolllercheck || AppDelegate.isFromCustomerCardList){
                self.navigationController?.popViewController(animated: true)
            }
            else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
                vc.titlebar = "Hospital"
                if AppDelegate.ntwrk > 0 {
                    self.showloader(title: "Syncing")
                    AppDelegate.isPosted = 0
                    AppDelegate.isFromMiStock = false
                    self.posthospitalMaster()
                }
                else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else if (AppDelegate.isChemist && self.nxtbtn.titleLabel?.text == "Save"){
            if(AppDelegate.isDocScreen){
                AppDelegate.isDocScreen = false
                AppDelegate.isHosScreen = false
                AppDelegate.chemcustcode = AppDelegate.oldChemcustomercode
                AppDelegate.source = "3"
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
           // SwiftEventBus.unregister(self)
            SwiftEventBus.post("gotodoctor")
        }
        SwiftEventBus.post("updateprogress")
    }
}
