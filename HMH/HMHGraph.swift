//
//  HMHGraph.swift
//  HMH
//
//  Created by Mac on 08/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation

enum Direction:String{
    case SOUTH
    case NORTH
    case EAST
    case WEST
}

enum Orientation:String{
    case FORWARD
    case LEFT
    case RIGHT
    case BACK
    case WAIT
}

struct Edge{
    public let start:HMHNode
    public let end:HMHNode
    public let dir:Direction
}

class HMHGraph: CustomStringConvertible
{
    fileprivate var nodes:[HMHNode] = []
    fileprivate var edges:[Edge] = []
    
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
    
    func nodeByName( _ name:String )->HMHNode?{
        for node in nodes
        {
            if node.name == name {
                return node
            }
        }
        
        return nil
    }
    
    func addEdge( first:HMHNode, second:HMHNode, dir:Direction )
    {
        edges.append( Edge(start:first, end:second, dir:dir) )
    }
    
    func addEdge( first:Int, second:Int, dir:Direction )
    {
        addEdge( first:nodes[first], second:nodes[second], dir:dir )
    }
    
    func addEdge(_ edge:[Int], dir:Direction )
    {
        addEdge(first: edge[0], second: edge[1], dir:dir)
    }
    
    func findEdge( from:HMHNode, to: HMHNode ) -> Edge?
    {
        for edge in edges {
            if (edge.start == from && edge.end == to ) ||
                (edge.start == to && edge.end == from )
            {
                return edge
            }
        }
        
        return nil
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
                
                if edge.start == currentNode
                {
                    sibling = edge.end
                }
                
                if edge.end == currentNode
                {
                    sibling = edge.start
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
    
    func computeGraphForDestination(_ node:HMHNode ) -> [HMHNode:HMHNode]{
        guard let index = nodes.index(of: node) else { return [:] }
        
        return computeGraphForDestination(index)
    }
    
    func relativeDirection( from:HMHNode, to: HMHNode, edge:Edge )->Direction{
        if from == edge.start
        {
            return edge.dir
        }
        else
        {
            switch edge.dir
            {
                case .SOUTH: return .NORTH
                case .NORTH: return .SOUTH
                case .EAST: return .WEST
                case .WEST: return .EAST
            }
        }
    }
    
    fileprivate func goingSouth(_ edgeDir:Direction )->Orientation
    {
        switch edgeDir
        {
        case .WEST: return .RIGHT
        case .SOUTH: return .FORWARD
        case .EAST: return .LEFT
        case .NORTH: return .BACK
        }
    }
    
    fileprivate func goingEast(_ edgeDir:Direction )->Orientation
    {
        switch edgeDir
        {
        case .WEST: return .BACK
        case .SOUTH: return .RIGHT
        case .EAST: return .FORWARD
        case .NORTH: return .LEFT
        }
    }
    
    fileprivate func goingNorth(_ edgeDir:Direction )->Orientation
    {
        switch edgeDir
        {
        case .WEST: return .LEFT
        case .SOUTH: return .BACK
        case .EAST: return .RIGHT
        case .NORTH: return .FORWARD
        }
    }
    
    fileprivate func goingWest(_ edgeDir:Direction )->Orientation
    {
        switch edgeDir
        {
        case .WEST: return .FORWARD
        case .SOUTH: return .LEFT
        case .EAST: return .BACK
        case .NORTH: return .RIGHT
        }
    }
    
    func orientationRelativeToDirection( from: HMHNode, to: HMHNode, dir:Direction )->Orientation{
        
        guard let edge = findEdge(from: from, to: to) else { return .WAIT }
        
        let edgeDir = relativeDirection(from: from, to: to, edge: edge)
        
        //we have the direction
        switch dir
        {
        case .SOUTH:    return goingSouth( edgeDir )
        case .EAST:     return goingEast( edgeDir )
        case .NORTH:    return goingNorth( edgeDir )
        case .WEST:     return goingWest( edgeDir )
        }
    }
}
