//
//  CAProfile.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 19.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

class CAProfile: NSObject {

    var id: Int?
    @objc dynamic var profileName: NSString?
    @objc dynamic var bikeWeight: NSString?
    @objc dynamic var wheelDiameter: NSString?
    
    override init() {
        super.init()
        
    }
    
    init(id: Int?, profileName: NSString?, bikeWeight: NSString?, wheelDiameter: NSString?) {
        self.id = id
        self.profileName = profileName
        self.bikeWeight = bikeWeight
        self.wheelDiameter = wheelDiameter
    }
    
}
