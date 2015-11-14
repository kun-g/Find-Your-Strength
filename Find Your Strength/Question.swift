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
    
    enum Answer : Int {
        case Nil = -1
        case Yes = 0
        case Likely = 1
        case Neutral = 2
        case Unlikely = 3
        case No = 4
        
        static let score = [5, 4, 3, 2, 1]
        static let inversedScore = [1, 2, 3, 4, 5]
    }
    
    @NSManaged var answerRaw : Int16
    @NSManaged var id : Int32
    @NSManaged var survey : Survey
    
    var answer : Answer {
        get { return Answer(rawValue: Int(answerRaw)) ?? .Nil }
        set { answerRaw = Int16(newValue.rawValue) }
    }
    
    lazy var question : SurveyItem = {
        return SurveyLib.content(atIndex: Int(self.id))
    }()
    
    var content : String? {
        return question.content
    }
    var inversed : Bool {
        return question.inverse
    }
    var strength: Survey.Strength {
        return question.strength
    }
    
    func scoreForStrength(forAnswer:Answer) -> Int {
        return inversed ? Answer.inversedScore[answer.rawValue] : Answer.score[answer.rawValue]
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(survey: Survey, id : Int, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(EntitiName.Name.rawValue, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = Int32(id)
        self.survey = survey
        answer = .Nil
    }
}