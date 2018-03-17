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
        
        self.switchMode.onTintColor = UIColor.colorRGB("6694F9")
        self.switchMode.backgroundColor = UIColor.lightGray
        self.switchMode.tintColor = UIColor.lightGray
        self.switchMode.layer.cornerRadius = 16
    }

    override func updateWithData(data: [String : String], _ isLastItem : Bool) {
        super.updateWithData(data: data, isLastItem)
        
        self.switchMode.isOn = (Config.shared.colorMode == .dark)
        self.switchMode.thumbTintColor = self.switchMode.isOn ? .black : .white
        
    }
    
    @IBAction func switchModeValueChanged(_ sender: UISwitch) {
    
        Config.shared.updateColorMode(switchMode.isOn)
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
