//
//  SettingsLanguageTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 17.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsLanguageTableViewCell: SettingsTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func updateWithData(data: [String : String], object: NSObject?) {
        super.updateWithData(data: data, object: object)
        
        self.imageArrow.image = UIImage.init(named: data["arrow"]!)?.tint(with: Config.shared.textColor())
        self.labelSubTitle.text = data["value"]
        
        if (object != nil) {
            if let field = data["field"] {
                self.labelSubTitle.text = object!.value(forKey: field) as? String
            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
