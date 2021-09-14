//
//  MiStockvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 02/07/19.
//  Copyright © 2019 Acxiom. All rights reserved.

import UIKit
import CoreLocation
import SQLite3
import SwiftEventBus

class MiStockvc: Executeapi, UINavigationControllerDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var stockimage: UIImageView!
    @IBOutlet weak var storeimage: UIImageView!
    @IBOutlet var storeHeader: UILabel!
    
    var lat: String!
    var longi: String!
    var locationManager:CLLocationManager!
    var imagePickedBlock: ((UIImage) -> Void)?
    var stockimagebasestr:String!
    var storeimagebasestr:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(AppDelegate.isDebug){
            print(AppDelegate.customercode)
        }
        stockimage.contentMode = .scaleAspectFill
        storeimage.contentMode = .scaleAspectFill
        stockimage.clipsToBounds = true
        storeimage.clipsToBounds = true
        if(AppDelegate.isChemist){
        self.gtmiimage(s: "0",customercode: AppDelegate.chemcustcode)
        self.gtmiimage(s: "1",customercode: AppDelegate.chemcustcode)
        }
        else{
            self.gtmiimage(s: "0",customercode: AppDelegate.customercode)
            self.gtmiimage(s: "1",customercode: AppDelegate.customercode)

        }

        //        if let image = stockimagebasestr{
        //
        //            let imageData = Data(base64Encoded: image, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        //           stockimage.image=UIImage(data: imageData)!
        //        }
        //        if let image = storeimagebasestr{
        //            let imageData = Data(base64Encoded: image, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        //            storeimage.image=UIImage(data: imageData)!
        //        }
        
        stockimage.isUserInteractionEnabled = true
        let tapimg1 = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        tapimg1.numberOfTapsRequired = 1
        stockimage.addGestureRecognizer(tapimg1)
        
        storeimage.isUserInteractionEnabled = true
        let tapimg2 = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        tapimg2.numberOfTapsRequired = 1
        storeimage.addGestureRecognizer(tapimg2)
        lat = "0"
        longi = "0"
        locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
//        determineMyCurrentLocation()
        // Do any additional setup after loading the view.
        
        self.updateprog()
    }
    func updateprog(){
        if(AppDelegate.isChemist){
            self.storeHeader.text = "Stock & Store Image" + "(\(Int(getmiimage(s: "0", customercode: AppDelegate.chemcustcode) + getmiimage(s: "1", customercode: AppDelegate.chemcustcode)))%)"
        }
        else{
            self.storeHeader.text = "Stock & Store Image" + "(\(Int(getmiimage(s: "0", customercode: AppDelegate.customercode) + getmiimage(s: "1", customercode: AppDelegate.customercode)))%)"
        }
    }
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SwiftEventBus.onMainThread(self, name: "retailerdatapostedNew") { Result in
            self.hideloader()
            if(AppDelegate.isFromRetailerScreen && !AppDelegate.isFromCustomerCardList){
                if(AppDelegate.isPostedRetailer == 0 && AppDelegate.isFromMiStock){
                    AppDelegate.isPostedRetailer = 1
                    AppDelegate.isFromMiStock = false
                    self.showOkalert(controller: self)
                }
            }
            else{
                if(AppDelegate.isPostedRetailer == 0 && AppDelegate.isFromMiStock){
                    AppDelegate.isPostedRetailer = 1
                    AppDelegate.isFromMiStock = false
                    print("Intented from MIStockVc----Chemist")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SwiftEventBus.unregister(self, name: "retailerdataposted")
        SwiftEventBus.unregister(self, name: "retailerdatapostedNew")
        SwiftEventBus.unregister(self, name: "attachdocvcval")
    }
    
    
    func showOkalert(controller: UIViewController){
        let alert = UIAlertController(title: "Alert", message: "Data Posted Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "retailerlist") as! Retailerlistvc
            vc.titlebar = "Retailer"
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        present(alert, animated: true)
    }
    
    
    @IBAction func submitbtn(_ sender: UIButton) {
        self.checknet()
        if AppDelegate.ntwrk > 0 && !AppDelegate.chemistcheck{
            self.showloader(title: "Syncing")
            AppDelegate.isPostedRetailer = 0
            AppDelegate.isFromMiStock = true
            self.posthospitalMaster()
        }
        else {
            AppDelegate.chemistcheck = false
            AppDelegate.isChemist  = false
            if(AppDelegate.isFromHospitalScreen){
                AppDelegate.titletxt = "Hospital"
                AppDelegate.customercode = AppDelegate.hoscustomercode
                AppDelegate.hoscode = AppDelegate.oldhoscode
                AppDelegate.doccode = AppDelegate.oldhoscode
                 SwiftEventBus.unregister(self)
                SwiftEventBus.post("LinkingDone")
            }
           self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        stockimagebasestr=nil
//        storeimagebasestr=nil
//        lat=nil
//        longi=nil
        image=nil
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    var userLocation:CLLocation?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation  = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        // manager.stopUpdatingLocation()
        
   //     print("user latitude = \(userLocation!.coordinate.latitude)")
   //     print("user longitude = \(userLocation!.coordinate.longitude)")
        autoreleasepool {
            lat = String(userLocation!.coordinate.latitude)
            longi = String(userLocation!.coordinate.longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func imagetobase(image: UIImage)-> String {
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        let img = UIImageJPEGRepresentation(image,0.0)
        let strBase64 = (img?.base64EncodedString(options: .lineLength64Characters))!
        print("0.0 size is: \(String(describing: Double((img?.count)!) / 1024.0)) KB")
        return strBase64
    }
    func camera(value : Int8)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .camera
            myPickerController.view.tag = Int(value)
            self.present(myPickerController,animated: true,completion: nil)
        }
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
    public func gtmiimage(s: String?,customercode: String?){
        var stmt1:OpaquePointer?
        let query = "select * from StoreImage where type= '" + s! + "' and customercode = '" + customercode! + "'"
        if sqlite3_prepare_v2(Databaseconnection.dbs, query , -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            if(s=="0"){
               stockimage.image=UIImage(data:  Data(base64Encoded: String(cString: sqlite3_column_text(stmt1, 6)), options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!)!
            }
            else{
                storeimage.image=UIImage(data:  Data(base64Encoded: String(cString: sqlite3_column_text(stmt1, 6)), options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!)!
            }
            
            AppDelegate.retailerper += 20;
        }else if s! == "0" {
            getstockimage(customercode: customercode!)
        }else if s! == "1" {
            getstockimage(customercode: customercode!)
        }
    }
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
     var image:UIImage?
}

extension MiStockvc: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            image = UIImage(data: UIImageJPEGRepresentation(img, JPEGQuality.lowest.rawValue)!)!
            self.imagePickedBlock?(image!)
            let database = Databaseconnection()
//            lat = String(locationManager.location!.coordinate.latitude)
//            longi = String(locationManager.location!.coordinate.longitude)
            lat = "0"
            longi = "0"
            let base = Baseactivity()
            switch(picker.view.tag){
            case 1:
                stockimage.image=image
                if(AppDelegate.isChemist){
                database.insertStoreImage(ids: self.getID(), userId: UserDefaults.standard.string(forKey: "usercode"), dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), customercode: AppDelegate.chemcustcode, siteid: AppDelegate.siteid, post: "0", type: "0", getdate: base.getdate(), latitude: self.lat, longitude: self.longi, storestockimage: imagetobase(image: image!))
                }
                else{
                    database.insertStoreImage(ids: self.getID(), userId: UserDefaults.standard.string(forKey: "usercode"), dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), customercode: AppDelegate.customercode, siteid: AppDelegate.siteid, post: "0", type: "0", getdate: base.getdate(), latitude: self.lat, longitude: self.longi, storestockimage: imagetobase(image: image!))
                }
                SwiftEventBus.post("updateprogress")
                self.updateprog()
                break
            case 2:
                storeimage.image=image
                if(AppDelegate.isChemist){
                database.insertStoreImage(ids: self.getID(), userId: UserDefaults.standard.string(forKey: "usercode"), dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), customercode: AppDelegate.chemcustcode, siteid: AppDelegate.siteid, post: "0", type: "1", getdate: base.getdate(), latitude: self.lat, longitude: self.longi, storestockimage: imagetobase(image: image!))
                }
                else{
                    database.insertStoreImage(ids: self.getID(), userId: UserDefaults.standard.string(forKey: "usercode"), dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), customercode: AppDelegate.customercode, siteid: AppDelegate.siteid, post: "0", type: "1", getdate: base.getdate(), latitude: self.lat, longitude: self.longi, storestockimage: imagetobase(image: image!))
                }
                 SwiftEventBus.post("updateprogress")
                self.updateprog()
                break
                
            default:
                 if(AppDelegate.isChemist){
                database.insertStoreImage(ids: self.getID(), userId: UserDefaults.standard.string(forKey: "usercode"), dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), customercode: AppDelegate.chemcustcode, siteid: AppDelegate.siteid, post: "0", type: "1", getdate: base.getdate(), latitude: self.lat, longitude: self.longi, storestockimage: imagetobase(image: image!))
                 }
                 else{
                    database.insertStoreImage(ids: self.getID(), userId: UserDefaults.standard.string(forKey: "usercode"), dataareaid: UserDefaults.standard.string(forKey: "dataareaid"), customercode: AppDelegate.customercode, siteid: AppDelegate.siteid, post: "0", type: "1", getdate: base.getdate(), latitude: self.lat, longitude: self.longi, storestockimage: imagetobase(image: image!))
                 }
                break
            }
        }else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    func compressImage() -> UIImage {

        let oldImage = UIImage(named: "background.jpg")
        var imageData =  Data(UIImagePNGRepresentation(oldImage!)! )
        print("** Uncompressed Size \(imageData.description) *** ")

        imageData = UIImageJPEGRepresentation(oldImage!, 0.025)!
        print("** Compressed Size \(imageData.description) *** ")

        let image = UIImage(data: imageData)
        return image!

    }
}
