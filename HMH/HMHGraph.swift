//
//  HMHGraph.swift
//  HMH
//
//  Created by Mac on 08/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation

class HMHGraph: CustomStringConvertible
{
    fileprivate var nodes:[HMHNode] = []
    fileprivate var edges:[ [HMHNode] ] = []
    
    /// A textual representation of this instance, suitable for debugging.
    public var description: String
    {
        get{
            return nodes.description + " " + edges.description
        }
    }
    
    init(){
        
    }
    
    func addNode( node:HMHNode ){
        nodes.append(node)
    }
    
    func addEdge( first:HMHNode, second:HMHNode )
    {
        edges.append( [first, second] )
    }
    
    func addEdge( first:Int, second:Int )
    {
        addEdge( first:nodes[first], second:nodes[second] )
    }
    
    func addEdge(_ edge:[Int] )
    {
        addEdge(first: edge[0], second: edge[1])
    }
    
}
