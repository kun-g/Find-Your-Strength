//
//  SurveyLib.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/12.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation

class SurveyLib {
    var surveies : [SurveyItem] = []
    
    init() {
        // TODO: init from config file
        surveies = [
            SurveyItem(content: "Question 1", inverse: false),
            SurveyItem(content: "Question 2", inverse: false),
        ]
    }
    
    var count : Int {
        return surveies.count
    }
}

// class func/var
extension SurveyLib {
    static var sharedInstance: SurveyLib {
        struct Static {
            static let instance = SurveyLib()
        }
        return Static.instance
    }

    class func content(atIndex id: Int) -> SurveyItem {
        return SurveyLib.sharedInstance.surveies[id]
    }
}