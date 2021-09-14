//
//  HeaderView.swift
//  tynorios
//
//  Created by Acxiom Consulting on 03/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.

import UIKit
import UICircularProgressRing
import SwiftEventBus

class HeaderView: Executeapi {
    var customername = ""
    var titletext: String?
    var siteid: String?
    var rper: Float = 0;
    
    @IBOutlet weak var progressRing: UICircularProgressRing!
    @IBOutlet weak var mipercentage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateprog()
        progressRing.maxValue = 100
        progressRing.style = .ontop
        progressRing.innerRingColor=UIColor(red: 138/255, green: 17/255, blue: 84/255, alpha: 1.0)
        progressRing.shouldShowValueText=false
        self.updateprog()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "updateprogress") { Result in
            self.updateprog()
        }
    }
    
    @IBAction func homebtn(_ sender: UIBarButtonItem) {
        let base = Baseactivity()
        base.gotohome()
    }
    @IBAction func backbtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    func updateprog(){
        rper = 0
        if(AppDelegate.isDebug){
            print("HeaderView=="+AppDelegate.customercode)
        }
        if(AppDelegate.isChemist){
            rper = getretailerpecent(customercode: AppDelegate.chemcustcode)
            rper += getcustdoctor(query: "", customercode: AppDelegate.chemcustcode)
            rper += getcompetitor(customercode: AppDelegate.chemcustcode)
            rper += getmiimage(s: "0", customercode: AppDelegate.chemcustcode)
            rper += getmiimage(s: "1", customercode: AppDelegate.chemcustcode)
        }
        else{
            rper = getretailerpecent(customercode: AppDelegate.customercode)
            rper += getcustdoctor(query: "", customercode: AppDelegate.customercode)
            rper += getcompetitor(customercode: AppDelegate.customercode)
            rper += getmiimage(s: "0", customercode: AppDelegate.customercode)
            rper += getmiimage(s: "1", customercode: AppDelegate.customercode)
        }
        self.mipercentage.text=String(Int64(self.rper))
        print("HeaderViewPercentage=="+self.mipercentage.text!)
        self.progressRing.startProgress(to: CGFloat(self.rper), duration: 2.0) {
        }
    }
}
