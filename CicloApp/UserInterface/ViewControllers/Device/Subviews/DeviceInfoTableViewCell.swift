//
//  DeviceInfoTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class DeviceInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var viewDivider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateWithData(data: [String : String], _ isLastItem : Bool) {
        
        self.labelTitle.text = LS(data["title"]!)
        self.imageArrow.image = UIImage.init(named: "forward")?.tint(with: Config.shared.textColor())
        self.viewDivider.isHidden = isLastItem
        
        self.labelTitle.textColor = Config.shared.textColor()
        
        self.viewDivider.backgroundColor = Config.shared.dividerColor()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
