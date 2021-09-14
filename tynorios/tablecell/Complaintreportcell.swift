//
//  Complaintreportcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 10/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Complaintreportcell: UITableViewCell {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var customername: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var cno: UILabel!
    @IBOutlet weak var csttype: UILabel!
    @IBOutlet weak var createdby: UILabel!
    @IBOutlet weak var colorstatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
