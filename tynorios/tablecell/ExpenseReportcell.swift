//
//  ExpenseReportcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class ExpenseReportcell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var TA: UILabel!
    @IBOutlet weak var DA: UILabel!
    @IBOutlet weak var misscelions: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var city: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
