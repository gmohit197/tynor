//
//  Orderdetailcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 29/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Orderdetailcell: UITableViewCell {
    
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var amount: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
