//
//  ComplaintBottomSheet.swift
//  tynorios
//
//  Created by Acxiom Consulting on 01/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SQLite3
import SwiftEventBus

class ComplaintBottomSheet: UIViewController,UINavigationControllerDelegate, UITextViewDelegate {
    
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
    
    enum InitialState {
        case contracted
        case expanded
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    var customercode: String! = ""
    var category: String! = ""
    @IBOutlet weak var productlbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var productSpnr: DropDownUtil!
    var clickedimg:UIImage?
    @IBOutlet weak var cameraIcon: UIImageView!
    var imageView:UIImageView?
    var imagePickedBlock: ((UIImage) -> Void)?
    
    public var portraitSize: CGSize = .zero
    @IBOutlet weak var feedbackTypeSpinner: DropDownUtil!
    var itemid: String! = ""
    var idarr: [String]!
    var idtype: String! = ""
    @IBOutlet weak var counter: UILabel!
    var isproductbtn: Bool! = true
    var id: String! = ""
    var imageshowing=false
    @IBOutlet weak var secondPreviewView: UIView!
    @IBOutlet weak var descriptionLbl: UITextView!
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add your descripition here.."
            textView.textColor = UIColor.lightGray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackTypeSpinner.optionArray = []
        feedbackTypeSpinner.optionIds = []
        productSpnr.optionArray = []
        productSpnr.optionIds = []
        idarr = []
        let base = Baseactivity()
        descriptionLbl.delegate = self
//        descriptionLbl
        secondPreviewView.layer.shadowColor = UIColor.black.cgColor
        secondPreviewView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        secondPreviewView.layer.shadowOpacity = 2.0
        if #available(iOS 11.0, *){
            secondPreviewView.clipsToBounds = false
            secondPreviewView.layer.cornerRadius = 15
            secondPreviewView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = secondPreviewView.frame
            rectShape.position = secondPreviewView.center
            rectShape.path = UIBezierPath(roundedRect: secondPreviewView.bounds,    byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 30, height: 30)).cgPath
            secondPreviewView.layer.backgroundColor = UIColor.green.cgColor
            secondPreviewView.layer.mask = rectShape
        }
        
        cameraIcon.isUserInteractionEnabled = true
        let tapimg = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
//        tapimg.numberOfTapsRequired = 1
        cameraIcon.addGestureRecognizer(tapimg)
        
        let showimg = UILongPressGestureRecognizer(target: self, action: #selector(showImg))
//        showimg.minimumPressDuration=0.4
        showimg.delaysTouchesBegan = true
        showimg.delegate = self as? UIGestureRecognizerDelegate
        cameraIcon.addGestureRecognizer(showimg)
        descriptionLbl.text = "Add your descripition here.."
        descriptionLbl.textColor = UIColor.lightGray
        
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: secondPreviewView.frame.maxY)
//        willMoveToStickyPoint = { point in
//            print("willMoveToStickyPoint \(point)")
//        }
//
//        didMoveToStickyPoint = { point in
//            print("didMoveToStickyPoint \(point)")
//        }
//
//        onDrag = { point in
//            print("onDrag: \(point)")
//        }
        
        setproductspinnr()
        
        if isproductbtn {
            titleLbl.text = "Add Product Complaint"
            self.category = "Product"
            
        }else{
            titleLbl.text = "Add Service Complaint"
            productSpnr.isHidden = true
            productlbl.isHidden = true
            productSpnr.text = " "
            self.category = "Service"
            

        }
        self.dateLbl.text = base.getTodaydatetime()
        
        self.id = base.getID()
        setfeedbackspinner()
        productSpnr.didSelect { (selected, index, id) in
            self.itemid = String(id)
            
        }
        self.productSpnr.listHeight = 300.0
        
        feedbackTypeSpinner.didSelect { (selected, index, id) in
                self.idtype = self.idarr[index]
        }
        
        SwiftEventBus.onMainThread(self, name: "getcount")
        {
            Result in
            let newText = self.descriptionLbl.text
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
    @objc func showImg(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            //When lognpress is start or running
            
            print("hold")
//            clickedimg=UIImage(named: "AppIcon")
            if let imageview = clickedimg{
                var a=[UIView]()
                a = view.window!.subviews
                
                BlurView(view:view.window!.subviews[a.count - 1])
                self.imageView = UIImageView(image: imageview)
               
                imageView!.contentMode = UIViewContentMode.scaleAspectFill
                self.view.addSubview(self.imageView!)
                
                //              imageView.centerXAnchor.constraint(equalTo: self.view.window!.subviews[a.count - 1].centerXAnchor).isActive = true
                //             imageView.centerYAnchor.constraint(equalTo: self.view.window!.subviews[a.count - 1].centerYAnchor).isActive = true
                self.imageView!.backgroundColor=UIColor.white
//                print(self.presentedViewController)
                self.imageView!.frame = CGRect(
                    x: self.view.window!.subviews[a.count - 1].frame.width/2-(300/2),
                    y:self.view.window!.subviews[a.count - 1].frame.height/2-((
                        self.view.window!.subviews[a.count - 1].frame.height-260)/2),
                    width: 300,
                    height:400)
                imageView!.clipsToBounds = true
                print("showimage")
                let tapblurview = UITapGestureRecognizer(target: self, action: #selector(hideimg))
                BlurEffectView.addGestureRecognizer(tapblurview)
                let tapblurviewtotal = UITapGestureRecognizer(target: self, action: #selector(hideimgtotal))
                AppDelegate.blureffectview.addGestureRecognizer(tapblurviewtotal)

            }
            else{
                self.showtoast(controller: self, message: "Select a image first", seconds: 1.5)
            }
        }
        else{
            print("on")
        }
     
    }
    var BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    var BlurEffectView = UIVisualEffectView()
    func BlurView(view: UIView){
        
        BlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        BlurEffectView = UIVisualEffectView(effect: BlurEffect)
        BlurEffectView.backgroundColor = UIColor.lightGray
        BlurEffectView.alpha = 0.2
        BlurEffectView.frame = view.bounds
//        AppDelegate.blureffectview=BlurEffectView
        view.addSubview(BlurEffectView)
    }
    @objc func hideimg(sender: UITapGestureRecognizer) {
        
        self.imageView!.removeFromSuperview()
        BlurEffectView.removeFromSuperview()
       
    }
    @objc func hideimgtotal(sender: UITapGestureRecognizer) {
        self.imageView!.removeFromSuperview()
        BlurEffectView.removeFromSuperview()
    }
    
    @objc func showActionSheet(sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            print("tag ========>\(Int8((sender.view?.tag)!))")
            self.camera(value: Int8((sender.view?.tag)!))
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera(value : Int8)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .camera
            myPickerController.view.tag = Int(value)
            self.present(myPickerController,animated: true,completion: nil)
        }
    }
    
    func imagetobase(image: UIImage)-> String {
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
              let img = UIImageJPEGRepresentation(image,0.0)
              let strBase64 = (img?.base64EncodedString(options: .lineLength64Characters))!
              print("0.0 size is: \(String(describing: Double((img?.count)!) / 1024.0)) KB")
              return strBase64
    }
    
    func setfeedbackspinner() {
        feedbackTypeSpinner.optionArray.removeAll()
        feedbackTypeSpinner.optionIds?.removeAll()
        idarr.removeAll()
        var stmt1: OpaquePointer?
        let query = "select '0' as typecode,'Select' as feedbacK_TYPE union select typecode,feedbacK_TYPE from feedbacktype"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 1))
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            feedbackTypeSpinner.optionArray.append(itemname)
            feedbackTypeSpinner.optionIds?.append(Int(itemid) ?? 0)

//            feedbackTypeSpinner.optionIds?.append(itemid)
            idarr.append(String(cString: sqlite3_column_text(stmt1, 0)))
        }
        feedbackTypeSpinner.text = feedbackTypeSpinner.optionArray[0]
    }
//    var initialPointOffset: CGFloat {
//        return pullUpControllerPreferredSize.height
//    }
    
//    override var pullUpControllerPreferredSize: CGSize {
//        return portraitSize
//    }
//    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
//        return [secondPreviewView.frame.maxY, secondPreviewView.frame.maxY]
//    }
//
//    override var pullUpControllerIsBouncingEnabled: Bool {
//        return false
//    }
    
    func setproductspinnr()
    {
        productSpnr.optionArray.removeAll()
        productSpnr.optionIds?.removeAll()
        var stmt1: OpaquePointer?
        let query = "select distinct itemgroupid,itemname from ItemMaster where isblocked='false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemname = String(cString: sqlite3_column_text(stmt1, 1))
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            productSpnr.optionArray.append(itemname)
            productSpnr.optionIds?.append(Int(itemid) ?? 0)

        //    productSpnr.optionIds?.append(itemid)
        }
    }
    
    @IBAction func cancelbtn(_ sender: Any) {
       removebottomsheet()
//        removePullUpController(self, animated: true)
    }
    func removebottomsheet(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { ()->Void in
            self.view.frame  = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
            
        })
        { (finished) in
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
        AppDelegate.blureffectview.removeFromSuperview()
        print("cancel")
        
    }
    func showtoast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message,  preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated : true)
        }
    }
    @IBAction func submit(_ sender: Any) {
        let base = Baseactivity()
        let postapi = Postapi()

        if (self.productSpnr.text != "") {
            if (self.feedbackTypeSpinner.text != "Select") {
                if (self.descriptionLbl.text != "" && self.descriptionLbl.text != "Add your descripition here.."){
                    let database = Databaseconnection()
                    
                    database.insertcomplains(compid: self.id as NSString, DATAAREAID: UserDefaults.standard.string(forKey: "dataareaid")! as NSString, FEEDBACKTYPE:  idtype! as NSString, CATEGORY: self.category as NSString, SITEID: AppDelegate.siteid as NSString, ITEMID: self.itemid as NSString, FEEDBACKDESC: self.descriptionLbl!.text! as NSString, SUBMITDATETIME: self.dateLbl!.text! as NSString, CUSTOMERCODE: self.customercode as NSString, USERCODE: UserDefaults.standard.string(forKey: "usercode")! as NSString, post: "0", LATITUDE: "0", LONGITUDE: "0", createdby: UserDefaults.standard.string(forKey: "usercode")! as NSString, image: clickedimg == nil ? "-1" : imagetobase(image: clickedimg!) as NSString)
                    
                   postapi.postFeedbacks()
                    removebottomsheet()
                    if self.category == "Product"{
                        self.showtoast(controller: self, message: "Product complaint launched", seconds: 1.5)
                    }
                    else{
                         self.showtoast(controller: self, message: "Service complaint launched", seconds: 1.5)
                    }
//                    removePullUpController(self, animated: true)
                
                }
                else {
                    base.showtoast(controller: self, message: "Please enter Description", seconds: 1.5)
                }
            }
            else {
                base.showtoast(controller: self, message: "Please Select a type", seconds: 1.5)
            }
        }
        else {
            base.showtoast(controller: self, message: "Please Select an item", seconds: 1.5)
        }
    }
}

extension ComplaintBottomSheet: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if var image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = UIImage(data: UIImageJPEGRepresentation(image, JPEGQuality.lowest.rawValue)!)!
            self.imagePickedBlock?(image)
          clickedimg=image
        }else{
            print("Something went wrong")
        }
        picker.dismiss(animated: false, completion: {
            self.view.layoutIfNeeded()
        })
        
    }
}

