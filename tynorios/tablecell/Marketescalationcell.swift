//
//  Marketescalationcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 27/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Marketescalationcell: UITableViewCell {

    @IBOutlet weak var escalationlbl: UILabel!
    @IBOutlet weak var escalationno: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet var cretedby: UILabel!
    @IBOutlet weak var cretedByStack: UIStackView!
    @IBOutlet weak var statusStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
