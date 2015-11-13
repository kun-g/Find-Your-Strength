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
    var lastQuestion : Question?
    
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
        return Float(questions.count)/Float(SurveyLib.sharedInstance.count)
    }

    func next() -> Question? {
        guard progress < 1 else {
            return nil
        }
        
        let lastQuestionNotAnswerd = lastQuestion != nil && lastQuestion!.answer == .Nil
        let hasLastQuestionButNotLoaded = lastQuestion == nil && questions.count != 0
        
        // TODO: fix this hardcoded -1
        if lastQuestionNotAnswerd {
            return lastQuestion
        } else if hasLastQuestionButNotLoaded {
            lastQuestion = questions.sortedArrayUsingDescriptors([NSSortDescriptor(key: "id", ascending: true)]).last as? Question
        } else {
            lastQuestion = Question(survey:self, id: currentQuestionID, context: CoreDataManager.sharedInstance().managedObjectContext)
        }
        return lastQuestion
    }
    
    var currentQuestionID : Int {
        return questions.count + 1
    }
}