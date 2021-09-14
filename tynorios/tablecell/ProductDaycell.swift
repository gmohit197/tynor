//
//  ProductDaycell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 31/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class ProductDaycell: UITableViewCell {
    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var status: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
