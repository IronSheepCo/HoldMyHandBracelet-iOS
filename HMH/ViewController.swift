//
//  ViewController.swift
//  HMH
//
//  Created by Mac on 07/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, BluetoothManagerDelegate {
    fileprivate let graph:HMHGraph = HMHGraph()
    fileprivate var parentNodes:[HMHNode:HMHNode] = [:]
    
    //destination node
    fileprivate var destinationNode:HMHNode?
    
    //current node the user is in
    fileprivate var currentNode:HMHNode?
    
    //current direction, it changes when changing the node
    fileprivate var currentDirection:Direction = .WEST
    
    
    //the current orienation the user is in
    fileprivate var currentOrientation:Orientation = .RIGHT
    
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var dirLabel: UILabel!
    @IBOutlet weak var debugTextArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let coefs = [
            "HMHBeacona5": 2.8962,
            "HMHBeacona6": 3.1102,
            "HMHBeacona7": 3.0001,
            "HMHBeacona8": 1.2763,
            "HMHBeacona9": 4.5890,
            "HMHBeacona10": 2.8960,
            "HMHBeacona11": 2.7072,
            "HMHBeacona12": 1.9857,
            "HMHBeacon": 3.2400,
        ]
        
        let bleManager = BluetoothManager.instance
        bleManager.coefList( coefs )
        bleManager.delegate = self
        
        //init the logger
        Logger.i.setView( debugTextArea )
        
        initGraph()
        
        Logger.i.log( "init graph" )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func closestBeacon(_ beacon: HMHBeacon) {
        debugLabel?.text = "Current \(beacon.Node?.name) d: \(beacon.distance)"
        
        Logger.i.log("current beacon \(beacon.Node!.name)")
        
        if destinationNode == beacon.Node
        {
            debugLabel?.text = (debugLabel?.text)! + "\n" + "You are there"
        }
        else
        {
            let nextNode = beacon.Node
            
            if currentNode == nextNode {
                //still in the same place
                return
            }
            
            guard let currentNode = currentNode else
            {
                //first time we get a beacon
                self.currentNode = nextNode
                dirLabel.text = currentOrientation.rawValue
                return
            }
            
            guard let edge = graph.findEdge(from: currentNode, to: nextNode!) else { return }
            
            Logger.i.log("moving to new node")
            
            //set the current direction
            currentDirection = graph.relativeDirection(from: currentNode, to: nextNode!, edge: edge)
            
            Logger.i.log("current direction \(currentDirection.rawValue)")
            
            self.currentNode = nextNode
            
            //set the current orientation
            currentOrientation = graph.orientationRelativeToDirection(from: currentNode, to: parentNodes[currentNode]!, dir: currentDirection)
            
            debugLabel?.text = (debugLabel?.text)! + "\n" + nextNode!.name
            
            dirLabel.text = currentOrientation.rawValue
        }
    }

    fileprivate func initGraph()
    {
        //create nodes
        let names = [ ["hol 1","HMHBeacona5"], ["hol 2","HMHBeacona11"], ["QA","HMHBeacona6"], ["Dev","HMHBeacona7"], ["hol mic","HMHBeacona9"], ["Game","HMHBeacona10"], ["RE","HMHBeacon"], ["hol baie",""], ["hol buc",""], ["baie",""], ["buc",""] ]
        
        for data in names
        {
            let node = HMHNode(name: data[0])
            graph.addNode(node:node)
            
            BluetoothManager.instance.setAreaToNode( data[1], node: node)
        }
        
        //create edges
        let edges:[ [Any] ] = [ [0, 1, Direction.NORTH], [1, 2, Direction.WEST], [2, 3, Direction.SOUTH], [0, 3, Direction.WEST], [0, 4, Direction.EAST], [4, 5, Direction.NORTH], [4, 6, Direction.SOUTH], [4, 7, Direction.EAST], [7, 8, Direction.NORTH], [7, 9, Direction.EAST], [9, 10, Direction.EAST] ]
        
        for edge in edges
        {
            graph.addEdge( first:edge[0] as! Int, second:edge[1] as! Int, dir:edge[2] as! Direction )
        }
        
        destinationNode = graph.nodeByName("QA")
        
        parentNodes = graph.computeGraphForDestination( destinationNode! )
    }

}

