//
//  SettingsTextFieldTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 17.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class SettingsTextFieldTableViewCell: SettingsTableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textFieldValue: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func updateWithData(data: [String : String], object: NSObject?) {
        super.updateWithData(data: data, object: object)
        
        self.labelTitle.textColor = Config.shared.subTextColor()
        self.textFieldValue.textColor = Config.shared.textColor()
        
        self.textFieldValue.placeholder = LS(data["placeholder"]!)
        
        if (object != nil) {
            if let field = data["field"] {
                self.textFieldValue.text = object!.value(forKey: field) as? String
            }
        }
        
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldValue.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)

        return true
    }
    
    override func closeKeyboard() {
        
        self.textFieldValue.resignFirstResponder()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected) {
            self.textFieldValue.becomeFirstResponder()
        }
        // Configure the view for the selected state
    }
    
}
