//
//  CATrack.swift
//  CicloApp
//
//  Created by Pavel Belevtsev on 18.03.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

enum CATrackState: Int16 {
    case onDevice = 0
    case loading = 1
    case complete = 2
    case local = 3
}

class CATrack: NSObject {

    var trackState: CATrackState?
    var date: Date?
    var isChecked = false
    
    override init() {
        super.init()
        
    }
    
    init(trackState: CATrackState?, date: Date?) {
        self.trackState = trackState
        self.date = date
    }
    
}
