//
//  BluetoothBehaveRemote.swift
//  BluetoothBehave
//
//  Created by Casey Brittain on 8/3/18.
//  Copyright © 2018 Honeysuckle Hardware. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol bluetoothBehaveRemoteDelegate {
    func update()
}

/// This hopefully provides some info
public class bluetoothBehaveRemote {
    
    public init(){
        
    }
    
    internal var deviceState = BluetoothBehaveDeviceState()
    
    internal(set) var ID: UUID?
    
    func idAsString()->String{
        return String(describing: ID)
    }
    
    internal(set) var connectable: Bool?
    internal(set) var rssi: Int?
    
    func serialDataAvailable(_ deviceOfInterest: UUID, data: String){
        
    }
    
    
    func setBackgroundConnection(_ allow: Bool){
        
    }
    
    
    func getRxBufferChar(_ deviceOfInterest: UUID){
        
    }
    
    func clearRxBuffer(_ deviceOfInterest: UUID){
        
    }
    
    var nameString: String?
    func getDeviceName()->String?{
        return nameString
    }
    
    var dataLocalNameString: String?
    
    // Peripheral
    var bbPeripheral: CBPeripheral?
    
    // Each device may have multiple services.
    var bbServices: Array<CBService>?
    var serviceUUIDString: Array<String>?
    
    // May have several characteristics
    var bbCharacteristics: Array<CBCharacteristic>?
    var characteristicsString: String?
    
    // May have sever descriptors.
    var bbDescriptors: Array<CBDescriptor>?
    
    // Discovered device advertisement data.
    var advDataLocalName: String?
    var advDataManufacturerData: String?
    var advDataServiceData: String?
    var advDataServiceUUIDs: Dictionary<CBUUID, String>?
    var advDataOverflowServiceUUIDsKey: Array<String>?
    var advDataTxPowerLevel: Int?
    var advDataIsConnectable: String?
    var advSolicitedServiceUUID: Array<String>?
}
