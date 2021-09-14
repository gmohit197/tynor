//
//  AttachDoctorvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 09/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import SwiftEventBus

class AttachDoctorvc: SJSegmentedViewController {
    
    var selectedSegment: SJSegmentTab?
    public static var doccode: String!
    public static var custcode: String!
    var base = Baseactivity()
    static var flag: Bool = true
    var titletext: String?
    var progressColor = UIColor(red: 138.0 / 255.0, green: 17.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storyboard = self.storyboard{
            let headerController = storyboard.instantiateViewController(withIdentifier:"headerdoc") as? HeaderAttachDoc
            
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "Adddocgvc") as? AddDocGenralvc
            
            firstViewController?.title = "1"
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "adddochl") as? AddDocHLvc
            secondViewController?.title = "2"
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "product") as? MiProductvc
            thirdViewController?.title = "3"
            
            headerViewController = headerController
            segmentControllers = [firstViewController!,
                                  secondViewController!,
                                  thirdViewController!]
            
            headerViewHeight = 100
            selectedSegmentViewHeight = 5.0
            headerViewOffsetHeight = 31.0
            segmentTitleColor = .gray
            selectedSegmentViewColor = self.progressColor
            segmentShadow = SJShadow.medium()
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            segmentBounces = false
            delegate = self
        }
        base.setnav(controller: self, title: "Attach Doctor")
        super.viewDidLoad()
    }
    
    @IBAction func backbtn(_ sender: Any) {
        if (((AppDelegate.source == "Attach Doctor" || AppDelegate.source == "Retailer" || AppDelegate.isFromSalesPersonList)  && !AppDelegate.showDocList) && (AppDelegate.isDocScreen == false)) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
                vc.titlebar = "Doctor"
                self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            if(AppDelegate.titletxt == "Doctor" || AppDelegate.titletxt == "Hospital"){
                if(AppDelegate.isFromRetailerScreen == true){
                    AppDelegate.customercode = AppDelegate.retcustomercode
                    AppDelegate.isRetScreen = true
                    AppDelegate.isDocScreen = false
                }
                else if(AppDelegate.isFromHospitalScreen == true){
                    AppDelegate.titletxt = "Hospital"
                    AppDelegate.customercode = AppDelegate.hoscustomercode
                    AppDelegate.hoscode = AppDelegate.oldhoscode
                    AppDelegate.isDocScreen = false
                    AppDelegate.isHosScreen = false
                }
                else if(AppDelegate.isFromDoctorScreen == true){
                    AppDelegate.customercode = AppDelegate.doccustomercode
                    AppDelegate.isDocScreen = false
                }
                if(AppDelegate.isChemist == true){
                    AppDelegate.chemcustcode = AppDelegate.oldChemcustomercode
                    AppDelegate.source = "3"
                }
            self.navigationController?.popViewController(animated : true)
            }
        }
    }
    
     @IBAction func homebtn(_ sender: Any) {
          let home: Dashboardvc = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! Dashboardvc
                  self.navigationController?.pushViewController(home, animated: true)
       }
}

extension AttachDoctorvc: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.lightGray)
        }
        
        if segments.count > 0 {
            selectedSegment = segments[index]
            selectedSegment?.titleColor(.red)
        }
        if (!AddDocGenralvc.nxt! && index > 0){
            base.showtoast(controller: self, message: "Fill General Details", seconds: 1.5)
            print("fill GD first ===========>")
            setSelectedSegmentAt(0, animated: true)
        }
        SwiftEventBus.onMainThread(self, name: "gotodoctor")
        {
            Result in
            self.setSelectedSegmentAt(1, animated: true)
        }
        SwiftEventBus.onMainThread(self, name: "gotoproduct")
        {
            Result in
            self.setSelectedSegmentAt(2, animated: true)
        }
    }
}


