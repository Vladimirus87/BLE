//
//  CAButton.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class CAButton: UIButton {

    var useBorderProperty : Bool = false
    var useUnderlineTitleProperty : Bool = false
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    override var bounds: CGRect {
        didSet {
            self.cornerRadius = layer.cornerRadius
        }
    }
    
    @IBInspectable var useBorder: Bool {
        get {
            return self.useBorderProperty
        }
        set {
            self.useBorderProperty = newValue
            if (newValue) {
                layer.borderWidth = 1.0
                layer.borderColor = self.tintColor.cgColor
            } else {
                layer.borderWidth = 0.0
            }
        }
    }
    
    @IBInspectable var useUnderlineTitle: Bool {
        get {
            return self.useUnderlineTitleProperty
        }
        set {
            self.useUnderlineTitleProperty = newValue
            if (newValue) {
            
                let attrs : [NSAttributedStringKey: Any] = [NSAttributedStringKey.font : self.titleLabel!.font!,
                             NSAttributedStringKey.foregroundColor : self.titleLabel!.textColor!,
                             NSAttributedStringKey.underlineStyle : 1]
                
                let buttonTitleStr = NSAttributedString(string:self.titleLabel!.text!, attributes:attrs)
                self.setAttributedTitle(buttonTitleStr, for: .normal)
                
            }
        }
    }
    
    @IBInspectable var isAvailable: Bool {
        get {
            return self.isUserInteractionEnabled
        }
        set {
            self.isUserInteractionEnabled = newValue
            self.alpha = newValue ? 1.0 : 0.5
        }
    }
    
}
