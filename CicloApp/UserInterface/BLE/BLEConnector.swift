//
//  BLEConnector.swift
//  CicloApp
//
//  Created by Владимир Моисеев on 27.04.2018.
//  Copyright © 2018 Lindenvalley. All rights reserved.
//


import Foundation
import CoreBluetooth


protocol BLEConnectorDelegate {
    func centralDidSubscribedToCharacteristic(_ central: CBCentral)
    func centralDidUnsubscribedToCharacteristic(_ central: CBCentral)
}



enum BLEConnectionErrorType: Error {
    case bluetoothUnknowState
    case bluetoothLEUnavailable
    case bluetoothTurnedOff
    case bluetoothNotAuthorized
    case systemNotConfiguredCorrectly
    case success
}



public class BLEConnector: NSObject {
    
    let advertisingIdentifier: String
    let restoreIdentifier = "FFFFF"
    let serviceUUID = "d048fdd0-d8b4-9a07-322c-984543634a20"
    let serviceCharacteristicUUID = "7b8d2f07-2e7a-ba62-ef67-a7dda395541c"
    
    var peripheralManager : CBPeripheralManager?
    var myService : CBMutableService?
    var myCharacteristic : CBMutableCharacteristic?
    var subscribedCentrals = [CBCentral]()
    var centralNames = [String]()
    
    let communicationQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    
    var delegate: BLEConnectorDelegate?
    
    
    init(advertisingIdentifier: String) {
        
        self.advertisingIdentifier = advertisingIdentifier
        super.init()
    }
    
    
    
    func setUpService() {
        var startOptions = [String: Any]()
        startOptions[CBPeripheralManagerRestoredStateServicesKey] = restoreIdentifier
        peripheralManager = CBPeripheralManager(delegate: self, queue: communicationQueue, options: startOptions)
        
        //move that to a different method
        //        let backgroundModes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String]
        //        let backgroundPeripheral = backgroundModes?.contains("bluetooth-peripheral")
        
        //        assert(backgroundPeripheral == true, "Activate background-mode \"bluetooth-peripheral\"")
    }
    
    
    func buildService() -> CBMutableService {
        let serviceUUID = CBUUID(string: self.serviceUUID)
        let serviceNavigationCharacteristicUUID = CBUUID(string: serviceCharacteristicUUID)
        let navigationCharacteristic = CBMutableCharacteristic(type: serviceNavigationCharacteristicUUID,
                                                               properties: CBCharacteristicProperties(rawValue: CBCharacteristicProperties.notify.rawValue | CBCharacteristicProperties.read.rawValue),
                                                               value: nil,
                                                               permissions: CBAttributePermissions.readable)
        
        self.myCharacteristic = navigationCharacteristic
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [navigationCharacteristic]
        return service
    }
    
    
    func startAdvertisingNavigationService() -> BLEConnectionErrorType {
        if let peripheralManager = peripheralManager {
            if peripheralManager.state == .poweredOn {
                if peripheralManager.isAdvertising {
                    stopAdvertisingService()
                }
                var advertisementData = [String: Any]()
                advertisementData[CBAdvertisementDataServiceUUIDsKey] = [myService!.uuid]
                advertisementData[CBAdvertisementDataLocalNameKey] = self.advertisingIdentifier
                peripheralManager.startAdvertising(advertisementData)
                
                
                if CBPeripheralManager.authorizationStatus() == .denied {
                    print("couldn't start advertising authorizationStatus == Denied")
                    return .bluetoothNotAuthorized
                    
                } else {
                    print("did start advertising")
                    return .success
                }
            } else {
                if peripheralManager.state == .poweredOff {
                    return BLEConnectionErrorType.bluetoothTurnedOff
                } else if peripheralManager.state == .unauthorized {
                    return .bluetoothNotAuthorized
                } else if peripheralManager.state == .unknown {
                    return .bluetoothUnknowState
                }
                return .bluetoothLEUnavailable
            }
        } else {
            return .systemNotConfiguredCorrectly
        }
        
    }
    
    
    
    
    func stopAdvertisingService() {
        if let peripheralManager = peripheralManager {
            if peripheralManager.isAdvertising {
                peripheralManager.stopAdvertising()
                print("stop advertising service")
            }
        }
        
    }
    
}


extension BLEConnector: CBPeripheralManagerDelegate {
    
    
    
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn && myService == nil) {
            myService = buildService()
            peripheral.add(myService!)
        }
        
    }
    
    public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let _ = error {
            print("error while starting advertising")
        } else {
            print("didStartAdvertising")
        }
    }
    
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        if characteristic.uuid == CBUUID(string: serviceCharacteristicUUID) {
            DispatchQueue.main.async(execute: {
                self.delegate?.centralDidSubscribedToCharacteristic(central)
            })
        }
        
        stopAdvertisingService()
      
    }
    
    public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        if characteristic.uuid == CBUUID(string: serviceCharacteristicUUID) {
            DispatchQueue.main.async(execute: {
                self.delegate?.centralDidUnsubscribedToCharacteristic(central)
            })
        }
    }
    
}


