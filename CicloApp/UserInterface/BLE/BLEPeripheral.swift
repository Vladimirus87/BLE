//
//  BLEPeripheral.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 01.05.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//

import UIKit
import CoreBluetooth


protocol BLEPeripheralDelegate {
    func didChangeSubscribedCentral()
}

class BLEPeripheral: NSObject, CBPeripheralManagerDelegate {
    
    static let MessageNotification = NSNotification.Name(rawValue: "BLEPeripheral.Message")
    static let ServiceUUIDString = "D048FDD0-D8B4-9A07-322C-984543634A20"
    static let CharacteristicUUIDString = "7B8D2F07-2E7A-BA62-EF67-A7DDA395541C"
    
    let serviceCBUUID = CBUUID(string: BLEPeripheral.ServiceUUIDString)
    let charactCBUUID = CBUUID(string: BLEPeripheral.CharacteristicUUIDString)
    
    var service:CBMutableService?
    var characteristic:CBMutableCharacteristic? 
    var subscribedCentral = [CBCentral]()
    
    var manager:CBPeripheralManager?
    
    var subscriptionTimer:Timer?
    var subscriptionValue = 0
    
    var firmware : [String]?
    var nextInstructionTimer : Timer?
    var indexOfLine = 0
    
    var hexSize = 5
    
    
    
    var delegate:BLEPeripheralDelegate?
    
    override init() {
        super.init()
        self.manager = CBPeripheralManager(delegate: self, queue: nil)
        
        DispatchQueue.main.async {
            self.firmware = self.getFirmawareStringArr(name: "HAC1")
        }
    }
    
    func handlePoweredOn() {
        self.notifyListener(message: "BLE Powered On")
        self.createAndAddService()
    }
    
    func timerIsRunning() -> Bool {
        return self.subscriptionTimer != nil
    }
    
    func startSubscriptionTimer() {
        self.stopSubscriptionTimer()
        self.subscriptionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleSubscriptionTimerEvent(aTimer:)), userInfo: nil, repeats: true)
    }
    
    func stopSubscriptionTimer() {
        if let timer = self.subscriptionTimer {
            timer.invalidate()
            self.subscriptionTimer = nil
        }
    }
    
    @objc func handleSubscriptionTimerEvent(aTimer:Timer) {
        subscriptionValue += 1
        if let pManager = self.manager, self.subscribedCentral.count > 0, let charact = self.characteristic {
            let stringValue = "\(subscriptionValue)"
            if let dataValue = stringValue.data(using: String.Encoding.utf8) {
                pManager.updateValue(dataValue, for: charact, onSubscribedCentrals: self.subscribedCentral)
            }
        }
    }
    
    

    func hex2ByteArr(line: String) -> [UInt8] {
        var byteArr: [UInt8] = [0x3A]
        var pair = "" {
            didSet{
                if pair.count == 2 {
                    let buf = [UInt8](pair.utf8)
                    byteArr.append(buf.first!)
                    pair = ""
                }
            }
        }
        
        Array(line).dropFirst().forEach { (ch) in
            pair += String(ch)
        }
        
        if pair != "", pair.count == 1, byteArr.count >= line.count / 2 {
            let buf = [UInt8](pair.utf8)
            byteArr.append(buf.first!)
            print("yes")
        }
        
        return byteArr
    }
    
    
    func getFirmawareStringArr(name: String) -> [String]? {
        
        let filePath = Bundle.main.path(forResource: name, ofType: "hex")
        
        do {
            let data = try String(contentsOfFile: filePath!)
            let myStrings = data.components(separatedBy: .newlines).filter{!$0.isEmpty}
            
            return myStrings
            
        } catch {
            print("error -> ", error)
        }
        
        return nil
    }
    
    
    func sendLine(_ line: String) {
        if let pManager = self.manager, self.subscribedCentral.count > 0, let charact = self.characteristic {
            //        let line = arrHexlines[index]
            let byteArr = hex2ByteArr(line: line)
            
            pManager.updateValue(Data(bytes: byteArr), for: charact, onSubscribedCentrals: self.subscribedCentral)
            
        }
    }
    

    
    @objc func sendFirmware() {

        guard let firmware = firmware else {return}
        nextInstructionTimer?.invalidate()
        
        sendLine(firmware[indexOfLine])
        indexOfLine += 1
        
        if indexOfLine < firmware.count {
            print(indexOfLine)
            nextInstructionTimer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(sendFirmware), userInfo: nil, repeats: false)
        } else {
            indexOfLine = 0
            print("sent")
        }
    }
    

    
    func sendSizeFirmWare() {

        if let pManager = self.manager, self.subscribedCentral.count > 0, let charact = self.characteristic {
            
            guard let url = Bundle.main.url(forResource: "HAC1", withExtension: "hex") else {
                print("HAC1 не найдено")
                return
            }
            
            guard let data = try? Data(contentsOf: url) else { return }
            
            let firmwareSize = intToByteArray(data.count)
            var value: [UInt8] = [0x65]
            
            firmwareSize.forEach { (elem) in
                value.append(elem)
            }
            
            pManager.updateValue(Data(bytes: value), for: charact, onSubscribedCentrals: self.subscribedCentral)
            print("sent")
        }
    }
    
    
    func uploadFirmWareOnDevice() {
        print(#function)
        
        let value: [UInt8] = [0x75]
        let dataValue = Data(bytes: value)
        
        manager?.updateValue(dataValue, for: self.characteristic!, onSubscribedCentrals: self.subscribedCentral)
    }
    
    

    
    
    func createAndAddService() {

        self.characteristic = CBMutableCharacteristic(type: charactCBUUID, properties: [CBCharacteristicProperties.read, CBCharacteristicProperties.write, CBCharacteristicProperties.notify], value: nil, permissions: [CBAttributePermissions.readable, CBAttributePermissions.writeable])
        
        if let charact = self.characteristic {
            self.service = CBMutableService(type: serviceCBUUID, primary: true)
            if let serv = self.service {
                serv.characteristics = [charact]
            }
        }
        
        if let serv = self.service {
            if let mgr = self.manager {
                self.notifyListener(message: "adding service")
                mgr.add(serv)
            }
        }
    }
    
    
    func notifyListener(message:String) {
        NotificationCenter.default.post(name: BLEPeripheral.MessageNotification, object: message)
    }
    
    
    func startAdvertising() {
        if let manager = self.manager {
            manager.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [self.serviceCBUUID]])
        }
    }

    
    func stopAdvertising() {
        if let manager = self.manager {
            manager.stopAdvertising()
        }
    }
    
    
    // MARK: CBPeripheralManagerDelegate implementation

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            handlePoweredOn()
        case .unknown:
            self.notifyListener(message: "BLE Unknown")
        case .resetting:
            self.notifyListener(message: "BLE Resetting")
        case .unsupported:
            self.notifyListener(message: "BLE Unsupported")
        case .unauthorized:
            self.notifyListener(message: "BLE Unauthorized")
        case .poweredOff:
            self.notifyListener(message: "BLE Powered Off")
        }
    }

    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        self.notifyListener(message: "added service, starting to advertise")
    }
    
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let err = error {
            self.notifyListener(message: "error trying to advertise")
            NSLog("error trying to advertise: \(err.localizedDescription)")
        } else {
            self.notifyListener(message: "advertising")
        }
    }
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        self.notifyListener(message: "a central has subscribed")
        self.subscribedCentral.append(central)
        
        guard let delegate = delegate else { return }
        delegate.didChangeSubscribedCentral()
        
    }
    
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        self.notifyListener(message: "a central has unsubscribed")

        if let deletingCentralIndex = subscribedCentral.index(of: central) {
            subscribedCentral.remove(at: deletingCentralIndex)
            
            guard let delegate = delegate else { return }
            delegate.didChangeSubscribedCentral()
            
        }
    }
    

    
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for r in requests {
            if r.characteristic.uuid == charactCBUUID {
                if let data = r.value {
                    
                    let receiveData = [UInt8](data)
                    
                    if receiveData.count > 0 {
                        
                        switch receiveData.first! {
                            
                        case 0x75:
                            if receiveData.count > 1, receiveData[1] == 1 {
                                self.uploadFirmWareOnDevice()
                            } else {
                                print("some problem with delete old firmware on HAC1")
                            }
                            
                        default: break
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid == charactCBUUID {
         
            let value: [UInt8] = [0x00099]
            request.value = Data(bytes: value)
            manager?.respond(to: request, withResult: .success)
            print("didReceiveRead", value)
        }
    }

}



extension BLEPeripheral {
    
    func intToByteArray( _ number:Int ) -> [UInt8] {
        
        var result:[UInt8] = Array()
        
        var _number:Int = number
        let mask_8Bits = 0xFF
        
        for _ in ( 0 ..< 4 ).reversed() {
            
            // at: 0 -> insert at the beginning of the array
            result.insert( UInt8( _number & mask_8Bits ), at: 0 )
            _number >>= 8 // shift 8 times from left to right
        }
        
        return result
    }
}







