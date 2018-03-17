//
//  Config.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

enum ColorModeType: Int16 {
    case light = 0
    case dark = 1
}

class Config: NSObject {

    static let notificationSettingsColorMode = "notificationSettingsColorMode"
    
    static let shared = Config()
    
    var colorMode : ColorModeType = .light
    
    func updateColorMode(_ isDarkMode : Bool) {
    
        if (isDarkMode) {
            self.colorMode = .dark
        } else {
            self.colorMode = .light
        }
        NotificationCenter.default.post(name: Notification.Name(Config.notificationSettingsColorMode), object: nil)
        
    }
    
    func baseColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("004CF5")
        } else {
            return UIColor.colorRGB("6694F9")
        }
    }
    
    func backgroundColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("F7F7F7")
        } else {
            return UIColor.colorRGB("1A1A1A")
        }
    }
    
    func titleColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("000000", alpha:0.7)
        } else {
            return UIColor.colorRGB("FFFFFF", alpha:0.8)
        }
    }
    
    func tabsBgColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("FFFFFF")
        } else {
            return UIColor.colorRGB("333333")
        }
    }
    
    func tabsDividerColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("000000")
        } else {
            return UIColor.colorRGB("FFFFFF")
        }
    }
    
    func tabsInactiveColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("000000", alpha: 0.5)
        } else {
            return UIColor.colorRGB("FFFFFF", alpha: 0.7)
        }
    }
    
    func dividerColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("004CF5", alpha: 0.1)
        } else {
            return UIColor.colorRGB("FFFFFF", alpha: 0.2)
        }
    }
    
    func textColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("000000", alpha: 0.8)
        } else {
            return UIColor.colorRGB("FFFFFF", alpha: 0.9)
        }
    }
    
    func subTextColor() -> UIColor {
        if (colorMode == .light) {
            return UIColor.colorRGB("000000", alpha: 0.4)
        } else {
            return UIColor.colorRGB("FFFFFF", alpha: 0.6)
        }
    }
}
