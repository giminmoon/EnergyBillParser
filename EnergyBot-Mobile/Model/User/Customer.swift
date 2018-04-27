//
//  Customer.swift
//  mockup_SketchBot
//
//  Created by Mark on 2/27/18.
//  Copyright © 2018 Dorothy Peng. All rights reserved.
//

import Foundation

class Customer : BaseUser
{
    var _industry : String?
    
    var _location : Location?
    
    struct Preference
    {
        var _brand = true
        var _fixedBudget = true
        var _green = true
        var _longTerm = true
    }
    
    var _sites : Array<Site>?
    
    struct CustomerType
    {
        var _reason = "NUMBER_OF_SITES"
        var _value = "INSTANT"
    }
    
    
}
