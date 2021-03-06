//
//  Find_Your_StrengthTests.swift
//  Find Your StrengthTests
//
//  Created by 郭坤 on 15/11/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import XCTest
@testable import Find_Your_Strength

class Find_Your_StrengthTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        cleanDB()
    }
    
    override func tearDown() {
        cleanDB()
        
        super.tearDown()
    }
    
    func cleanDB () {
        let url = CoreDataManager.sharedInstance().applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        do {
            try NSFileManager.defaultManager().removeItemAtPath(url.path!)
        } catch {
            //print("Fail to delete db:\(url.path)")
        }
    }

    func testPersistance() {
        let user = User.newUser("Test")!
        user.startSurvey()
        XCTAssert(user.survey != nil, "Survey should not be nil")
        XCTAssert(user.survey!.questions.count == 1, "Survey should be initialized")
        XCTAssert(user.survey.currentQuestion != nil, "Last question should be initialized")
        
        CoreDataManager.sharedInstance().saveContext()
        let anotherUser = User.loadUser("Test")!
        XCTAssert(anotherUser.objectID == user.objectID, "Data shoulde be saved")
        XCTAssert(anotherUser.survey != nil, "Survey should not be nil")
        XCTAssert(anotherUser.survey!.questions.count == 1, "Survey should be initialized")
        XCTAssert(anotherUser.objectID == User.sharedInstance?.objectID, "Shared user should be update")
    }
    
    func testSurvey() {
        let user = User.newUser("Test")!
        user.startSurvey()
        let survey = user.survey
        XCTAssert(survey.currentQuestion!.id == 1)
        survey.next()
        XCTAssert(survey.currentQuestion!.id == 1, "Can't proceed when question not answered")

        for var i = 0; i < survey.questions.count; i++ {
            survey.currentQuestion!.answer = .Likely
            survey.next()
        }
        
        XCTAssert(survey.progress == 1, "Complete")
    }
    
    func testSurveyCompress () {
        let user = User.newUser("Test")!
        user.startSurvey()
        let survey = user.survey
        survey.currentQuestion!.answer = .Likely
        survey.next()
        XCTAssert(survey.compress() == "19")
    }
    
    func testSurveyRestore () {
        let user = User.newUser("Test")!
        let survey = Survey(user: user, insertIntoManagedObjectContext: CoreDataManager.sharedInstance().managedObjectContext)
        survey.restore("19")
        XCTAssert(survey.questions.count == 2)
        XCTAssert(survey.currentQuestion!.answer == .Nil)
    }
    
}
