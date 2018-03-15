//
//  Config.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 14.03.18.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class Config: NSObject {

    static let notificationSettingsColor = "NotificationSettingsColor"
    
    static let shared = Config()
    
    func baseColor() -> UIColor {
        return UIColor.colorRGB(0.0, 76.0, 245.0)
    }
    
}
