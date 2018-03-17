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
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var viewDivider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWithData(data: [String : String], _ isLastItem : Bool) {
        
        self.imageIcon.image = UIImage.init(named: data["icon"]!)
        self.labelTitle.text = LS(data["title"]!)
        self.viewDivider.isHidden = isLastItem
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
