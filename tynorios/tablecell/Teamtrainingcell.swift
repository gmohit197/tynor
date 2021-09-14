
//
//  Teamtrainingcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 23/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Teamtrainingcell: UITableViewCell {
     var sheetcontroller: EndTrainingBottomSheet?
    
    @IBOutlet weak var traineename: UILabel!
    
    @IBOutlet weak var startbtn: UIButton!
    @IBOutlet weak var endbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    
    var trainingid: String?
    var status: String?
    var usercode: String?
    var controller: UIViewController?
    let base = Baseactivity()
    let postapi = Postapi()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func startbtn(_ sender: Any) {
        let alert = UIAlertController(title: "Start Training?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.startbtn.isHidden = true
            self.donebtn.isHidden = true
            self.endbtn.isHidden = false
            
            let db:Databaseconnection = Databaseconnection()
            let base:Baseactivity = Baseactivity()
            
            base.checknet()
            if AppDelegate.ntwrk > 0
            {
                db.insertStartTraining(trainedto: self.usercode, trainingid: base.getID(), trainingstarttime: base.getTodaydatetime(), trainingstartdate: base.getdate(), post: "0")
                self.postapi.postStartTraining()
            }
            alert.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: constant.key), object: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        controller?.present(alert, animated: true)
    }
    
    @IBAction func endbutton(_ sender: Any) {
        var a=[UIView]()
        a = self.window!.subviews
        blurView(view:self.window!.subviews[a.count - 1])
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        sheetcontroller = storyboard.instantiateViewController(withIdentifier: "endbottomsheet") as! EndTrainingBottomSheet
        let base:Baseactivity=Baseactivity()
        
        sheetcontroller?.trainingid = self.trainingid
        sheetcontroller?.usercode = self.usercode
        sheetcontroller?.trainingdate = base.getTodaydatetime()
        
        let screenSize = UIScreen.main.bounds.size
        self.sheetcontroller!.view.frame  = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
        UIApplication.shared.keyWindow!.addSubview(self.sheetcontroller!.view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let screenSize = UIScreen.main.bounds.size
            
            self.sheetcontroller!.view.frame  = CGRect(x: 0, y: screenSize.height - self.sheetcontroller!.view.frame.height-300 + 60, width: screenSize.width, height:  self.sheetcontroller!.view.frame.height+300)
        }, completion: nil)
        let tapblurview = UITapGestureRecognizer(target: self, action: #selector(hidesheet))
        tapblurview.numberOfTapsRequired = 1
        AppDelegate.blureffectview.addGestureRecognizer(tapblurview)
    }
    @objc func hidesheet(sender: UITapGestureRecognizer){
        print("tappedd")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.sheetcontroller!.view.frame  = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
            
        })
        { (finished) in
            self.sheetcontroller!.willMove(toParentViewController: nil)
            self.sheetcontroller!.view.removeFromSuperview()
            self.sheetcontroller!.removeFromParentViewController()
        }
        AppDelegate.blureffectview.removeFromSuperview()
    }
    var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var blurEffectView = UIVisualEffectView()
    func blurView(view: UIView){
        
        blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = UIColor.lightGray
        blurEffectView.alpha = 0.2
        blurEffectView.frame = view.bounds
        AppDelegate.blureffectview=blurEffectView
        view.addSubview(AppDelegate.blureffectview)
    }
    
    private func makeSearchViewControllerIfNeeded() -> EndTrainingBottomSheet {
        let currentPullUpController = self.controller?.childViewControllers
            .filter({ $0 is EndTrainingBottomSheet })
            .first as? EndTrainingBottomSheet
        let pullUpController: EndTrainingBottomSheet = currentPullUpController ?? UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "endbottomsheet") as! EndTrainingBottomSheet
        let base:Baseactivity = Baseactivity()
        
        pullUpController.usercode = self.usercode
        pullUpController.trainingid = self.trainingid
        pullUpController.trainingdate = base.getTodaydatetime()
        
        return pullUpController
    }
//    private func addPullUpController() {
//        let pullUpController = makeSearchViewControllerIfNeeded()
//        _ = pullUpController.view // call pullUpController.viewDidLoad()
//        self.controller?.addPullUpController(pullUpController,initialStickyPointOffset: pullUpController.initialPointOffset,animated: true)
//    }
}
