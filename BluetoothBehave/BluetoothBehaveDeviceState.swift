//
//  BluetoothBehaveDeviceState.swift
//  BluetoothBehave
//
//  Created by Casey Brittain on 8/3/18.
//  Copyright © 2018 Honeysuckle Hardware. All rights reserved.
//
import Foundation
import CoreBluetooth

extension CBManagerState {
    static func fromCBManagerState(state: CBManagerState) -> BluetoothBehaveDeviceState {
        
        let bluetoothBehaveDeviceState = BluetoothBehaveDeviceState()
        bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.unknown)
        
        switch state {
        case CBManagerState.unknown:
            bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.unknown)
            break
        case CBManagerState.resetting:
            bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.resetting)
            break
        case CBManagerState.unsupported:
            bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.unsupported)
            break
        case CBManagerState.unauthorized:
            bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.unauthorized)
            break
        case CBManagerState.poweredOff:
            bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.off)
            break
        case CBManagerState.poweredOn:
            bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.on)
            break
        default:
            bluetoothBehaveDeviceState.setState(state: BluetoothBehaveDeviceStates.unknown)
        }
        return bluetoothBehaveDeviceState
    }

}

public class BluetoothBehaveDeviceState: NSObject {
    private lazy var _state = BluetoothBehaveDeviceStates.unknown
    
    public func setState(state: BluetoothBehaveDeviceStates) -> Void {
        _state = state
    }
    
    public func getState() -> BluetoothBehaveDeviceStates {
        return _state
    }
}

public enum BluetoothBehaveDeviceStates: String {
    case unknown,
    off,
    on,
    resetting,
    unsupported,
    unauthorized,
    connected,
    disconnected,
    failedToConnect,
    purposefulDisconnect,
    lostConnection,
    connecting,
    scanning,
    idle,
    idleWithDiscoveredDevices
}
