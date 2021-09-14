//
//  Complaintcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 02/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Complaintcell: UITableViewCell {
    
    @IBOutlet weak var complaintno: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet var cretedBy: UILabel!
    @IBOutlet var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
