//
//  Profiledetailcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 30/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Profiledetailcell: UITableViewCell {
    
    @IBOutlet weak var employee: UILabel!
    
    @IBOutlet weak var customertype: UILabel!

    @IBOutlet weak var noofCustomer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
