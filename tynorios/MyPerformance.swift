import UIKit
import SwipeViewController

class MyPerformance: SwipeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let page_one = stb.instantiateViewController(withIdentifier: "page1")  as UIViewController
        page_one.title = "My Performance"
        equalSpaces = false
        setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 18), color: .white, selectedColor: .white)
        setButtonsOffset(130, bottomOffset: 8)
        let page_two = stb.instantiateViewController(withIdentifier: "page2")  as UIViewController
        let page_three = stb.instantiateViewController(withIdentifier: "page3") as UIViewController
        let page_four = stb.instantiateViewController(withIdentifier: "page4")  as UIViewController
        
        setViewControllerArray([page_one, page_two, page_three,page_four])
        setFirstViewController(0)
        
        setNavigationColor(colorWithHexString(hexString: "#8A1154"))
        let image = UIImage(named: "backbtn")
        let homeImage = UIImage(named: "menu_icon")
        
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(goback))
        let homeButtonItem = UIBarButtonItem(image: homeImage, style: .plain, target: self, action: #selector(goback))
        setNavigationWithItem(colorWithHexString(hexString: "#8A1154"), leftItem: barButtonItem, rightItem: homeButtonItem)
        
        self.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    @objc func goback()
    {
        dismiss(animated: false, completion: nil)
    }
    
    func colorWithHexString(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
