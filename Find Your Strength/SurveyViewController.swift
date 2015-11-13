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
    /*
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupCurrentQuestion()
    }*/
    
    func setupCurrentQuestion () {
        questionLabel.text = survey.lastQuestion!.content
        answerControl.selectedSegmentIndex = survey.lastQuestion!.answer.rawValue
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
        // TODO: show brief report dialog
    }
    
    @IBAction func onAnswerSelected(sender: UISegmentedControl) {
        //Survey.currentQuestion.answer = answerControl.selectedSegmentIndex
        //nextQuestion()
    }
}