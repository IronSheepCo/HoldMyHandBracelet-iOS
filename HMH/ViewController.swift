//
//  ViewController.swift
//  HMH
//
//  Created by Mac on 07/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    fileprivate let graph:HMHGraph = HMHGraph()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        BluetoothManager.instance
        
        initGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func initGraph()
    {
        //create nodes
        let names = ["hol 1", "hol 2", "QA", "Dev", "hol mic", "Game", "RE", "hol baie", "hol buc", "baie", "buc"]
        
        for name in names
        {
            graph.addNode(node: HMHNode(name: name) )
        }
        
        //create edges
        let edges = [ [0, 1], [1,2], [2,3], [3,0], [0,4], [4,5], [4,6], [4,7], [7,8], [7,9], [9,10] ]
        
        for edge in edges
        {
            graph.addEdge( edge )
        }
    }

}

