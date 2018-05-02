//
//  BLEDataModel.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 30.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import Foundation

class BLEDataModel {
    
    var wordForSend: String?
    var identifier : UInt32
    
    init(word: String?) {
        self.wordForSend = word
        self.identifier = arc4random()
    }
    
    func convertToNSData() -> Data {
        let data = NSMutableData()
        data.append(&identifier, length: MemoryLayout<UInt32>.size)
        if let string = self.wordForSend {
            data.append(string.data(using: String.Encoding.utf8)!)
        }
        return data as Data
    }
}
