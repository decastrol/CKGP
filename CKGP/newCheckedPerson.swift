//
//  newPerson.swift
//  CKGP
//
//  Created by Luke de Castro on 11/16/16.
//  Copyright © 2016 Luke de Castro. All rights reserved.
//

import UIKit

class newCheckedPerson: NSObject {
    var personId = Int()
    var firstName = String()
    var lastName = String()
    var bibNumber = Int()
    var raceId = NSInteger()
    var email = String()

    func show() {
        print(firstName)
        print(lastName)
        print(bibNumber)
        print(email)
        print(personId)
        print(raceId)
    }
}
