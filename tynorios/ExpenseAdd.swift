//
//  ExpenseAdd.swift
//  tynorios
//
//  Created by Acxiom Consulting on 14/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SQLite3
import Foundation

class ExpenseAdd: Executeapi, UINavigationControllerDelegate, UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    var noofimagesincollectionview=2
    var imageset  = [UIImage?](repeating: nil, count: 4)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noofimagesincollectionview
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! addexpenseCollectionViewCell
        
        if(indexPath.row == noofimagesincollectionview-1){
            cell.cellimage.image = UIImage(named: "add_more")
            
        }
        else{
            let image = UIImage(named: "default_product_image")
            cell.cellimage.image = imageset[indexPath.row]
            cell.cellimageview.tag=noofimagesincollectionview-2
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if noofimagesincollectionview==5 && indexPath.row==4{
           self.showtoast(controller: self, message: "No More Images Allowed", seconds: 1.0)
            return
        }
        if(indexPath.row == noofimagesincollectionview-1){
            noofimagesincollectionview+=1
            Imagecollectionview.reloadData()
        }
        else{
            showActionSheet(index:indexPath.row)
        }
    }
        enum JPEGQuality: CGFloat {
            case lowest  = 0
            case low     = 0.25
            case medium  = 0.5
            case high    = 0.75
            case highest = 1
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var locationlbl: SkyFloatingLabelTextField!
    @IBOutlet weak var balanceta: SkyFloatingLabelTextField!
    @IBOutlet weak var talbl: SkyFloatingLabelTextField!
    @IBOutlet weak var dalbl: SkyFloatingLabelTextField!
    @IBOutlet weak var miscellanouslbl: SkyFloatingLabelTextField!
    
 
    @IBOutlet var Imagecollectionview: UICollectionView!
    
    @IBOutlet weak var tawarning: UILabel!
    
    var returncatch = returncatcher()
    
    var cityid: String?
    var cityname: String?
    var balancetastr: Double?
    var tastr: Double?
    var working: String?
    
    var img0: String?
    var img1: String?
    var img2: String?
    var img3: String?
    
    var boolimg0 : Bool = false
    var boolimg1 : Bool = false
    var boolimg2 : Bool = false
    var boolimg3 : Bool = false
    
    
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...3{
            imageset[i]=UIImage(named: "default_product_image")
        }
        self.setnav(controller: self, title: "Expense")
        
//        self.hideKeyboardWhenTappedAround()
        balanceta.isUserInteractionEnabled = false
        balanceta.text = ""
        locationlbl.isUserInteractionEnabled = false
        talbl.text = ""
        tawarning.isHidden = true
        talbl.delegate = self
        dalbl.delegate = returncatch
        miscellanouslbl.delegate = returncatch
        Imagecollectionview.delegate=self
        Imagecollectionview.dataSource=self
        
//        imageset.append(UIImage(named: "")!)
//        imageset.append(UIImage(named: "")!)
//        imageset.append(UIImage(named: "")!)
//        imageset.append(UIImage(named: "")!)
//        image1.isUserInteractionEnabled = true
//        let tapimg1 = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
//        tapimg1.numberOfTapsRequired = 1
//        image1.addGestureRecognizer(tapimg1)
//
//        image2.isUserInteractionEnabled = true
//        let tapimg2 = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
//        tapimg2.numberOfTapsRequired = 1
//        image2.addGestureRecognizer(tapimg2)
//
//
//        image3.isUserInteractionEnabled = true
//        let tapimg3 = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
//        tapimg3.numberOfTapsRequired = 1
//        image3.addGestureRecognizer(tapimg3)
//
//
//        image4.isUserInteractionEnabled = true
//        let tapimg4 = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
//        tapimg4.numberOfTapsRequired = 1
//        image4.addGestureRecognizer(tapimg4)
        
        
        
//        image1.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleBottomMargin.rawValue | UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleRightMargin.rawValue | UIViewAutoresizing.flexibleLeftMargin.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue | UIViewAutoresizing.flexibleWidth.rawValue)
//        image1.contentMode = UIViewContentMode.scaleAspectFit
   
        self.datelbl.text = getdate()
        setcity()
        
        
    }
    
    @IBAction func setlimitlbl(_ sender: SkyFloatingLabelTextField) {
        
        let newText = sender.text
        if newText == ""{
            tastr = 0
            
        }
        else {
            tastr = Double(newText!)
        }
        
        balanceta.text  = String(balancetastr! - tastr!)
        
        if (balancetastr! - tastr!) < 0 {
            tawarning.isHidden = false
        }
        else {
            tawarning.isHidden = true
        }
        
    }
    
    func setcity()
    {
        var stmt1: OpaquePointer?
        let query = "select * from UserCurrentCity A inner join CityMaster B on A.city = B.CityID where A.date like '\(self.getdate())%' and isBlocked= 'false'"
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            locationlbl.text = String(cString: sqlite3_column_text(stmt1, 5))
            cityid = String(cString: sqlite3_column_text(stmt1, 1))
            cityname = String(cString: sqlite3_column_text(stmt1, 5))
            
        }
        
        let queryta = "select case when (select locationtype from UserLinkCity where cityid='\(cityid!)')='HQ' then (select headquater from ProfileDetail) when (select locationtype from UserLinkCity where cityid='\(cityid!)')='EXHQ' then (select exheadquater from ProfileDetail) when (select locationtype from UserLinkCity where cityid='\(cityid!)')=='OUTSTATION' then (select outstation from ProfileDetail) end as DA ,(select locationtype from UserLinkCity where cityid='\(cityid!)' ) as workingtype,(select balanceta from profiledetail) as balanceta,(select balancemiscellaneous from profiledetail) as balancemiscellaneous "
        
        if sqlite3_prepare_v2(Databaseconnection.dbs, queryta, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return;
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            balanceta.text = String(cString: sqlite3_column_text(stmt1, 2))
            dalbl.text = String(cString: sqlite3_column_text(stmt1, 0))
            working = String(cString: sqlite3_column_text(stmt1, 1))
        }
        
        balancetastr = Double(balanceta.text!)
    }
    
    func camera(value : Int8)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.view.tag = Int(value)
            self.present(myPickerController,animated: true,completion: nil)
        }
    }
    
     func showActionSheet(index: Int) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            print("tag ========>\(Int8((index)))")
            self.camera(value: Int8((index)))
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func backbtn(_ sender: Any) {
       // dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addbtn(_ sender: UIButton) {
        self.checknet()
        if AppDelegate.ntwrk > 0 {
            self.showalertmsg()
        }
        else {
           self.showtoast(controller: self, message: "Please Check Your Internet Connection", seconds: 1.5)
         }
    }
    
    func imagetobase(image: UIImage)-> String {
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        let img = UIImageJPEGRepresentation(image,0.0)
        let strBase64 = (img?.base64EncodedString(options: .lineLength64Characters))!
        print("0.0 size is: \(String(describing: Double((img?.count)!) / 1024.0)) KB")
        return strBase64
    }
    
    @IBAction func homebtn(_ sender: Any) {
        getToHome(controller: self)
    }
    
    func showalertmsg(){
        
        if(boolimg0){
            img0 = self.imagetobase(image: self.imageset[0]!);
        }
        else {
            img0 = "-1"
        }
       if (boolimg1){
            img1 = self.imagetobase(image: self.imageset[1]!);
        }
       else{
           img1 = "-1"
        }
        if (boolimg2){
            img2 = self.imagetobase(image: self.imageset[2]!);
         }
        else{
            img2 = "-1"
        }
        if (boolimg3){
             img3 = self.imagetobase(image: self.imageset[3]!);
        }
        else{
            img3 = "-1"
        }
       
        
        let alert = UIAlertController(title: "Are you sure you want to Submit", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.insertExpense(expenseid: self.getID(), expensedate: self.datelbl.text!, location: self.locationlbl.text!, da: self.dalbl.text!, ta: self.talbl.text!, hotelexpense: "0", miscellanous: self.miscellanouslbl.text!, expenseimage: self.img0, expenseimage2:  self.img1, expenseimage3:  self.img2, expenseimage4:  self.img3, post: "0", workingtype: self.working!)
                
                let post = Postapi()
                post.postExpense()
            self.showtoast(controller: self, message: "Expense Submitted", seconds: 1.5)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.01) {
          let expensereport: ExpenseReport = self.storyboard?.instantiateViewController(withIdentifier: "expense") as! ExpenseReport
            self.navigationController?.pushViewController(expensereport, animated: true)
                    }
            }
        ))
        present(alert, animated: true)
    }
    
}

 extension ExpenseAdd: UIImagePickerControllerDelegate {
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
             self.imagePickedBlock?(image)
//            UIImageJPEGRepresentation(jpegQuality.rawValue, image)
            let comimage = UIImage(data: UIImageJPEGRepresentation(image, JPEGQuality.lowest.rawValue)!)
            switch(picker.view.tag){
            case 0:
                let ip = IndexPath(row: picker.view.tag, section: 0)
                
                self.boolimg0 = true
                     
                let cell = Imagecollectionview!.dequeueReusableCell(withReuseIdentifier: "cell", for: ip ) as! addexpenseCollectionViewCell
                cell.cellimage.image=comimage
                imageset[picker.view.tag]=comimage!
                Imagecollectionview.reloadData()
                
                break;
            case 1:
                let ip = IndexPath(row: picker.view.tag, section: 0)
                
                
                self.boolimg1 = true
                
                let cell = Imagecollectionview!.dequeueReusableCell(withReuseIdentifier: "cell", for: ip ) as! addexpenseCollectionViewCell
                cell.cellimage.image=comimage
                imageset[picker.view.tag]=comimage!
                Imagecollectionview.reloadData()

            break;
            case 2:
                let ip = IndexPath(row: picker.view.tag, section: 0)
                
                self.boolimg2 = true
                      
                let cell = Imagecollectionview!.dequeueReusableCell(withReuseIdentifier: "cell", for: ip ) as! addexpenseCollectionViewCell
                cell.cellimage.image=comimage
                imageset[picker.view.tag]=comimage!
                Imagecollectionview.reloadData()

            break;
            case 3:
                let ip = IndexPath(row: picker.view.tag, section: 0)
                
                self.boolimg3 = true
                
                let cell = Imagecollectionview!.dequeueReusableCell(withReuseIdentifier: "cell", for: ip ) as! addexpenseCollectionViewCell
                cell.cellimage.image=comimage
                imageset[picker.view.tag]=comimage!
                Imagecollectionview.reloadData()

            break;
//            case 4:
//                let ip = IndexPath(row: 3, section: 0)
//                let cell = Imagecollectionview!.dequeueReusableCell(withReuseIdentifier: "cell", for: ip ) as! addexpenseCollectionViewCell
//                cell.cellimage.image=comimage
//                imageset[3]=comimage!
//            break;

            default:
                break
            }
        }else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
