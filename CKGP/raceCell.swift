//
//  raceCell.swift
//  CKGP
//
//  Created by Luke de Castro on 3/4/16.
//  Copyright © 2016 Luke de Castro. All rights reserved.
//

import UIKit

class raceCell: UITableViewCell {
    @IBOutlet var raceName: UILabel!
    @IBOutlet var raceDate: UILabel!
    @IBOutlet var raceDistance: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
