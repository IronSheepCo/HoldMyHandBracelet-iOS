//
//  Logger.swift
//  HMH
//
//  Created by Mac on 15/11/2016.
//  Copyright © 2016 ironsheep.tech. All rights reserved.
//

import Foundation
import UIKit

class Logger{
    public static let i:Logger = Logger()
    
    private var view:UITextView!
    
    private init(){
        
    }
    
    func log(_ what:String ){
        
        print(what)
        
        guard let view = view else { return }
        
        view.text = what + "\n" + view.text
    }
    
    func setView(_ view:UITextView )
    {
        self.view = view
    }
    
}
