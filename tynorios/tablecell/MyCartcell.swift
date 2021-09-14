//
//  MyCartcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 11/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class MyCartcell: UITableViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var paybleamt: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
