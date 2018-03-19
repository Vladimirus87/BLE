//
//  SettingsModeTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 17.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsModeTableViewCell: SettingsTableViewCell {

    @IBOutlet weak var switchMode: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.switchMode.backgroundColor = UIColor.lightGray
        self.switchMode.tintColor = UIColor.lightGray
        self.switchMode.layer.cornerRadius = 16
    }

    override func updateWithData(data: [String : String]) {
        super.updateWithData(data: data)
        
        if self.data!["dark_mode"] != nil {
            self.switchMode.isOn = (Config.shared.colorMode == .dark)
        }
        
        self.switchMode.onTintColor = Config.shared.baseColor()
        
        self.switchMode.thumbTintColor = (Config.shared.colorMode == .dark) ? .black : .white
        
    }
    
    @IBAction func switchModeValueChanged(_ sender: UISwitch) {
    
        if self.data!["dark_mode"] != nil {
            Config.shared.updateColorMode(switchMode.isOn)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
