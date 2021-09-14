//
//  RejectSubdealer.swift
//  tynorios
//
//  Created by Acxiom Consulting on 18/06/19.
//  Copyright © 2019 Acxiom. All rights reserved.
//

import UIKit
import SwiftEventBus

class RejectSubdealer: PullUpController,UITextViewDelegate {
    
    public var portraitSize: CGSize = .zero
    var head: String! = ""
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBAction func close(_ sender: UIButton) {
        removePullUpController(self, animated: true)
    }
    
    @IBOutlet weak var counter: UILabel!
    
    let base = Baseactivity()
    
    @IBOutlet var desc: UITextView!
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = textView.text
        
        var numberOfChars:Int?
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 && newText!.count==0 {
                return true
            }
            if isBackSpace == -92{
                numberOfChars = newText!.count-1
            }
            else{
                numberOfChars = newText!.count + 1
            }
        }
        //        guard range.location == 0 else {
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            //                    SwiftEventBus.post("getcount")
            if numberOfChars! > 500 && isBackSpace == -92{
                //                    return true
            }
            else if numberOfChars! <= 500 {
                self.counter.text = String(500 - numberOfChars!) + "/500"
            }
            else {
                let base = Baseactivity()
                base.showtoast(controller: self, message: "Maximum Limit Reached", seconds: 1.0)
            }
        }
        //            return true
        //        }
        
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    
    @IBOutlet weak var secondPreviewView: UIView!
    
    enum InitialState {
        case contracted
        case expanded
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add your descripition here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateLbl.text = base.getTodaydatetime()
        desc.delegate = self
        secondPreviewView.layer.shadowColor = UIColor.black.cgColor
        secondPreviewView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        secondPreviewView.layer.shadowOpacity = 2.0
        
        if #available(iOS 11.0, *){
            secondPreviewView.clipsToBounds = false
            secondPreviewView.layer.cornerRadius = 15
            secondPreviewView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = secondPreviewView.frame
            rectShape.position = secondPreviewView.center
            rectShape.path = UIBezierPath(roundedRect: secondPreviewView.bounds,byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
            secondPreviewView.layer.backgroundColor = UIColor.green.cgColor
            secondPreviewView.layer.mask = rectShape
        }
        
        desc.text = "Add your descripition here..."
        desc.textColor = UIColor.lightGray
        
//        let tapdesc = UITapGestureRecognizer(target: self, action: #selector(clickdesc))
//        tapdesc.numberOfTapsRequired = 1
//        desc.addGestureRecognizer(tapdesc)
        
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: secondPreviewView.frame.maxY)
        willMoveToStickyPoint = { point in
            print("willMoveToStickyPoint \(point)")
        }
        
        didMoveToStickyPoint = { point in
            print("didMoveToStickyPoint \(point)")
        }
        
        onDrag = { point in
            print("onDrag: \(point)")
        }
        
        SwiftEventBus.onMainThread(self, name: "getcount")
        {
            Result in
            let newText = self.desc.text
            let numberOfChars = newText!.count
            if numberOfChars <= 500{
                self.counter.text = String(500 - numberOfChars) + "/500"
            }
            else{
                let base = Baseactivity()
                base.showtoast(controller: self, message: "Maximum Limit Reached", seconds: 1.0)
            }
        }
        
    }
    
    var initialPointOffset: CGFloat {
        return pullUpControllerPreferredSize.height
    }
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [secondPreviewView.frame.maxY, secondPreviewView.frame.maxY]
    }
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    @objc func clickdesc () {
        
        desc.isEditable = true

//               let newPosition = desc.beginningOfDocument
//                desc.selectedTextRange = textView.textRangeFromPosition(newPosition, toPosition: newPosition)
    }
    
    //self.insertSubdealerRequest(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), status: "1", expdiscount: expDiscount.placeholder, recid: recid, usercode: usercode, rejectreason: "-", post: "0", customercode: customercode)
    
    @IBAction func submitBtn(_ sender: Any) {
        if self.desc.text == "Add your descripition here..." || self.desc.text.isEmpty {
            base.showtoast(controller: self, message: "Plese add description", seconds: 1.5)
        }
        else{
            base.insertSubdealerRequest(dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), status: "0", expdiscount: "-", recid: UserDefaults.standard.string(forKey: "recid"), usercode: UserDefaults.standard.string(forKey: "usercodesub"), rejectreason: self.desc.text, post: "0", customercode: UserDefaults.standard.string(forKey: "customercode"))
            base.checknet()
            if AppDelegate.ntwrk > 0{
                let executeapi = Executeapi()
                executeapi.postSubdealerConvert()
                
                SwiftEventBus.onMainThread(self, name: "subdealerPost") { Result in
                    
                    
//                    let pendingSubDealer: TeamManegement = self.storyboard?.instantiateViewController(withIdentifier: "teammanagement") as! TeamManegement
//                    self.navigationController?.pushViewController(pendingSubDealer, animated: true)
                    
                    
                    let subdealer: PendingSubdealervc = self.storyboard?.instantiateViewController(withIdentifier: "pendingsubdealer") as! PendingSubdealervc
                                  self.navigationController?.pushViewController(subdealer, animated: true)
                    
                    self.base.showtoast(controller: self, message: "Data Posted Successfully", seconds: 1.5)
                }
            }
            else{
                base.showtoast(controller: self, message: "Network Problem! Please Try Again", seconds: 1.5)
            }
        }
    }
}
