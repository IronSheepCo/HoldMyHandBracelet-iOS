//
//  BluetoothManager.swift
//  HMH
//
//  Created by Mac on 07/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    fileprivate let manager:CBCentralManager
    fileprivate let _beacons:HMHBeaconList = HMHBeaconList()
    
    public var beacons:HMHBeaconList{
        get{
            return _beacons;
        }
    }
    
    static public let instance:BluetoothManager = BluetoothManager()
    
    fileprivate override init(){
        manager = CBCentralManager()
        
        super.init()
        
        manager.delegate = self
    }
    
    public func coefList( _ coefs:[String:Double] )
    {
        
    }
    
    //MARK: - CBCentralManagerDelegate
    public func centralManagerDidUpdateState(_ central: CBCentralManager){
        switch( central.state )
        {
        case .poweredOn:
            startScan()
            break
        case .poweredOff:
            break
        default:
            break
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
        var beacon = beacons.find( peripheral.name! )
        
        if beacon == nil {
            let txPower = advertisementData[ CBAdvertisementDataTxPowerLevelKey ] as! NSNumber
            
            beacon = HMHBeacon( peripheral.name!, tx: txPower.intValue, coef:2 )
            beacons.add(peripheral.name!, beacon: beacon!)
        }
        
        beacon?.addRSSIValue(RSSI.intValue)
    }
    
    //MARK: - Scanning
    fileprivate func startScan()
    {
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(booleanLiteral: true)]
        
        manager.scanForPeripherals(withServices: nil, options: options)
    }
    
}
