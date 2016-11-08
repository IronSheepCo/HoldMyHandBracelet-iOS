//
//  HMHNode.swift
//  HMH
//
//  Created by Mac on 08/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation


class HMHNode: Hashable, CustomStringConvertible{
    let name:String
    
    public var description: String {
        get {
            return name
        }
    }
    
    init( name:String ){
        self.name = name
    }
    
    static func ==(first:HMHNode, second:HMHNode)->Bool{
        return first.name == second.name
    }
    
    var hashValue:Int{
        get{
            return name.hashValue
        }
    }
}
