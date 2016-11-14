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
    fileprivate var nextNode:[HMHNode:HMHNode] = [:]
    
    fileprivate var destinationNode:HMHNode?
    
    @IBOutlet weak var debugLabel: UILabel!
    
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
        
        initGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func closestBeacon(_ beacon: HMHBeacon) {
        debugLabel?.text = "Current \(beacon.Node?.name) d: \(beacon.distance)"
        
        if destinationNode == beacon.Node
        {
            debugLabel?.text = (debugLabel?.text)! + "\n" + "You are there"
        }
        else
        {
            debugLabel?.text = (debugLabel?.text)! + "\n" + nextNode[beacon.Node!]!.name
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
        let edges:[ [Any] ] = [ [0, 1, Direction.NORTH], [1, 2, Direction.WEST], [2, 3, Direction.SOUTH], [0, 2, Direction.WEST], [0, 4, Direction.WEST], [4, 5, Direction.NORTH], [4, 6, Direction.NORTH], [4, 7, Direction.SOUTH], [7, 8, Direction.EAST], [7, 9, Direction.NORTH], [9, 10, Direction.EAST] ]
        
        for edge in edges
        {
            graph.addEdge( first:edge[0] as! Int, second:edge[1] as! Int, dir:edge[2] as! Direction )
        }
        
        destinationNode = graph.nodeByName("QA")
        
        nextNode = graph.computeGraphForDestination( destinationNode! )
    }

}

