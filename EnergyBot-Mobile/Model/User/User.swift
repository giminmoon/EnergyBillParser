//
//  User.swift
//  mockup_SketchBot
//
//  Created by Mark on 2/27/18.
//  Copyright © 2018 Dorothy Peng. All rights reserved.
//

import Foundation

class User : BaseUser
{
    var phone : String?
    
    struct Settings
    {
        var emailNotification = true
        var smsNotification = true
    }
    
    var termsOfService = true
    
    var title : String?
}
