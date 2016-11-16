//
//  HMHTests.swift
//  HMHTests
//
//  Created by Mac on 15/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import XCTest
@testable import HMH

class HMHTests: XCTestCase {
    
    var graph:HMHGraph = HMHGraph()
    var parentNodes:[HMHNode:HMHNode] = [:]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //create nodes
        let names = [ ["hol 1","HMHBeacona5"], ["hol 2","HMHBeacona11"], ["QA","HMHBeacona6"], ["Dev","HMHBeacona7"], ["hol mic","HMHBeacona9"], ["Game","HMHBeacona10"], ["RE","HMHBeacon"], ["hol baie",""], ["hol buc",""], ["baie",""], ["buc",""] ]
        
        for data in names
        {
            let node = HMHNode(name: data[0])
            graph.addNode(node:node)
        }
        
        //create edges
        let edges:[ [Any] ] = [ [0, 1, Direction.NORTH], [1, 2, Direction.WEST], [2, 3, Direction.SOUTH], [0, 3, Direction.WEST], [0, 4, Direction.EAST], [4, 5, Direction.NORTH], [4, 6, Direction.SOUTH], [4, 7, Direction.EAST], [7, 8, Direction.NORTH], [7, 9, Direction.EAST], [9, 10, Direction.EAST] ]
        
        for edge in edges
        {
            graph.addEdge( first:edge[0] as! Int, second:edge[1] as! Int, dir:edge[2] as! Direction )
        }
        
        let destinationNode = graph.nodeByName("QA")
        
        parentNodes = graph.computeGraphForDestination( destinationNode! )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOrientation() {
        let currentNode = graph.nodeByName("RE")!
        let nextNode = graph.nodeByName("hol mic")!
        let edge = graph.findEdge(from: currentNode, to: nextNode)!
            
        XCTAssert( graph.relativeDirection(from: currentNode, to: nextNode, edge: edge) == .NORTH )
    }
    
    func testAccessNodeWrongName(){
        XCTAssert( graph.nodeByName("wron asdad") == nil )
        XCTAssert( graph.nodeByName("") == nil )
    }
    
    func testNodeDescription(){
        XCTAssert( graph.nodeByName("QA")?.description == "QA" )
    }
    
    func testGraphDescription(){
        XCTAssert( graph.description != nil )
    }
    
    func testDirectionLeft(){
        let currentNode = graph.nodeByName("RE")!
        let nextNode = graph.nodeByName("hol mic")!
        let edge = graph.findEdge(from: currentNode, to: nextNode)!
        
        let dir = graph.relativeDirection(from: currentNode, to: nextNode, edge: edge)
        
        let or = graph.orientationRelativeToDirection(from: nextNode, to: parentNodes[nextNode]!, dir: dir)
        
        XCTAssert( or == .LEFT )
    }
    
    func testDirectionBack(){
        let currentNode = graph.nodeByName("hol 1")!
        let nextNode = graph.nodeByName("hol mic")!
        let edge = graph.findEdge(from: currentNode, to: nextNode)!
        
        let dir = graph.relativeDirection(from: currentNode, to: nextNode, edge: edge)
        
        let or = graph.orientationRelativeToDirection(from: nextNode, to: parentNodes[nextNode]!, dir: dir)
        
        XCTAssert( or == .BACK )
    }
    
    func testDirectionRight(){
        let currentNode = graph.nodeByName("Game")!
        let nextNode = graph.nodeByName("hol mic")!
        let edge = graph.findEdge(from: currentNode, to: nextNode)!
        
        let dir = graph.relativeDirection(from: currentNode, to: nextNode, edge: edge)
        
        let or = graph.orientationRelativeToDirection(from: nextNode, to: parentNodes[nextNode]!, dir: dir)
        
        XCTAssert( or == .RIGHT )
    }
    
    func testDirectionForward(){
        let currentNode = graph.nodeByName("hol mic")!
        let nextNode = graph.nodeByName("hol 1")!
        let edge = graph.findEdge(from: currentNode, to: nextNode)!
        
        let dir = graph.relativeDirection(from: currentNode, to: nextNode, edge: edge)
        
        let or = graph.orientationRelativeToDirection(from: nextNode, to: parentNodes[nextNode]!, dir: dir)
        
        XCTAssert( or == .FORWARD )
    }
    
    func testBeaconDescription(){
        let beacon = BluetoothManager.instance.beacons.find("HMHBeacona5")
        
        XCTAssert( beacon?.description == "Beacon: HMHBeacona5" )
    }
}
