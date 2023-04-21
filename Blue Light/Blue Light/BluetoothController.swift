//
//  BluetoothController Class.swift
//  Blue Light
//
//  Created by Frankie Tucker on 27/02/2023.
//
//
//   Controller class for BLE, is configured to ObservableObject
//      @Published variables to share
//
//
//
//
//
//

import Foundation
import CoreBluetooth
import UIKit

class BluetoothController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // Characteristics and properties
    private var LEDStateChar: CBCharacteristic?
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
   
    // Used by timer view
    @Published var lightOn: Bool = false
    // used by ConnectButton view
    @Published var connectionStatus: String = ""
    @Published var bluetoothStatus: String = ""
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }
    
    // Handling Central
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch centralManager.state {
        case.poweredOn:
            // *add code to try reconnect, if disconnects
            bluetoothStatus = "PoweredOn"
        case.unknown:
            bluetoothStatus = "Unknown"
        case.resetting:
            bluetoothStatus = "Resetting"
        case.unsupported:
            bluetoothStatus = "Unsupported"
        case.unauthorized:
            bluetoothStatus = "Unautherised"
        case.poweredOff:
            bluetoothStatus = "PoweredOff"
            // Try to reconned here
        @unknown default:   // incase of future unknown values
            bluetoothStatus = "UnknownDefault"
        }
    }
    
    //-------------- Functions called by connectView to connect to peripheral  -----------
    
    func scanConnect(){
        // Function to connect to peripheral, called when user presses button in connectView
        guard centralManager.state == .poweredOn else{
            print("Central Not powered On")
            bluetoothStatus = "Central Not powered On"
            return
        }
        print("Central is Scanning for : ", ArduinoPeripheral.LEDServiceUUID)
        centralManager.scanForPeripherals(withServices: [ArduinoPeripheral.LEDServiceUUID],options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    func disconnect(){
        // Function if user wants to disconnect
        print("User disconnect")
        //connectionStatus = "Central Not powered On"
        if let peripheral = self.peripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    //---------------------------------------------------------------------
    
    // Result of Scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Peripheral found, stopping scan
        self.centralManager.stopScan()
        
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connecting to Peripheral
        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    // For Sucessful connection
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            
            print("Connected to Peripheral")
            connectionStatus = "Connecting"
            
            peripheral.discoverServices([ArduinoPeripheral.LEDServiceUUID]);
        }
    }
    
    // if Central disconnects from peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            
            self.peripheral = nil
            print("Disconnected")
            connectionStatus = "Disconnected"

            // Scanning again
            print("Central Scanning for: ", ArduinoPeripheral.LEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ArduinoPeripheral.LEDServiceUUID],options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // For event of Peripheral Service Discoverey
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print(service)       // for testing
                if service.uuid == ArduinoPeripheral.LEDServiceUUID {
                    print("Service found")
                    // Characteristic held in Service
                    peripheral.discoverCharacteristics([ArduinoPeripheral.LEDCharUUID], for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Enabling notify ", characteristic.uuid)
        
        if error != nil{
            print("Enable Notify Error")
        }
    }
    
    // for Peripheral Characterisitics, note currently Service only has one characteristic
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ArduinoPeripheral.LEDCharUUID {
                    
                    print("LED State Characteristic Found")
                    connectionStatus = "Connected"
                    
                    LEDStateChar = characteristic
                    
                    // Subscribes to Characteristic, then reads value
                    peripheral.setNotifyValue(true, for: characteristic)
                    peripheral.readValue(for: characteristic)
                    
                } else {
                    print("Error Unknown Characteristic")
                    connectionStatus = "Unknown Characteristic error"
                }
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // taking first value of characteristic
        guard let charValue = characteristic.value else{return}    // Guard func u
        
        if let stateValue = charValue.first {
            print("LED State =", stateValue)
            if (stateValue == 1) {
                lightOn = true
            }
            else if (stateValue == 0) {
                lightOn = false
            }
            else{
                print("Unknown Error, Unexpected Value from Peripheral")
            }
        }
        
    }
}
    
    


