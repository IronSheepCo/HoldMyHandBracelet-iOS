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
    fileprivate var coefs:[String:Double] = [:]
    fileprivate var namesToNodes:[String:HMHNode] = [:]
    
    fileprivate var currentBeacon:HMHBeacon?
    
    public var delegate: BluetoothManagerDelegate?
    
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
        self.coefs = coefs
    }
    
    public func setAreaToNode( _ beaconName:String, node: HMHNode)
    {
        namesToNodes[ beaconName ] = node
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
        guard let name = peripheral.name else { return }
        
        var beacon = beacons.find( name )
        
        if beacon == nil {
            let txPower = advertisementData[ CBAdvertisementDataTxPowerLevelKey ] as! NSNumber
            
            beacon = HMHBeacon( name, tx: txPower.intValue, coef: coefs[name]! )
            beacon?.Node = namesToNodes[ name ]
            beacons.add(name, beacon: beacon!)
        }
        
        beacon?.addRSSIValue(RSSI.intValue)
        
        //lets compute the current position
        computeCurrentPosition()
    }
    
    //MARK: - Scanning
    fileprivate func startScan()
    {
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey:NSNumber(booleanLiteral: true)]
        
        manager.scanForPeripherals(withServices: nil, options: options)
    }
    
    //MARK: - Position computation
    fileprivate func computeCurrentPosition()
    {
        let sorted = beacons.list().sorted { (first, second) -> Bool in
            var firstDistance:Double = first.distance
            var secondDistance:Double = second.distance
            
            if first == currentBeacon
            {
                firstDistance -= Config.CURRENT_NODE_DEDUCTION
            }
            
            if second == currentBeacon
            {
                secondDistance -= Config.CURRENT_NODE_DEDUCTION
            }
            
            return firstDistance < secondDistance
        }
        
        currentBeacon = sorted.first
        
        delegate?.closestBeacon(currentBeacon!)
    }
    
}
