//
//  EditAccountTableViewCell.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 15.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

@objc protocol EditAccountTableViewCellDelegate: class {
    func editAccountValueWasChanged(_ field: String, _ value : String)
}

class EditAccountTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var viewDivider: UIView!
    
    var item : [String : String]!
    weak var delegate: EditAccountTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.prepareForReuse()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textFieldValue.text = ""
        self.textFieldValue.keyboardType = .default
        self.textFieldValue.isSecureTextEntry = false
        
        self.viewDivider.alpha = 0.5
        
    }
    
    func updateWithData(data: [String : String]) {
        
        self.item = data
        
        self.textFieldValue.placeholder = LS(data["title"]!)
        self.textFieldValue.attributedPlaceholder = NSAttributedString(string: self.textFieldValue.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])

        self.textFieldValue.text = data["value"]
        
        if data["email"] != nil {
            self.textFieldValue.keyboardType = .emailAddress
        }
        
        if data["security"] != nil {
            self.textFieldValue.isSecureTextEntry = true
        }
        
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.viewDivider.alpha = 1.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewDivider.alpha = 0.5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldValue.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.item["value"] = ""
        if self.delegate != nil {
            self.delegate?.editAccountValueWasChanged(self.item["field"]!, self.item["value"]!)
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        self.item["value"] = newText
        if self.delegate != nil {
            self.delegate?.editAccountValueWasChanged(self.item["field"]!, self.item["value"]!)
        }
        return true
    }
    
    func closeKeyboard() {
        
        self.textFieldValue.resignFirstResponder()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
