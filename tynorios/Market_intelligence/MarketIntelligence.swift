//  MarketIntelligence.swift
//  tynorios
//
//  Created by Acxiom Consulting on 02/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.


import UIKit
import SJSegmentedScrollView
import SwiftEventBus

class MarketIntelligence: SJSegmentedViewController {
    
    var customercode: String?
    var customername: String?
    var titletext: String?
    var siteid: String?
    var custcode: String?
    var source: String?
    
    var progressColor = UIColor(red: 138.0 / 255.0, green: 17.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    
    var selectedSegment: SJSegmentTab?
    var base = Baseactivity()
    static var flag: Bool = true
    override func viewDidLoad() {
        if let storyboard = self.storyboard {
            
            let headerController = storyboard
                .instantiateViewController(withIdentifier: "header") as? HeaderView
            
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "marketgd") as? Marketvc
            firstViewController?.title = "1"
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "product") as? MiProductvc
            secondViewController?.title = "2"
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "doctor") as? MiDoctorvc
            thirdViewController?.title = "3"
            
            let fourthViewController = storyboard
                .instantiateViewController(withIdentifier: "stock") as? MiStockvc
            fourthViewController?.title = "4"
            
            headerViewController = headerController
            segmentControllers = [firstViewController!,
                                  secondViewController!,
                                  thirdViewController!,
                                  fourthViewController!]
            
            headerViewHeight = 120
            selectedSegmentViewHeight = 5.0
            headerViewOffsetHeight = 31.0
            segmentTitleColor = .gray
//            segmentedViewController.selectedSegmentViewHeight = 5.0
            selectedSegmentViewColor = self.progressColor
            segmentShadow = SJShadow.medium()
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = true
            segmentBounces = false
            delegate = self
        }
        base.setnav(controller: self, title: "Market Intelligence")
        super.viewDidLoad()
    }
    
    @IBAction func homebtn(_ sender: UIBarButtonItem) {
        base.gotohome()
    }
    
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        if(AppDelegate.isChemist && AppDelegate.isFromHospitalScreen){
            AppDelegate.chemistcheck = false
            AppDelegate.isChemist = false
            AppDelegate.titletxt = "Hospital"
            AppDelegate.customercode = AppDelegate.hoscustomercode
            AppDelegate.hoscode = AppDelegate.oldhoscode
            AppDelegate.doccode = AppDelegate.oldhoscode
            SwiftEventBus.post("LinkingDone")
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension MarketIntelligence: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.lightGray)
        }
        if segments.count > 0 {
            selectedSegment = segments[index]
            selectedSegment?.titleColor(.red)
        }
        if Retailerlistvc.customername!.isEmpty{
            if (MarketIntelligence.flag && index > 0){
                base.showtoast(controller: self, message: "Fill General Details", seconds: 1.5)
                print("fill GD first ===========>")
                setSelectedSegmentAt(0, animated: true)
            }
        }
        
        if(AppDelegate.titletxt == "Retailer"){
            AppDelegate.source = "MarketIntelligence"
        }
        
        SwiftEventBus.onMainThread(self, name: "gotosegment")
        {
            Result in
            self.setSelectedSegmentAt(1, animated: true)
        }
        SwiftEventBus.onMainThread(self, name: "gotodoctor")
        {
            
            Result in
            self.setSelectedSegmentAt(2, animated: true)
            if(AppDelegate.isDebug){
            print("MarketIntelligence"+AppDelegate.customercode)
            }   
        }
        SwiftEventBus.onMainThread(self, name: "gotostock")
        {
            Result in
            self.setSelectedSegmentAt(3, animated: true)
        }
    }
}
