//
//  Survey.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation
import CoreData

class Survey: NSManagedObject {
    enum EntitiName : String {
        case Name = "Survey"
    }
    
    @NSManaged var questions: NSSet
    @NSManaged var user: User
    var currentQuestion : Question?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(user: User, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(EntitiName.Name.rawValue, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.user = user
    }
    
    override func awakeFromFetch() {
        super.awakeFromFetch()
    }
    
    var progress: Float {
        let total = Float(SurveyLib.sharedInstance.count)
        var current = 0
        if lastQuestion != nil {
            current = (lastQuestion!.answer != .Nil) ? questions.count : questions.count - 1
        }
        
        return Float(current)/total
    }
    
    var lastQuestion : Question? {
        guard questions.count > 0 else {
            return nil
        }
        return questions.sortedArrayUsingDescriptors([NSSortDescriptor(key: "id", ascending: true)]).last as? Question
    }

    func next() -> Question? {
        guard progress < 1 else {
            return nil
        }
        
        let currentQuestionNotAnswerd = currentQuestion != nil && currentQuestion!.answer == .Nil
        let currentQuestionButNotLoaded = currentQuestion == nil && questions.count != 0
        
        // TODO: fix this hardcoded -1
        if currentQuestionNotAnswerd {
            return currentQuestion
        } else if currentQuestionButNotLoaded {
            currentQuestion = lastQuestion
        } else {
            currentQuestion = Question(survey:self, id: currentQuestionID, context: CoreDataManager.sharedInstance().managedObjectContext)
        }
        return currentQuestion
    }
    
    var currentQuestionID : Int {
        return questions.count + 1
    }
}

// Calculating scores
extension Survey {
    enum Strength : String {
        case StrengthA
        case StrengthB
        
        static let allValues = [StrengthA, StrengthB]
    }
    
    func report() -> [Strength:Int]? {
        guard progress == 1 else {
            return nil
        }
        var result = [Strength:Int]()
        for s in Strength.allValues {
            result[s] = 0
        }
        questions.forEach({
            let question = $0 as! Question
            result[question.strength]! += question.scoreForStrength(question.answer)
        })
        return result
    }
}
