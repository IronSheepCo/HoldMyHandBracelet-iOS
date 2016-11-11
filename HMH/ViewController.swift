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
    
    //fileprivate var destinationNode:HMHNode
    
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
        debugLabel?.text = (debugLabel?.text)! + "\n" + nextNode[beacon.Node!]!.name
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
        let edges = [ [0, 1], [1,2], [2,3], [3,0], [0,4], [4,5], [4,6], [4,7], [7,8], [7,9], [8,10] ]
        
        for edge in edges
        {
            graph.addEdge( edge )
        }
        
        let node = graph.nodeByName("QA")
        
        nextNode = graph.computeGraphForDestination( node! )
    }

}

