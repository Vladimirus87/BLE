//
//  SettingsGeneralTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 17.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsGeneralTableViewCell: SettingsTableViewCell {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func updateWithData(data: [String : String], _ isLastItem : Bool) {
        super.updateWithData(data: data, isLastItem)
        
        self.imageArrow.image = UIImage.init(named: "forward")?.tint(with: Config.shared.textColor())
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
