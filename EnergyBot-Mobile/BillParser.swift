//
//  BillParser.swift
//  mockup_SketchBot
//
//  Created by Gimin Moon on 4/4/18.
//  Copyright © 2018 Dorothy Peng. All rights reserved.
//

import Foundation
import SwiftyJSON

//protocol functions for all Bills to maintain
protocol BillParser {
    
    func getIndex(dataArray : [String], nameKeyword : String, addressKeyword : String, usageKeyword : String)
    func getName() -> String
    func getAddress() -> String
    func getUsage() -> String
    func checkValidName(input : String) -> Bool
    func isValidJSON(jsonData : JSON) -> Bool
}

class Bill : BillParser
{
    var nameIndex : Int!
    var addressIndex : Int!
    var usageIndex : Int!
    var dataArray : [String]!

    // Possible data label constants
    var nameKeyword : String?
    var addressKeyword : String?
    var usageKeyword : String?
    
    //distance from each target values
    var nameDistance : Int?
    var addressDistance : Int?
    var usageDistance : Int?
    
    init(){
        
    }
    // Initialize value indices - takes in and intializes name, address, usage indices as well as the data array of strings
    init(fullText : JSON)
    {
        
    }
    //loop through array and find indexes for each keyword
    func getIndex(dataArray : [String], nameKeyword : String, addressKeyword : String, usageKeyword : String) {
        return
    }
    // Get name value
    func getName() -> String
    {
        return ""
    }
    func checkValidName(input: String) -> Bool {
        return true
    }
    // Get address value
    func getAddress() -> String
    {
        return ""
    }
    // Get usage value
    func getUsage() -> String
    {
        return ""
    }
    // Check if json has name, address, usage keywords
    func isValidJSON(jsonData: JSON) -> Bool {
        let jsonString = jsonData.stringValue
        return ( jsonString.contains(nameKeyword!) && jsonString.contains(addressKeyword!) && jsonString.contains(usageKeyword!) )
    }
}

// Ameren Bills
class AmerenBill : Bill
{
    // Initialize value indices - takes in and intializes name, address, usage indices as well as the data array of strings
    override init(fullText : JSON)
    {
        super.init()
        //convert JSON to string
        
        // Possible data label constants for AmerenBills
        self.nameKeyword = "Customer Name"
        self.addressKeyword = "Service Address"
        self.usageKeyword = "Usage Summary"
        
        nameDistance = 1
        addressDistance = -2
        usageDistance = -1

        let fullTextString = fullText.stringValue
        dataArray = fullTextString.components(separatedBy: "\n")
        print(dataArray)
        if(isValidJSON(jsonData: fullText))
        {
            getIndex(dataArray: dataArray, nameKeyword: self.nameKeyword!, addressKeyword: self.addressKeyword!, usageKeyword: self.usageKeyword!)
        }
    }
    
    //loop through array and find indexes for each keyword
    override func getIndex(dataArray : [String], nameKeyword : String, addressKeyword : String, usageKeyword : String) {
        for (i, element) in dataArray.enumerated() {
            if element == nameKeyword {
                self.nameIndex = i
            }
            if element == addressKeyword {
                self.addressIndex = i
            }
            if element == usageKeyword {
                self.usageIndex = i
            }
        }
    }
    // Get name value
    override func getName() -> String
    {
        if checkValidName(input: dataArray[nameIndex + nameDistance!]) {
            return dataArray[nameIndex + nameDistance!]
        }
        self.nameIndex = self.nameIndex + 1
        return dataArray[nameIndex + nameDistance!]
    }
    override func checkValidName(input: String) -> Bool {
        let digits = CharacterSet.decimalDigits
        for uni in input.unicodeScalars {
            if digits.contains(uni) {
                return false
            }
        }
        return true
    }
    // Get address value
    override func getAddress() -> String
    {
        var address : String = ""
        for i in addressIndex + addressDistance!..<addressIndex {
            address += "\(dataArray[i]) "
        }
        return address
    }
    // Get usage value
    override func getUsage() -> String
    {
        return dataArray[usageDistance! + usageIndex]
    }
}

// Comed bills
class ComedBill : Bill
{
   
    // Initialize value indices - takes in and intializes name, address, usage indices as well as the data array of strings
    override init(fullText : JSON)
    {
        super.init()
    
        // Possible data label constants
        self.nameKeyword = "Name"
        self.addressKeyword = "Service Location"
        self.usageKeyword = "Purchased Electricity Adjustment"
        
        nameDistance = 1
        addressDistance = 0 // Service Location SERVICE ADDRESS CITY
        usageDistance = 1
    
        //convert JSON to string
        let fullTextString = fullText.stringValue
        dataArray = fullTextString.components(separatedBy: "\n")
        if(isValidJSON(jsonData: fullText))
        {
            getIndex(dataArray: dataArray, nameKeyword: self.nameKeyword!, addressKeyword: self.addressKeyword!, usageKeyword: self.usageKeyword!)
        }

    }
    
    //loop through array and find indexes for each keyword
    override func getIndex(dataArray : [String], nameKeyword : String, addressKeyword : String, usageKeyword : String) {
        for (i, element) in dataArray.enumerated() {
            if element == nameKeyword {
                self.nameIndex = i
            }
            if element == addressKeyword {
                self.addressIndex = i
            }
            if element == usageKeyword {
                self.usageIndex = i
            }
        }
    }
    
    // Get name value
    override func getName() -> String
    {
        return dataArray[nameIndex + nameDistance!]
    }
    // Get address value
    override func getAddress() -> String
    {
        var address : String = ""
        for i in addressIndex..<addressIndex + addressDistance! {
            address += "\(dataArray[i]) "
        }
        return address
    }
    // Get usage value
    override func getUsage() -> String
    {
        return dataArray[usageDistance! + usageIndex]
    }

}

// Dayton bills
class DaytonBill : Bill
{
    // Initialize value indices - takes in and intializes name, address, usage indices as well as the data array of strings
    override init(fullText : JSON)
    {
        super.init()
    
        // Possible data label constants
        self.nameKeyword  = "Total Account Balance"
        self.addressKeyword = "Total Account Balance"
        self.usageKeyword = "Current Period"
        
        nameDistance = 9
        addressDistance = 10 // Service Location SERVICE ADDRESS CITY
        usageDistance = 6 // Historical Usage: 0.000 kWh
        
        //convert JSON to string
        let fullTextString = fullText.stringValue
        dataArray = fullTextString.components(separatedBy: "\n")
        print(dataArray)
        if(isValidJSON(jsonData: fullText))
        {
            getIndex(dataArray: dataArray, nameKeyword: self.nameKeyword!, addressKeyword: self.addressKeyword!, usageKeyword: self.usageKeyword!)
        }
    }
    
    //loop through array and find indexes for each keyword
    override func getIndex(dataArray : [String], nameKeyword : String, addressKeyword : String, usageKeyword : String) {
        var usageCheck = false
        var nameCheck = false
        var addressCheck = false
        
        for (i, element) in dataArray.enumerated() {
            if (!nameCheck && element == nameKeyword) {
                self.nameIndex = i
                nameCheck = true
            }
            if (!addressCheck && element == addressKeyword) {
                self.addressIndex = i
                addressCheck = true
            }
            if (!usageCheck && element == usageKeyword) {
                self.usageIndex = i
                usageCheck = true
            }
        }
    }
    
    // Get name value
    override func getName() -> String
    {
        return dataArray[nameIndex + nameDistance!]
    }
    // Get address value
    override func getAddress() -> String
    {
        return dataArray[addressIndex + addressDistance!]
    }
    // Get usage value
    override func getUsage() -> String
    {
        return dataArray[usageDistance! + usageIndex]
    }

}

// Duke bills
class DukeBill : Bill
{
   
    // Initialize value indices - takes in and intializes name, address, usage indices as well as the data array of strings
    override init(fullText : JSON)
    {
        super.init()
        //convert JSON to string
        let fullTextString = fullText.stringValue
        dataArray = fullTextString.components(separatedBy: "\n")
        if(isValidJSON(jsonData: fullText))
        {
            getIndex(dataArray: dataArray, nameKeyword: self.nameKeyword!, addressKeyword: self.addressKeyword!, usageKeyword: self.usageKeyword!)
        }
        
        // Possible data label constants
        self.nameKeyword = "Name"
        self.addressKeyword = "Service Address"
        self.usageKeyword = "Usage"
        
        nameDistance = 2
        addressDistance = 3 // Service Location SERVICE ADDRESS CITY
        usageDistance = 0 // Usage - 2,322 kWh
    }
    
    //loop through array and find indexes for each keyword
    override func getIndex(dataArray : [String], nameKeyword : String, addressKeyword : String, usageKeyword : String) {
        for (i, element) in dataArray.enumerated() {
            if element == nameKeyword {
                self.nameIndex = i
            }
            if element == addressKeyword {
                self.addressIndex = i
            }
            if element == usageKeyword {
                self.usageIndex = i
            }
        }
    }
    
    // Get name value
    override func getName() -> String
    {
        return dataArray[nameIndex + nameDistance!]
    }
    // Get address value
    override func getAddress() -> String
    {
        return dataArray[addressIndex + addressDistance!]
    }
    // Get usage value
    override func getUsage() -> String
    {
        return dataArray[usageDistance! + usageIndex]
    }
}

// UGI Penn
class UGIBill : Bill
{
    // Initialize value indices - takes in and intializes name, address, usage indices as well as the data array of strings
    override init(fullText : JSON)
    {
        super.init()
    
        // Possible data label constants
        self.nameKeyword = "Bill Summary Service to"
        self.addressKeyword = "Bill Summary Service to"
        self.usageKeyword = "Billing Period:"
        
        nameDistance = 1
        addressDistance = 3 // Service Location SERVICE ADDRESS CITY
        usageDistance = 2 // Usage - 2,322 kWh
        
        //convert JSON to string
        let fullTextString = fullText.stringValue
        dataArray = fullTextString.components(separatedBy: "\n")
        if(isValidJSON(jsonData: fullText))
        {
            getIndex(dataArray: dataArray, nameKeyword: self.nameKeyword!, addressKeyword: self.addressKeyword!, usageKeyword: self.usageKeyword!)
        }

    }
    
    //loop through array and find indexes for each keyword
    override func getIndex(dataArray : [String], nameKeyword : String, addressKeyword : String, usageKeyword : String) {
        for (i, element) in dataArray.enumerated() {
            if element == nameKeyword {
                self.nameIndex = i
            }
            else if element == addressKeyword {
                self.addressIndex = i
            }
            else if element == usageKeyword {
                self.usageIndex = i
            }
        }
    }
    
    // Get name value
    override func getName() -> String
    {
        return dataArray[nameIndex + nameDistance!]
    }
    // Get address value
    override func getAddress() -> String
    {
        var address : String = ""
        for i in addressIndex..<addressIndex + addressDistance! {
            address += "\(dataArray[i]) "
        }
        return address
    }
    // Get usage value
    override func getUsage() -> String
    {
        return dataArray[usageDistance! + usageIndex]
    }
}
