//
//  raceObject.swift
//  CKGP
//
//  Created by Luke de Castro on 3/22/16.
//  Copyright © 2016 Luke de Castro. All rights reserved.
//

import UIKit

class raceObject: NSObject {
    var raceid = Int()
    var date = NSDate()
    var distance = Float()
    var name = String()
    
    func printMe() {
        print(raceid)
        print(date)
        print(distance)
        print(name)
    }
}
