import UIKit

protocol QTY{
    func nextbtn(at index: IndexPath, textfield: UITextField)
}

class Ordreitemcell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var sizelbl: UILabel!
    @IBOutlet weak var qty: UITextField!
    @IBOutlet weak var price: UILabel!
    var delegate: QTY!
    var itemid: String!
    var index: IndexPath!
    var sono: String!
    var siteid: String!
    var custstate: String!
    var customercode: String!
    var toolbar = UIToolbar()
    var controller: UIViewController?
    var doneButton = UIBarButtonItem()
    
    let ACCEPTABLE_CHARACTERS = "0123456789"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
    
    
    @IBAction func qtyChange(_ sender: Any) {
        let qtyStr = (qty.text! as NSString)
        var qtyInt: Int
        
        if qtyStr == ""
        {
             qtyInt = 0
        }
        else{
            qtyInt = (qty.text! as NSString).integerValue
        }
            let db: Databaseconnection = Databaseconnection()
            let i:Int32 =  db.insertSoLineQty(siteid: siteid, sono:CustomerCard.orderid, customercode: customercode, itemid: itemid, qtyInt: qtyInt, price: price.text, discperc: "0", custstate: custstate)
            if i <= 0{
                qty.text = ""
                // showtoast(controller: self, message: "Tax Setup is not Available" , seconds: 2.0)
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: constant.key), object: controller)
        }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        let spacetButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextClicked));
        toolbar.sizeToFit()
        toolbar.setItems([doneButton,spacetButton,nextButton], animated: false)
        qty.inputAccessoryView = toolbar
    }
    @objc func doneClicked()
    {
        qty.resignFirstResponder()
    }
    @objc func nextClicked()
    {
        self.delegate.nextbtn(at: index, textfield: qty)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
