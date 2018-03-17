//
//  MainTabCollectionViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 13.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class MainTabCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    func updateWithTabInfo(tabInfo: [String : String], isSelected: Bool) {
        
        let color : UIColor = isSelected ? Config.shared.baseColor() : Config.shared.tabsInactiveColor()
        
        if let image = UIImage.init(named: tabInfo["image"]!) {
            self.imageIcon.image = image.tint(with: color)
        }
        self.labelTitle.text = NSLocalizedString(tabInfo["title"]!, comment: "")
        self.labelTitle.textColor = color
        
        //let alpha : CGFloat = isSelected ? 1.0 : 0.5
        //self.imageIcon.alpha = alpha
        //self.labelTitle.alpha = alpha
        
    }
}
