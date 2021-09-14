//
//  Retailerlistcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 25/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Retailerlistcell: UITableViewCell {

    @IBOutlet weak var customername: UILabel!    
    @IBOutlet weak var distributor: UILabel!
    @IBOutlet weak var curmonth: UILabel!
    @IBOutlet weak var cf: UILabel!
    @IBOutlet weak var mi: UILabel!
    @IBOutlet weak var lastvisit: UILabel!
    @IBOutlet weak var cityname: UILabel!
    @IBOutlet weak var stackdetail: UIStackView!
    @IBOutlet weak var percribestack: UIView!
    @IBOutlet weak var sign: UIImageView!
    @IBOutlet weak var prescribe: UIImageView!
    @IBOutlet weak var purchase: UIImageView!
    @IBOutlet weak var uilineview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.percribestack.isHidden = true
        self.distributor.adjustsFontSizeToFitWidth = true
        // titleLabel.font = .boldSystemFont(ofSize: 14)
        if((self.distributor.text!.contains("Wrong"))){
            self.distributor.font = .systemFont(ofSize: 10)
        }
        else{
            self.distributor.font = .systemFont(ofSize: 13)

        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
