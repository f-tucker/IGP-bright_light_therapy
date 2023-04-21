//
//  PeripheralDevice.swift
//  Blue Light
//
//  Created by Frankie Tucker on 26/02/2023.
//
//
//  Peripheral Device Info
// -class holds arduino BLE uuid's
// - Currently Service only contains one class
// - Any additional charaacteristics  should be added here
//

//import UIKit
import Foundation
import CoreBluetooth


protocol ArduinoDeligate{
}

class ArduinoPeripheral: NSObject {
    
    public static let LEDServiceUUID  = CBUUID.init(string: "1037b18c-fc2d-4f8c-a9ba-6e45ed562713")
    public static let LEDCharUUID     = CBUUID.init(string: "1037b18c-fc2d-4f8c-a9ba-6e45ed562713")
}
