//
//  CareBabyTimeCell.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/14.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class CareBabyTimeCell: UITableViewCell {
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
