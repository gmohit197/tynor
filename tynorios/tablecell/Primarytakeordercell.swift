//
//  Primarytakeordercell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 12/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Primarytakeordercell: UITableViewCell {
    
    @IBOutlet weak var orderno: UILabel! // 1
    @IBOutlet weak var date: UILabel!//2
    @IBOutlet weak var amount: UILabel!//5
    @IBOutlet weak var paybleamt: UILabel!//4
    @IBOutlet weak var qty: UILabel!//3
    @IBOutlet weak var status: UILabel!//6
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
