//
//  SurveyViewController.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class SurveyViewController : UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerControl: UISegmentedControl!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var survey : Survey!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrentQuestion()
    }

    func setupCurrentQuestion () {
        questionLabel.text = survey.currentQuestion!.strength.localizedString + ":" + survey.currentQuestion!.content!
        answerControl.selectedSegmentIndex = survey.currentQuestion!.answer.rawValue
        progressBar.progress = survey.progress
    }

    func nextQuestion () {
        if survey.next() != nil {
            setupCurrentQuestion()
        } else {
            onSurveyComplete()
        }
    }

    func onSurveyComplete() {
        progressBar.progress = survey.progress
        performSegueWithIdentifier("showReport", sender: self)
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReport" {
            navigationController?.popViewControllerAnimated(true)
            let controller = segue.destinationViewController as! ReportViewController
            controller.survey = survey
        }
    }

    @IBAction func onAnswerSelected(sender: UISegmentedControl) {
        survey.currentQuestion!.answer = Question.Answer(rawValue: answerControl.selectedSegmentIndex)!
        nextQuestion()
        CoreDataManager.sharedInstance().saveContext()
    }
}