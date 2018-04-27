//
//  CompanyParser.swift
//  mockup_SketchBot
//
//  Created by Gimin Moon on 4/23/18.
//  Copyright © 2018 Dorothy Peng. All rights reserved.
//

import Foundation
import SwiftyJSON

class CompanyParser {
    let companies = ["Ameren", "Duke Energy","ComEd","UGI Utlities, Inc.", "The Dayton Power and Light Company"]

    func getCompanyName(outputJSON : JSON) -> String {
        let jsonArray = outputJSON.stringValue
        for company in companies {
            if jsonArray.contains(company) {
                return company
            }
        }
        return ""
    }
}
