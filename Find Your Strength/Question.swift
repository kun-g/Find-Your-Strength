//
//  Question.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation
import CoreData

class Question : NSManagedObject {
    enum EntitiName : String {
        case Name = "Question"
    }
    
    @NSManaged var answer : NSNumber
    @NSManaged var id : NSNumber
    
    lazy var question : SurveyItem = {
        return SurveyLib.content(atIndex: self.id.integerValue)
    }()
    
    var content : String? {
        return question.content
    }
    var inversed : Bool {
        return question.inverse
    }
    
    init(id : Int, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(EntitiName.Name.rawValue, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = id
    }
    
    override func prepareForDeletion() {
        
    }
}