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
    
    func computeGraphForDestination(_ destination:Int ) -> [HMHNode:HMHNode]{
        var parentGraph:[HMHNode:HMHNode] = [:]
        
        var currentNode = nodes[destination]
        
        var currentNodes:[HMHNode] = [ currentNode ]
        
        var visited:[HMHNode:Bool] = [currentNode:true]
        var distance:[HMHNode:Int] = [currentNode:0]
        
        while currentNodes.count > 0
        {
            currentNode = currentNodes.first!
            currentNodes.removeFirst()
            
            //search for edges
            for edge in edges
            {
                var sibling:HMHNode?
                
                if edge[0] == currentNode
                {
                    sibling = edge[1]
                }
                
                if edge[1] == currentNode
                {
                    sibling = edge[0]
                }
                
                guard let realSibling = sibling else { continue }
                
                //we have a match, check if we already visited that node
                if visited[ realSibling ] == nil
                {
                    //first time we see this node
                    currentNodes.append( realSibling )
                    parentGraph[ realSibling ] = currentNode
                    distance[ realSibling ] = distance[ currentNode ]!+1
                }
                else
                {
                    let dist = distance[ currentNode ]! + 1
                    
                    if dist < distance[ realSibling ]!
                    {
                        distance[realSibling] = dist
                        parentGraph[realSibling] = currentNode
                    }
                }
            }
            
            visited[currentNode] = true
        }
        
        return parentGraph
    }
    
}
