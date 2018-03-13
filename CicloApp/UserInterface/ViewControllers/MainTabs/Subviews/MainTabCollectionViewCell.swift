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
        
        self.imageIcon.image = UIImage.init(named: tabInfo["image"]!)
        self.labelTitle.text = NSLocalizedString(tabInfo["title"]!, comment: "")
        
    }
}
