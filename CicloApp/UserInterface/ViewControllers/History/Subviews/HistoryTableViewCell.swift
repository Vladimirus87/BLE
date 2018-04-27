//
//  HistoryTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

@objc protocol HistoryTableViewCellDelegate: class {
    
    func historyActionSelected(_ track :CATrack)
    func historyDeleteSelected(_ track :CATrack)
}

class HistoryTableViewCell: UITableViewCell {

    weak var delegate: HistoryTableViewCellDelegate?

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonTrashcan: UIButton!
    @IBOutlet weak var viewAction: UIView!
    @IBOutlet weak var viewProgress: CAProgress!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var viewDivider: UIView!
    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet weak var leftConstantOfLbl: NSLayoutConstraint!
    
    
    var track: CATrack?
    
    var timer: Timer?
    var progress: Double = 0.0
    
//    var isCheckboxPressed = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateWithTrack(track: CATrack, _ isLastItem : Bool) {
        
        self.track = track
        
        if (self.timer != nil) {
            self.timer!.invalidate()
            self.timer = nil
        }
        
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy";
        
        self.labelTitle.text = df.string(from: track.date!)
        
        self.viewAction.layer.borderWidth = 2.0
        if (track.trackState == .complete) {
            self.viewAction.layer.borderColor = Config.shared.actionColor().cgColor
        } else {
            self.viewAction.layer.borderColor = Config.shared.actionBgColor().cgColor
        }
        
        self.viewAction.isHidden = track.trackState == .local
        self.viewProgress.isHidden = track.trackState != .loading
        
        if track.trackState == .onDevice {
            self.buttonAction.setImage(#imageLiteral(resourceName: "icon_download"), for: .normal)
        } else if track.trackState == .loading {
            self.buttonAction.setImage(#imageLiteral(resourceName: "icon_close"), for: .normal)
            
            self.progress = 0.0
            self.viewProgress.updateWithProgress(self.progress, width: 2.0, color: Config.shared.baseColor())
            self.timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(animateTimer), userInfo: nil, repeats: true)
            
        } else if track.trackState == .complete {
            self.buttonAction.setImage(#imageLiteral(resourceName: "icon_checkmark"), for: .normal)
        } else if track.trackState == .local {
            self.buttonAction.setImage(#imageLiteral(resourceName: "icon_send"), for: .normal)
        }
        self.buttonAction.isUserInteractionEnabled = (track.trackState != .complete)
        
        self.viewDivider.isHidden = isLastItem
        
        self.labelTitle.textColor = Config.shared.textColor()
        self.buttonTrashcan.tintColor = Config.shared.textColor()
        self.buttonAction.tintColor = Config.shared.textColor()
        
        self.viewDivider.backgroundColor = Config.shared.dividerColor()
        
    }
    
    @objc func animateTimer() {
        
        self.progress += 0.01
        self.viewProgress.updateWithProgress(self.progress)
        
        if (self.progress >= 1.0) {
            self.track?.trackState = .complete
            updateWithTrack(track: self.track!, self.viewDivider.isHidden)
        }
        
    }
    
    @IBAction func buttonActionPressed(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.historyActionSelected(self.track!)
        }
        
    }
    

    
    
    
    func checkboxPressed() {
       
        guard let currentTrack = track else { return }
        
        currentTrack.isChecked = !currentTrack.isChecked
        let checkImg = currentTrack.isChecked ? UIImage(named: "icon_checkbox_on") : UIImage(named: "icon_checkbox_off")
        checkbox.image = checkImg
    }
    

    @IBAction func buttonDeletePressed(_ sender: UIButton) {
        
        if self.delegate != nil {
            self.delegate?.historyDeleteSelected(self.track!)
        }
        
    }
    

}
