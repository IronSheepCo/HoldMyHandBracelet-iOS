//
//  HMHBeaconList.swift
//  HMH
//
//  Created by Mac on 08/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation


class HMHBeaconList{
    
    fileprivate var beacons:[String:HMHBeacon] = [:]
    
    func add(_ name:String, beacon:HMHBeacon )
    {
        beacons[ name ] = beacon
    }
    
    func find(_ name:String ) -> HMHBeacon?
    {
        return beacons[ name ]
    }
}
