//
//  SettingsTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 17.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

@objc protocol SettingsTableViewCellDelegate: class {
    
}


class SettingsTableViewCell: UITableViewCell {

    weak var delegate: SettingsTableViewCellDelegate?

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var constraintContent: NSLayoutConstraint!
    
    var data: [String : String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateWithData(data: [String : String]) {
        self.updateWithData(data: data, object: nil)
    }
    
    func updateWithData(data: [String : String], object: NSObject?) {

        self.data = data
        
        if data["icon"] != nil {
            self.imageIcon.image = UIImage.init(named: data["icon"]!)?.tint(with: Config.shared.textColor())
            self.imageIcon.isHidden = false;
            self.constraintContent.constant = 64.0;
        } else {
            self.imageIcon.isHidden = true;
            self.constraintContent.constant = 24.0;
        }
        
        self.labelTitle.text = LS(data["title"]!)
        
        self.viewDivider.isHidden = (data["hide_divider"] != nil)
     
        self.labelTitle.textColor = Config.shared.textColor()
        if let labelSubTitle = self.labelSubTitle {
            labelSubTitle.textColor = Config.shared.subTextColor()
        }
        
        self.viewDivider.backgroundColor = Config.shared.dividerColor()
        self.layoutIfNeeded()
        
    }
    
    func closeKeyboard() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
