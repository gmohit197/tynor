//
//  AppDelegate.swift
//  tynorios
//
//  Created by Acxiom on 18/09/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var blureffectview = UIVisualEffectView()
    var window: UIWindow?
    var reachability: Reachability!
    //static var spinner  = true
    static var menubool = true
    static var totalapi = 23;
    static var ntwrk = 0;
    static var issync = 0;
    static var titletxt = "";
    static var customercode = "";
    static var ncustcode = "";
    static var customername = "";
    static var doccode = "";
    static var hoscode = "";
    static var usertype = "";
    static var retailerper: Float = 0;
    static var genralDetailsper: Float = 0;
    static var doctorper: Float = 0;
    static var hospitalper: Float = 0;
    static var source = ""
    static var siteid = ""
    static var navtitle = ""
    static var isorderList = true
    static var backscreenDel = ""
    static var chemistcheck = false
    static var popviewcontrolllercheck = false
    static var showDocList = true
    static var taxapi : Int = 0
    static var priceapi : Int = 0
    static var customercodeNew = "";
    static var hospitallistcheck = false;
    static var expensecheck = false
    static var chemcustcode = "";
    static var chemdoccode = "";
    static var chemhoscode = "";
    static var isChemist = false
    static var isDash = false
    static var showHosList = true
    static var isFromSalesPersonList = false
    static var isFromCustomerCardList = false
    static var isFromRetailer = false
    static var isMobileBlock = false
    static var customerTypePE = "";
    static var spinnetextPE = "";
    static var pendingEscalationCustomerName = ""
    static var postDocCode = ""
    static var custTypeMIDoctorVc = ""
    static var custCardSync = 0
    static var hosDealerId = ""
    static var cityNameSpinner = ""
    static var cityidSpinner = ""
    static var isBottomSheetSync = 0
    static var custCodeBottomSheet = ""
    static var hosDealerName = ""
    static var isDebug = false
    static var isDataCount = true
    static var isPosted = 0;
    static var retcustomercode = "";
    static var doccustomercode = "";
    static var hoscustomercode = "";
    static var isDocScreen = false;
    static var isRetScreen = false;
    static var isHosScreen = false;
    static var isFromRetailerScreen = false;
    static var isFromDoctorScreen = false;
    static var isFromHospitalScreen = false;
    static var oldhoscode = "";
    static var isProdIntentDone = 0;
    static var isPostedRetailer = 0;
    static var isFromMiStock = false;
    static var oldChemcustomercode = "";
    static var oldcustomercodeFromRetailList = "";



     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
             print("--didFinishLaunchingWithOptions")
            
          IQKeyboardManager.shared.enable = true
      //    DropDown.startListeningToKeyboard()

         let navigationBarAppearace = UINavigationBar.appearance()
         
        // let appColor = UIColor(red: 138.0 / 255.0, green: 17.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
         let appColor = hexStringToUIColor(hex:"#8a1154")

         navigationBarAppearace.tintColor = appColor
         navigationBarAppearace.barTintColor = appColor
         navigationBarAppearace.isTranslucent = false
         
         // change navigation item title color
         navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            do {
            try reachability = Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability.startNotifier()
            } catch {
                 print("This is not working.")
            }
            //MARK:- MS app center
        
//          MSAppCenter.start("11b1430f-4ca8-4ad4-ac91-e570d21d8c44", withServices:[
//              MSAnalytics.self,
//              MSCrashes.self
//            ])
//            MSCrashes.setEnabled(true)
//            MSCrashes.setUserConfirmationHandler({ (errorReports: [MSErrorReport]) in
//
//              // Your code to present your UI to the user, e.g. an UIAlertController.
//              MSCrashes.notify(with: .always)
//              return true // Return true if the SDK should await user confirmation, otherwise return false.
//            })
            return true
        }
        
        @objc func reachabilityChanged(_ note: NSNotification) {
        print("ReachabilityChangedCalled============")
        let reachability = note.object as! Reachability
            var image = UIImage(named: "")
        if reachability.connection != .unavailable {
        if reachability.connection == .wifi {
        print("Reachable via WiFi")
            AppDelegate.ntwrk = 1
            
        } else {
        print("Reachable via Cellular")
            AppDelegate.ntwrk = 1
            
        }
        }
        else {
        print("Not reachable")
            AppDelegate.ntwrk = 0
            
        }
            window = UIApplication.shared.windows[0]
            let base = Baseactivity()
            base.setnavAppDelegate(title: "")
        }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

