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
        let orderedStrength:[Survey.Strength] = [.Curiosity, .Love_Of_Learning, .Judgment, .Creativity, .Social_Intelligence, .Perspective, .Bravery,
            .Industry, .Honesty, .Kindness, .Capacity_to_Love_And_be_Loved, .Citizenship, .Fairness, .Leadership, .Self_Control, .Caution,
            .Appreciation_Of_Beauty_And_Excellence, .Gratitude, .Optimism, .Spirituality, .Modesty, .Humor, .Zest, .Forgiveness]
        for var i = 0; i < 240; i++ {
            let content = NSLocalizedString("Question\(i+1)", comment: "")
            surveies.append(SurveyItem(content: content, inverse: false, strength: orderedStrength[i%orderedStrength.count]))
        }
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
        return SurveyLib.sharedInstance.surveies[id-1]
    }
}
