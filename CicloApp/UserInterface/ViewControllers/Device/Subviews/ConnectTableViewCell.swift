//
//  ConnectTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit


@objc protocol ConnectTableViewCellDelegate: class {
    func connectCellPairPressed(_ value: Any?)
}

class ConnectTableViewCell: UITableViewCell {

    weak var delegate: ConnectTableViewCellDelegate?

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonPair: CAButton!
    @IBOutlet weak var viewDivider: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithData(value: Any?, _ isLastItem : Bool) {
        
        self.viewDivider.isHidden = isLastItem
        
        self.labelTitle.textColor = (Config.shared.colorMode == .light) ? .black : .white
        self.buttonPair.backgroundColor = Config.shared.baseColor()
        self.viewDivider.backgroundColor = Config.shared.dividerColor()
        labelTitle.text = (value as? String) ?? "HAC1.2"
    }
    
    @IBAction func buttonPairPressed(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.connectCellPairPressed(nil)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
