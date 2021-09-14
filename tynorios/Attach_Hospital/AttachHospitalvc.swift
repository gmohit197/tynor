
//  AttachHospitalvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 24/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import SwiftEventBus

class AttachHospitalvc: SJSegmentedViewController {
    
    var selectedSegment: SJSegmentTab?
    var base = Baseactivity()

    static var flag: Bool = true
    var titletext: String?
    var progressColor = UIColor(red: 138.0 / 255.0, green: 17.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    var drcode = ""
 
    override func viewDidLoad() {
        if let storyboard = self.storyboard {
            
            let headerController = storyboard
                .instantiateViewController(withIdentifier: "attachhospital") as? HeaderAttachHospital
            
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "addhospital") as? Addhospitalvc
            
            firstViewController?.title = "1"
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "doctor") as? MiDoctorvc
            secondViewController?.title = "2"
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "chemist") as? Attach_chemistvc
            thirdViewController?.title = "3"
            
            let fourthViewController = storyboard
                .instantiateViewController(withIdentifier: "product") as? MiProductvc
            fourthViewController?.title = "4"
            
            headerViewController = headerController
            segmentControllers = [firstViewController!,
                                  secondViewController!,
                                  thirdViewController!,
                                  fourthViewController!]
            
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
        
        base.setnav(controller: self, title: "Attach Hospital")
        super.viewDidLoad()
    }
    
    @IBAction func backbtn(_ sender: Any) {
        AppDelegate.isHosScreen = false
        if (((((AppDelegate.source == "Attach Doctor" || AppDelegate.isFromSalesPersonList)  && !AppDelegate.showHosList)) || (AppDelegate.source == "Hospital" && AppDelegate.isDocScreen == false  && AppDelegate.showHosList == false)) && (AppDelegate.isFromCustomerCardList == false)){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            vc.titlebar = "Hospital"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        else {
            if(AppDelegate.titletxt == "Doctor" || AppDelegate.titletxt == "Hospital"){
                if(!(AppDelegate.doccustomercode == "")){
                    AppDelegate.customercode = AppDelegate.doccustomercode
                }
            }
            AppDelegate.isHosScreen = false
            self.navigationController?.popViewController(animated : true)
        }
    }
}

extension AttachHospitalvc: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.lightGray)
        }
        if segments.count > 0 {
            selectedSegment = segments[index]
            selectedSegment?.titleColor(.red)
        }
        if (!Addhospitalvc.nxtHos! && index > 0){
            base.showtoast(controller: self, message: "Fill General Details", seconds: 1.5)
            self.setSelectedSegmentAt(0, animated: true)
        }
        
        SwiftEventBus.onMainThread(self, name: "gotohossegment")
        {
            Result in
            self.setSelectedSegmentAt(1, animated: true)
        }
        
        SwiftEventBus.onMainThread(self, name: "gotochemist")
        {
            Result in
            self.setSelectedSegmentAt(2, animated: true)
        }
        
        SwiftEventBus.onMainThread(self, name: "gotopro")
        {
            Result in
            self.setSelectedSegmentAt(3, animated: true)
        }
    }
}

