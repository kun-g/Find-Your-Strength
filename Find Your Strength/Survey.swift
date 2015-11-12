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
    var lastQuestion : Question?
    
    init() {
        let entity = NSEntityDescription.entityForName(EntitiName.Name.rawValue, inManagedObjectContext: Survey.sharedContext)!
        super.init(entity: entity, insertIntoManagedObjectContext: Survey.sharedContext)
        Survey.next()
    }
    
    override func awakeFromFetch() {
        super.awakeFromFetch()
        lastQuestion = questions.sortedArrayUsingDescriptors([NSSortDescriptor(key: "id", ascending: true)]).last as? Question
    }
}

extension Survey {
    static var sharedInstance: Survey {
        struct Static {
            static let instance = Survey()
        }
        return Static.instance
    }
    
    static var sharedContext: NSManagedObjectContext {
        return CoreDataManager.sharedInstance().managedObjectContext
    }
    
    static var currentQuestion: Question {
        get {
            return sharedInstance.lastQuestion!
        }

        set (newVal) {
            sharedInstance.lastQuestion = newVal
        }
    }
    
    static var currentQuestionID : Int {
        return sharedInstance.questions.count + 1
    }
    
    static var progress: Float {
        return Float(sharedInstance.questions.count)/Float(Survey.sharedInstance.questions.count)
    }
    
    class func next() -> Question? {
        if progress < 1 {
            currentQuestion = Question(id: currentQuestionID, context: sharedContext)
            return currentQuestion
        }
        return nil
    }
}