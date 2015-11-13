//
//  User.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/12.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    enum EntitiName : String {
        case Name = "User"
    }
    
    @NSManaged var name: NSString
    @NSManaged var survey : Survey!
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(EntitiName.Name.rawValue, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
    }
    
    func startSurvey(force : Bool = false) -> Survey {
        if survey == nil || force { // TODO: 如果survey被覆盖了，原先的survey是否会被删除?
            if survey != nil {
                CoreDataManager.sharedInstance().managedObjectContext.deleteObject(survey)
            }
            survey = Survey(user: self, insertIntoManagedObjectContext: CoreDataManager.sharedInstance().managedObjectContext)
        }

        survey.next()
        return survey
    }
}

extension User {
    struct Static {
        static var instance : User?
    }
    
    static var sharedInstance: User? {
        get {
            return Static.instance
        }
        
        set (newUser) {
            Static.instance = newUser
        }
    }
    
    class func loadUser(name:String) -> User? {
        let context = CoreDataManager.sharedInstance().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: EntitiName.Name.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try context.executeFetchRequest(fetchRequest)
            assert(result.count <= 1, "Should be not duplicate")
            sharedInstance = result.first as? User
            
        } catch {
            sharedInstance = nil
        }
        
        return sharedInstance
    }
    
    class func newUser(name:String) -> User? {
        sharedInstance = User(name: name, insertIntoManagedObjectContext: CoreDataManager.sharedInstance().managedObjectContext)
        return sharedInstance
    }
}