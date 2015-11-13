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
            print("Fail to delete db:\(url.path)")
        }
    }

    func testPersistance() {
        let user = User.newUser("Test")!
        user.startSurvey()
        XCTAssert(user.survey != nil, "Survey should not be nil")
        XCTAssert(user.survey!.questions.count == 1, "Survey should be initialized")
        XCTAssert(user.survey.lastQuestion != nil, "Last question should be initialized")
        
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
        XCTAssert(survey.lastQuestion!.id == 1)
        survey.next()
        XCTAssert(survey.lastQuestion!.id == 1, "Can't proceed when question not answered")

        for var i = 0; i < survey.questions.count; i++ {
            print(survey.lastQuestion?.content)
            survey.lastQuestion!.answer = .Likely
            survey.next()
        }
        
        XCTAssert(survey.progress == 1, "Complete")
    }
    
}
