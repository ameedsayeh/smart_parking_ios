//
//  ParkingTableViewCell.swift
//  Smart Parking
//
//  Created by Ameed Sayeh on 7/28/20.
//  Copyright © 2020 Ameed Sayeh. All rights reserved.
//

import UIKit

class ParkingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var freeLotsCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setup(viewModel: ParkingViewModel) {
        
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
        self.freeLotsCountLabel.text = "Free lots: \(viewModel.freeLots)"
        if let _distance = viewModel.distance {
            self.distanceLabel.text = "Distance: \(_distance) km"
        }
    }
}
