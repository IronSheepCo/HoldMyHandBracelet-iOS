//
//  HMHBeacon.swift
//  HMH
//
//  Created by Mac on 08/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation

class HMHBeacon:CustomStringConvertible{
    
    fileprivate let name:String
    fileprivate let tx:Int
    fileprivate let coef:Double
    
    fileprivate var rssiValues:[Int] = []
    
    static let RSSIMaxReadings = 8
    
    public var description: String{
        get{
            return "Beacon: \(name)"
        }
    }
    
    public var workingRSSI:Int{
        get{
            //sort the readings
            let tmp = rssiValues.sorted()
            
            return tmp[ tmp.count/2 ]
        }
    }
    
    init(_ name:String, tx:Int, coef:Double )
    {
        self.name = name
        self.tx = tx
        self.coef = coef
    }
    
    func addRSSIValue(_ rssi: Int )
    {
        //invalid value
        if rssi == 127
        {
            return
        }
        
        rssiValues.append(rssi)
        
        //if we have to many readings
        //remove the oldest one
        if rssiValues.count > HMHBeacon.RSSIMaxReadings
        {
            rssiValues.removeFirst()
        }
    }
}
