//
//  SubDealerConversionvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/06/19.
//  Copyright © 2019 Acxiom. All rights reserved.
//

import UIKit
import SwiftEventBus

class SubDealerConversionvc: Executeapi {
    
    @IBOutlet weak var userCode: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var submitDate: UILabel!
    @IBOutlet weak var custCode: UILabel!
    @IBOutlet weak var custName: UILabel!
    @IBOutlet weak var dealerCode: UILabel!
    @IBOutlet weak var dealerName: UILabel!
    @IBOutlet weak var linkEmp: UILabel!
    @IBOutlet weak var expSale: UILabel!
    @IBOutlet weak var expDiscount: UITextField!
    
    var recid: String?
    var customername: String?
    var customercode: String?
    var distributorcode: String?
    var distributorname: String?
    var expsale:String?
    var expdiscount:String?
    var usercodesub:String?
    var submitdate:String?
    var type:String?
    var conV_REQUEST:String?
    var username:String?
    var linkedemployee:String?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setnav(controller: self, title: "Dealer Conversion")
        self.setDetail()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        expDiscount.becomeFirstResponder()
//    }
    
    @IBAction func homebtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
    
    func setDetail()
    {
        self.userCode.text = usercodesub
        self.userName.text = username
        self.submitDate.text = submitdate
        self.custCode.text = customercode
        self.custName.text = customername
        self.dealerCode.text = distributorcode
        self.dealerName.text = distributorname
        self.linkEmp.text = linkedemployee
        self.expSale.text = expsale
        self.expDiscount.placeholder = expdiscount
        
        UserDefaults.standard.set(self.usercodesub, forKey: "usercodesub")
        UserDefaults.standard.set(self.recid, forKey: "recid")
        UserDefaults.standard.set(self.customercode, forKey: "customercode")
    }
    
    
    
    @IBAction func approveBtn(_ sender: Any) {
        
        if expDiscount.text == ""{
            self.insertSubdealerRequest(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), status: "1", expdiscount: expDiscount.placeholder, recid: recid, usercode: usercodesub, rejectreason: "-", post: "0", customercode: customercode)
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                self.postSubdealerConvert()
            }
        }
        else{
            self.insertSubdealerRequest(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), status: "1", expdiscount: expDiscount.text, recid: recid, usercode: usercodesub, rejectreason: "-", post: "0", customercode: customercode)
            self.checknet()
            if AppDelegate.ntwrk > 0 {
                self.postSubdealerConvert()
            }
        }
        
          SwiftEventBus.onMainThread(self, name: "subdealerPost") { Result in
          let subdealer: PendingSubdealervc = self.storyboard?.instantiateViewController(withIdentifier: "pendingsubdealer") as! PendingSubdealervc
           self.navigationController?.pushViewController(subdealer, animated: true)
            self.showtoast(controller: self, message: "Data Posted Successfully", seconds: 1.5)
                      
        }
//        let subdealer: PendingSubdealervc = self.storyboard?.instantiateViewController(withIdentifier: "pendingsubdealer") as! PendingSubdealervc
//               self.navigationController?.pushViewController(subdealer, animated: true)
////            let pendingSubDealer: TeamManegement = self.storyboard?.instantiateViewController(withIdentifier: "teammanagement") as! TeamManegement
////            self.navigationController?.pushViewController(pendingSubDealer, animated: true)
//            self.showtoast(controller: self, message: "Data Posted Successfully", seconds: 1.5)
       
    }
    
    private func makeSearchViewControllerIfNeeded() -> RejectSubdealer {
        let currentPullUpController = childViewControllers
            .filter({ $0 is RejectSubdealer })
            .first as? RejectSubdealer
        let pullUpController: RejectSubdealer = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "rejectBottomSheet") as! RejectSubdealer
        
        return pullUpController
    }
    
    private func addPullUpController() {
        let pullUpController = makeSearchViewControllerIfNeeded()
        _ = pullUpController.view // call pullUpController.viewDidLoad()
        
        addPullUpController(pullUpController,initialStickyPointOffset: pullUpController.initialPointOffset,animated: true)
    }
    
    @IBAction func rejectBtn(_ sender: Any) {
        self.addPullUpController()
    }
}
