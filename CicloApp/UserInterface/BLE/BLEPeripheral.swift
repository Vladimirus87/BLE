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
    
    
    var delegate:BLEPeripheralDelegate?
    
    override init() {
        super.init()
        self.manager = CBPeripheralManager(delegate: self, queue: nil)
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
    

    
    func sendFirmWare() {

        if let pManager = self.manager, self.subscribedCentral.count > 0, let charact = self.characteristic {
            
//            let firemware =
            let value: [UInt8] = [0x01,
                                  0x02, 0x03, 0x04, 0x053]
            pManager.updateValue(Data(bytes: value), for: charact, onSubscribedCentrals: self.subscribedCentral)
        }
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
            if let data = r.value {
                let dd = data.map{ String(format: "%02x", $0) }.joined()
                manager?.respond(to: r, withResult: .success)
                print(dd)
            }
        }
    }

}


