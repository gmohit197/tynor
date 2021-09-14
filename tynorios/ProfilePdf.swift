
import UIKit

class ProfilePdf: Executeapi {

    var jobdesc: String?
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setnav(controller: self, title: "My Profile")
        
        self.checknet()
        if AppDelegate.ntwrk > 0
        {
            let url: URL! = URL(string: self.jobdesc!)
            webview.loadRequest(URLRequest(url: url))
        }
    }
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeBtn(_ sender: Any) {
        self.getToHome(controller: self)
    }
}
