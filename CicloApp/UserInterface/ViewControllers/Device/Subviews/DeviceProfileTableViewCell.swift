//
//  DeviceProfileTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 17.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DeviceProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var viewDivider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithProfile(profile: CAProfile, _ isLastItem : Bool) {
        
        self.labelTitle.text = "\(LS("profile")) \(profile.id!)"
        self.labelSubTitle.text = profile.profileName as! String
        
        self.imageArrow.image = UIImage.init(named: "forward")?.tint(with: Config.shared.textColor())
        self.viewDivider.isHidden = isLastItem
        
        self.labelTitle.textColor = Config.shared.textColor()
        self.labelSubTitle.textColor = Config.shared.subTextColor()
        
        self.viewDivider.backgroundColor = Config.shared.dividerColor()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
