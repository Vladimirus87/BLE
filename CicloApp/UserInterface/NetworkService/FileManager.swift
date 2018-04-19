//
//  FileManager.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 18.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit

func createDirectory() {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
    if !fileManager.fileExists(atPath: paths){
        try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
    }
}


func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}


func getFile(name: String) -> Data? {
    let fileManager = FileManager.default
    let filePath = (getDirectoryPath() as NSString).appendingPathComponent(name)
    if fileManager.fileExists(atPath: filePath) {
        return try? Data(contentsOf: URL(fileURLWithPath: filePath))
    }
        return nil
}


func saveToDocumentDirectory(file: Data) {

    if let actual = UserDefaults.standard.string(forKey: "actualVersion") {
        UserDefaults.standard.set(actual, forKey: "penultimateМersion")
    }
    
    let name = randomString()
    UserDefaults.standard.set(name, forKey: "actualVersion")
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
    fileManager.createFile(atPath: paths as String, contents: file, attributes: nil)
    
    if let penultimate = UserDefaults.standard.string(forKey: "penultimateМersion") {
        removeFile(penultimate)
    }
}

func removeFile(_ name: String ) {
    let fileManager = FileManager.default
    let filePath = (getDirectoryPath() as NSString).appendingPathComponent(name)
    do {
        try fileManager.removeItem(atPath: filePath)
        print("removed")
    } catch let error as NSError {
        print(error.debugDescription)
        print("NOT________REMOVED")
    }
}


func randomString() -> String {
    let pswdChars = Array("abcdefghijklmnopqrstuvwxyz")
    let rndPswd = String((0..<8).map { _ in pswdChars[Int(arc4random_uniform(UInt32(pswdChars.count)))]})
    return rndPswd
}




