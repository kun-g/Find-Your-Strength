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
        case Appreciation_Of_Beauty_And_Excellence = "Appreciation of beauty and excellence"
        case Gratitude = "Gratitude"
        case Caution = "Caution, prudence, and discretion"
        case Self_Control = "Self-control and self-regulation"
        case Leadership = "Leadership"
        case Optimism = "Hope, optimism, and future-mindedness"
        case Spirituality = "Spirituality, sense of purpose, and faith"
        case Forgiveness = "Forgiveness and mercy"
        case Zest = "Zest, enthusiasm, and energy"
        case Humor = "Humor and playfulness"
        case Modesty = "Modesty and humility"
        case Fairness = "Fairness, equity, and justice"
        case Citizenship = "Citizenship, teamwork, and loyalty"
        case Social_Intelligence = "Social intelligence"
        case Creativity = "Creativity, ingenuity, and originality"
        case Love_Of_Learning = "Love of learning"
        case Perspective = "Perspective wisdom"
        case Bravery = "Bravery and valor"
        case Capacity_to_Love_And_be_Loved = "Capacity to love and be loved"
        case Kindness = "Kindness and generosity"
        case Honesty = "Honesty, authenticity, and genuineness"
        case Industry = "Industry, diligence, and perseverance"
        case Curiosity = "Curiosity and interest in the world"
        case Judgment = "Judgment, critical thinking, and open-mindedness"




        var localizedString : String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
        
        var description : String {
            return NSLocalizedString(self.rawValue+"#description", comment: "")
        }

        static let allValues = [Appreciation_Of_Beauty_And_Excellence, Gratitude, Caution, Self_Control, Leadership, Optimism, Spirituality, Forgiveness, 
            Zest, Humor, Modesty, Fairness, Citizenship, Social_Intelligence, Creativity, Love_Of_Learning, Perspective, Bravery, Capacity_to_Love_And_be_Loved,
            Kindness, Honesty, Industry, Curiosity, Judgment]
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
