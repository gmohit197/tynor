//
//  Attachdoccell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 26/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Attachdoccell: UITableViewCell {

    
    @IBOutlet weak var docname: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    @IBAction func checkbox(_ sender: UIButton) {
//        if sender.isSelected == true {
//                animatebtn()
//            }
//        else {
//            animatebtn()
//        }
//    }
//    func animatebtn(){
//        print("animation started")
//        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//            self.checkbox.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//
//        }) { (success) in
//            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
//
//                self.checkbox.transform = .identity
//            }, completion: nil)
//        }
//    }
}
