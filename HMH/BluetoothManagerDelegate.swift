//
//  BluetoothManagerDelegate.swift
//  HMH
//
//  Created by Mac on 08/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation

protocol BluetoothManagerDelegate: class{
    func closestBeacon(_ beacon: HMHBeacon)
    
    func areNeighbours(one: HMHBeacon, second: HMHBeacon)->Bool
}
