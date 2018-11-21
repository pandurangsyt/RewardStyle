//
//  SampleTableViewCell.swift
//  RewardStyle
//
//  Created by Pandu on 11/20/18.
//  Copyright © 2018 123 Apps Studio LLC. All rights reserved.
//

import UIKit

class SampleTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var styelImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 25.0
        profileImageView.layer.borderWidth = 0.0
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
