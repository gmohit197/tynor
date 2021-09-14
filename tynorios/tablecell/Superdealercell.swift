//
//  Superdealercell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 01/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Superdealercell: UITableViewCell {

    @IBOutlet weak var custname: UILabel!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var curmonth: UILabel!
    @IBOutlet weak var c: UILabel!
    @IBOutlet weak var lastvisit: UILabel!
    @IBOutlet weak var stackdetail: UIStackView!
    @IBOutlet weak var sign: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let lineView = UIView(frame: CGRect(x: 317, y: 8, width: 1.0, height: 130.0))
//        lineView.layer.borderWidth = 0.8
//        lineView.layer.borderColor = UIColor.lightGray.cgColor
//        self.stackdetail.addSubview(lineView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
