//
//  Textfielddelegate.swift
//  tynorios
//
//  Created by Acxiom Consulting on 16/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import UIKit

class returncatcher: NSObject, UITextFieldDelegate {
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
}
class profilecity: NSObject, UITableViewDelegate, UITableViewDataSource {
    var cityadpter = [Profilecityadapter]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityadpter.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! linkcitycell
        let list: Profilecityadapter
        list = cityadpter[indexPath.row]
        cell.citylbl.text  = list.city
        return cell
    }
}
