//
//  PncBottomSheet.swift
//  tynorios
//
//  Created by Acxiom Consulting on 03/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SkyFloatingLabelTextField
import SwiftEventBus

class PncBottomSheet: UIViewController,UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
    
    public var portraitSize: CGSize = .zero
    @IBOutlet weak var productbrandspinr: DropDownUtil!
    @IBOutlet weak var reasonspinr: DropDownUtil!
    @IBOutlet weak var productnamespinr: DropDownUtil!
    @IBOutlet weak var prefbutton: UIButton!
    @IBOutlet var prebuttonHeight: NSLayoutConstraint!
    
    var index: String?
    var isprefered: Bool?
    var reasonid: String? = ""
    var compititorid: String?
    var reasonidarr: [String] = []
    var compititoridarr: [String] = []
    var itemid: String?
    var itemidarr: [String] = []
    var custcode = ""
    
    @IBOutlet var btnClose: UIButton!
    @IBOutlet weak var secondpreviewview: UIView!
    @IBOutlet weak var monthalysale: SkyFloatingLabelTextField!
    @IBOutlet weak var brandname: SkyFloatingLabelTextField!
    @IBOutlet weak var productname: SkyFloatingLabelTextField!
   
    //    @IBAction func closebtn(_ sender: UIButton) {
    //        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
    //            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
    //        })
    //        { (finished) in
    //            self.willMove(toParentViewController: nil)
    //            self.view.removeFromSuperview()
    //            self.removeFromParentViewController()
    //        }
    //        AppDelegate.blureffectview.removeFromSuperview()
    ////        removePullUpController(self, animated: true)
    //    }
    
    @IBOutlet weak var quantity: SkyFloatingLabelTextField!
    enum InitialState {
        case contracted
        case expanded
    }
    
    @IBOutlet var brandnameheight: NSLayoutConstraint!
    @IBOutlet var productnameheight: NSLayoutConstraint!
    @IBOutlet var monthlysaleheight: NSLayoutConstraint!
    @IBOutlet weak var prefButtonheight: NSLayoutConstraint!
    
    @IBOutlet weak var reasonlblHeight: NSLayoutConstraint! //20
    @IBOutlet weak var reasonSpnrHeight: NSLayoutConstraint!  //34
    @IBOutlet weak var prodLblHeight: NSLayoutConstraint!  // 20
     
    
    @IBOutlet weak var prodSpnrHeight: NSLayoutConstraint!  // 34
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        brandname.delegate = self
        productname.delegate = self
        
        brandname.isHidden = true
        brandnameheight.constant = 0.0
        productname.isHidden = true
        productnameheight.constant = 0.0
        prebuttonHeight.constant = 0.0
        prefButtonheight.constant = 0.0
        secondpreviewview.layer.shadowColor = UIColor.black.cgColor
        secondpreviewview.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        secondpreviewview.layer.shadowOpacity = 2.0
        
        if #available(iOS 11.0, *){
            secondpreviewview.clipsToBounds = false
            secondpreviewview.layer.cornerRadius = 15
            secondpreviewview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = secondpreviewview.frame
            rectShape.position = secondpreviewview.center
            rectShape.path = UIBezierPath(roundedRect: secondpreviewview.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
            secondpreviewview.layer.backgroundColor = UIColor.green.cgColor
            secondpreviewview.layer.mask = rectShape
        }
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: secondpreviewview.frame.maxY)
        
        setreasonspinr()
        setproductbrand()
        prefbutton.isHidden = true
        prebuttonHeight.constant = 0.0
        
        reasonspinr.didSelect { (selected, index, id) in
            print("reasonid=====>\(self.reasonidarr[index])")
            self.reasonid = self.reasonidarr[index]
        }
        
        productbrandspinr.didSelect { (selected, index, id) in
            print("competitorid=====>\(self.compititoridarr[index])")
            
            if self.productbrandspinr.optionArray[index].lowercased() == "other"
            {
                self.brandname.isHidden = false
                self.brandnameheight.constant = 40.0
            }
            else{
                self.brandname.text = ""
                self.brandname.isHidden = true
                self.brandnameheight.constant = 0.0
            }
            if index != 0 {
                
                self.productnamespinr.text = "Select"
                self.productname.text = ""
                self.quantity.text = ""
                
                self.compititorid = self.compititoridarr[index]
                self.productname(compititorid: self.compititorid!)
                self.monthalysale.isUserInteractionEnabled = true
                self.reasonspinr.isUserInteractionEnabled = true
                self.setindex(compititorid: self.compititorid!)
                
                //refreshqty
                
                
             //   self.setindex()
            }else{
                self.prefbutton.isHidden = true
                self.prebuttonHeight.constant = 0.0
             //   self.monthalysale.isHidden = true
              //  self.monthlysaleheight.constant = 0.0
            }
        }
        
        productnamespinr.didSelect { (selected, index, id) in
            self.itemid = self.itemidarr[index]
            
            if self.productnamespinr.optionArray[index].lowercased() == "other"
            {
                self.productname.isHidden = false
                self.productnameheight.constant = 39.0
                self.productname.text = ""
            }
            else{
                self.productname.isHidden = true
                self.productnameheight.constant = 0.0
            }
        }
        
        reasonspinr.text = reasonspinr.optionArray[0]
        productnamespinr.text = "Select"
        productbrandspinr.text = productbrandspinr.optionArray[0]
        setreasonspinr()
        self.reasonspinr.text = self.reasonspinr.optionArray[0]
        
        productnamespinr.keyboardDistanceFromTextField = 150
        productname.autocapitalizationType = .words
        brandname.autocapitalizationType = .words
        
    }
    
    func setreasonspinr()
    {
        var stmt1: OpaquePointer?
        reasonidarr.removeAll()
        reasonspinr.optionArray.removeAll()
        let query = "select '' as reasonid,'Select' as reasonremarks union select distinct reasonid,reasonremarks  from VW_PREFERREDREASONMASTER"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let reasonid1 = String(cString: sqlite3_column_text(stmt1, 0))
            let reasonremarks = String(cString: sqlite3_column_text(stmt1, 1))
            
            reasonspinr.optionArray.append(reasonremarks)
            reasonidarr.append(reasonid1)
        }
    }
    
    //    var initialPointOffset: CGFloat = 0.0 {
    //        return pullUpControllerPreferredSize.height
    //    }
    
    //    override var pullUpControllerPreferredSize: CGSize {
    //        return portraitSize
    //    }
    
    //    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
    //        return [secondpreviewview.frame.maxY, secondpreviewview.frame.maxY]
    //    }
    
    //    override var pullUpControllerIsBouncingEnabled: Bool {
    //        return false
    //    }
    
    func setproductbrand()
    {
        compititoridarr.removeAll()
        var stmt1: OpaquePointer?
        
        let query = "Select '-Select-' as compititorname,'0' as compititorid Union select distinct compititorname,compititorid from COMPETITORDETAIL"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let compititorid = String(cString: sqlite3_column_text(stmt1, 1))
            let compititorname = String(cString: sqlite3_column_text(stmt1, 0))
            
            productbrandspinr.optionArray.append(compititorname)
            compititoridarr.append(compititorid)
        }
    }
    
    func productname(compititorid: String)
    {
        var stmt1: OpaquePointer?
        itemidarr.removeAll()
        productnamespinr.optionArray.removeAll()
        var query = ""
        if(AppDelegate.chemistcheck){
            query = "Select distinct  '-Select-' as itemname,'' as itemid Union select distinct itemname,itemid from COMPETITORDETAIL where compititorid='\(compititorid)' and  isblocked='false' and isapproved = 'true' and itemid not in (Select itemid from COMPETITORDETAILPOST where customercode = '\(AppDelegate.chemcustcode)' and itemid <> '1' and isblocked = 'false')"
        }
        else {
            query = "Select distinct  '-Select-' as itemname,'' as itemid Union select distinct itemname,itemid from COMPETITORDETAIL where compititorid='\(compititorid)' and  isblocked='false' and isapproved = 'true' and itemid not in (Select itemid from COMPETITORDETAILPOST where customercode = '\(AppDelegate.customercode)' and itemid <> '1' and isblocked = 'false')"
        }
        
        
        // select distinct itemname,itemid from COMPETITORDETAIL where compititorid='" + brand + "' and  isblocked='0' and isapproved = '1' and itemid not in (Select itemid from COMPETITORDETAILPOST where customercode = '" + RetailerListActivity.retailerId + "'  and itemid <> '1' and isblocked = '0'
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 0))
            let itemid = String(cString: sqlite3_column_text(stmt1, 1))
            
            productnamespinr.optionArray.append(itemname)
            itemidarr.append(itemid)
        }
    }
    
    func setindex()
    {
        var stmt1: OpaquePointer?
        var query = ""
        if(AppDelegate.isChemist){
             query = "select count(*) from (select distinct Competitorid,brandname from COMPETITORDETAILPOST  where ispreffered='true' and " +
                   " CUSTOMERCODE='\(AppDelegate.chemcustcode)')"
        }
        else {
             query = "select count(*) from (select distinct Competitorid,brandname from COMPETITORDETAILPOST  where ispreffered='true' and " +
                   " CUSTOMERCODE='\(AppDelegate.customercode)')"
        }
        print("setindex==>"+query)
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        self.showcomp3Items()
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            index = String(cString: sqlite3_column_text(stmt1, 0))
            print("Index====="+index!)
            
            switch index {
                
            case "0":
                prefbutton.isHidden = false
                prebuttonHeight.constant = 40.0
                monthalysale.isHidden = false
                self.monthlysaleheight.constant = 39.0
                reasonspinr.isHidden = false
                prefbutton.setTitle("Most Preferred Brand", for: .normal)
                isprefered  = true
                self.productname.isHidden = true
                self.productnameheight.constant = 0.0
                prefbutton.setBackgroundImage(UIImage(named: "login_bttn.png"), for: UIControlState.normal)
                
                break
                
            case "1":
                prefbutton.isHidden = false
                prebuttonHeight.constant = 40.0
                monthalysale.isHidden = false
                self.monthlysaleheight.constant = 39.0
                reasonspinr.isHidden = false
                prefbutton.setTitle("Second Most Preffered", for: .normal)
                prefbutton.setBackgroundImage(UIImage(named: "submit.png"), for: UIControlState.normal)
                isprefered  = true
                break
                
            case "2":
                prefbutton.isHidden = false
                prebuttonHeight.constant = 40.0
                monthalysale.isHidden = false
                self.monthlysaleheight.constant = 39.0
                reasonspinr.isHidden = false
                prefbutton.setTitle("Third Most Preffered", for: .normal)
                prefbutton.setBackgroundImage(UIImage(named: "thirdprefbutton.png"), for: UIControlState.normal)
                isprefered  = true
                break
                
            default:
                prefbutton.isHidden = true
                prebuttonHeight.constant = 0.0
                monthalysale.isHidden = true
                self.monthlysaleheight.constant = 0.0
                isprefered  = false
                hideon3rdCompeItem()
             //   reasonspinr.isHidden = true
                break
                
            }
        }
    }
    
    func setindex(compititorid: String)
    {
        var stmt1: OpaquePointer?
        var query = ""
        if(AppDelegate.isChemist){
             query = "Select reasonid,sale,preffindex,ispreffered,brandname from COMPETITORDETAILPOST where Competitorid='\(compititorid)' and CUSTOMERCODE='\(AppDelegate.chemcustcode)'"
        }
        else {
             query = "Select reasonid,sale,cast (preffindex as Int) as preffindex ,ispreffered,brandname from COMPETITORDETAILPOST where Competitorid='\(compititorid)' and CUSTOMERCODE='\(AppDelegate.customercode)'"
        }
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        print("pncbottomSheetSetIndex==" + query )
        self.showcomp3Items()
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            index = String(cString: sqlite3_column_text(stmt1, 2))
            
            let brandnamestr = String(cString: sqlite3_column_text(stmt1, 4))
            
            let ispreff: String = String(cString: sqlite3_column_text(stmt1, 3))
            isprefered = ispreff == "true" ? true : false
            let reasonid: String = String(cString: sqlite3_column_text(stmt1, 0))
            let sale: String = String(cString: sqlite3_column_text(stmt1, 1))
            
            var i = 0
            //            self.reasonspinr.text = reasonspinr.optionArray[i]
            self.monthalysale.text = sale
            self.monthalysale.isUserInteractionEnabled = false
            //            self.reasonspinr.isUserInteractionEnabled = false
            
            
            for index in 0..<reasonidarr.count {
                if reasonidarr[index] == reasonid {
                    i = index
                }
            }
            if index == "\(reasonidarr.count)" {
                index = "0"
            }
            if i > 0 {
                reasonspinr.text = reasonspinr.optionArray[i]
                reasonspinr.isUserInteractionEnabled = false
                reasonspinr.isEnabled = false
                self.reasonid = reasonidarr[i]
            }else{
                //hide product name
                self.productname.isHidden = true
                self.productnameheight.constant = 0.0
                reasonspinr.isUserInteractionEnabled = true
                reasonspinr.isEnabled = true
            }
            
            if brandnamestr != "" {
                brandname.text = brandnamestr
                brandname.isEnabled = false
            }else{
                brandname.text = ""
                brandname.isEnabled = true
            }
            if sale != ""{
                monthalysale.text = sale
                monthalysale.isUserInteractionEnabled = false
                monthalysale.isEnabled = false
            }else{
                monthalysale.text = ""
                monthalysale.isUserInteractionEnabled = true
                monthalysale.isEnabled = true
            }
            print("PncIndex==="+index!)
            
            switch index {

            case "0":
                prefbutton.isHidden = false
                prebuttonHeight.constant = 40.0
                monthalysale.isHidden = false
                self.monthlysaleheight.constant = 39.0
                reasonspinr.isHidden = false
                prefbutton.setTitle("Most Preferred Brand", for: .normal)
                isprefered  = true
                self.productname.isHidden = true
                self.productnameheight.constant = 0.0
                prefbutton.setBackgroundImage(UIImage(named: "login_bttn.png"), for: UIControlState.normal)

                break

            case "1":
                prefbutton.isHidden = false
                prebuttonHeight.constant = 40.0
                monthalysale.isHidden = false
                self.monthlysaleheight.constant = 39.0
                reasonspinr.isHidden = false
                prefbutton.setTitle("Second Most Preffered", for: .normal)
                prefbutton.setBackgroundImage(UIImage(named: "submit.png"), for: UIControlState.normal)
                isprefered  = true
                break

            case "2":
                prefbutton.isHidden = false
                prebuttonHeight.constant = 40.0
                monthalysale.isHidden = false
                self.monthlysaleheight.constant = 39.0
                reasonspinr.isHidden = false
                prefbutton.setTitle("Third Most Preffered", for: .normal)
                prefbutton.setBackgroundImage(UIImage(named: "thirdprefbutton.png"), for: UIControlState.normal)
                isprefered  = true
                break

            default:
                prefbutton.isHidden = true
                prebuttonHeight.constant = 0.0
                monthalysale.isHidden = true
                self.monthlysaleheight.constant = 0.0
                isprefered  = false
                self.hideon3rdCompeItem()
                //done now
               // reasonspinr.isHidden = true
                break
            }
        }
            
        else{
            setindex()
            setreasonspinr()
            reasonspinr.text = reasonspinr.optionArray[0]
            reasonspinr.isUserInteractionEnabled = true
            reasonspinr.isEnabled = true
            monthalysale.text = ""
            monthalysale.isEnabled = true
            monthalysale.isUserInteractionEnabled = true
            self.productname.isHidden = true
            self.productnameheight.constant = 0.0
            productbrandspinr.text = productbrandspinr.optionArray[0]
            
        }
    }
    
    func getselectedprodid(brand: String?,prod: String?)-> String{
        var stmt1: OpaquePointer?
        var prodstr = ""
        var query = ""
        if(AppDelegate.isChemist){
             query = "select distinct itemname,itemid from COMPETITORDETAIL where compititorid='" + brand! + "' and  isblocked='false' and isapproved = 'true' and itemid not in (Select itemid from COMPETITORDETAILPOST where customercode = '" + AppDelegate.chemcustcode + "'  and itemid <> '1' and isblocked = 'false') and itemname = '" + prod! + "'"
        }
        else {
             query = "select distinct itemname,itemid from COMPETITORDETAIL where compititorid='" + brand! + "' and  isblocked='false' and isapproved = 'true' and itemid not in (Select itemid from COMPETITORDETAILPOST where customercode = '" + AppDelegate.customercode + "'  and itemid <> '1' and isblocked = 'false') and itemname = '" + prod! + "'"

        }
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            prodstr = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return prodstr
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if(self.validate()){
            let base: Baseactivity = Baseactivity()
           if productnamespinr.text?.lowercased() == "other"{
            
                itemid = base.getIDItemId()
                // CompetitorDetail
                base.insertcompetitor(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), compititorid: self.compititorid,
                                      compititorname: productbrandspinr.text, itemid: itemid, itemname: productname.text, post: "0",
                                      isblocked: "false", status: "BLOCK", isapproved: "false",createdtransactionid: "0",modifiedtransactionid: "0" )
            
            brandname.isEnabled = false
            brandname.isUserInteractionEnabled = false
            productname.text = ""
            }
            if(AppDelegate.chemistcheck){
                  base.insertusercompetitor(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid")!, CUSTOMERCODE: AppDelegate.chemcustcode, ITEMID: itemid, SITEID: Marketvc.superdealerstr, USERCODE: UserDefaults.standard.string(forKey: "usercode")!, post: "0", Competitorid: self.compititorid!, reasonid: self.reasonid!, qty: quantity.text, sale: monthalysale.text, ispreffered: self.isprefered == true ? "true" : "false", preffindex: self.index, brandname: brandname.text, isblocked: "false",createdtransactionid: "0",modifiedtransactionid: "0")
            }
            else {
                  base.insertusercompetitor(DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid")!, CUSTOMERCODE: AppDelegate.customercode, ITEMID: itemid, SITEID: Marketvc.superdealerstr, USERCODE: UserDefaults.standard.string(forKey: "usercode")!, post: "0", Competitorid: self.compititorid!, reasonid: self.reasonid!, qty: quantity.text, sale: monthalysale.text, ispreffered: self.isprefered == true ? "true" : "false", preffindex: self.index, brandname: brandname.text, isblocked: "false",createdtransactionid: "0",modifiedtransactionid: "0")
            }
            productnamespinr.text = productbrandspinr.optionArray[0]
            productname(compititorid: compititoridarr[productbrandspinr.selectedIndex!])
            setindex(compititorid: compititoridarr[productbrandspinr.selectedIndex!])
            quantity.text = ""
            SwiftEventBus.post("updateprogress")
        }
        
    }
    
    func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
        for (index, obj) in array.enumerated() where obj == object {
            return index
        }
        return nil
    }
    
    func validate  ()-> Bool{
        
        var prod = ""
        let base: Baseactivity = Baseactivity()
       
        if productbrandspinr.selectedIndex != nil {
            prod = getselectedprodid(brand: compititoridarr[productbrandspinr.selectedIndex!], prod: self.productnamespinr.text!)
        }
        
        if reasonspinr.selectedIndex != nil  {
            self.reasonid = reasonidarr[self.reasonspinr.selectedIndex!]
        }
        if productbrandspinr.text == "-Select-" {
             base.showtoast(controller: self, message: "Select Brand", seconds: 1.5)
             return false
        }else if productbrandspinr.text?.lowercased() == "other" && brandname.text == "" {
            base.showtoast(controller: self, message: "Enter Brand Name", seconds: 1.5)
             return false
        }else if reasonspinr.isHidden == false && reasonspinr.text?.lowercased() == "select" {
            base.showtoast(controller: self, message: "Select Reason", seconds: 1.5)
             return false
        }else if prod == ""{
            base.showtoast(controller: self, message: "Select Assigned product", seconds: 1.5)
             return false
        }else if productnamespinr.text?.lowercased() == "other" && productname.text! == "" {
            base.showtoast(controller: self, message: "Enter Product name", seconds: 1.5)
             return false
        }else if monthalysale.text?.lowercased() == "" && !monthalysale.isHidden {
            base.showtoast(controller: self, message: "Please Enter Average Monthly Sale", seconds: 1.5)
             return false
        }else if quantity.text! == "" {
            base.showtoast(controller: self, message: "Please Enter Quantity", seconds: 1.5)
            return false
        }
        return true
    }
    func hideon3rdCompeItem(){
        reasonspinr.isHidden = true
        reasonspinr.text! = "select"
        monthalysale.isHidden = true
        productname.text! = ""
        productnamespinr.isHidden = true
        productnameheight.constant = 0.0
        quantity.text! = ""
        reasonlblHeight.constant = 0.0
        reasonSpnrHeight.constant = 0.0
        prodLblHeight.constant = 0.0
        prodSpnrHeight.constant = 0.0
      //  quantity.isHidden = true
        
    }
    func showcomp3Items(){
        reasonspinr.isHidden = false
        reasonspinr.text! = "select"
        monthalysale.isHidden = false
        productname.text! = ""
        productnamespinr.isHidden = false
        quantity.text! = ""
        reasonlblHeight.constant = 20.0
        reasonSpnrHeight.constant = 34.0
        prodLblHeight.constant = 20.0
        prodSpnrHeight.constant = 34.0
    }
    
}
