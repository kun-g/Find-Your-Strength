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

class SurveyViewController : UIViewController, Spinner {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerControl: UISegmentedControl!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var survey : Survey!
    var spinnerView : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurrentQuestion()
    }

    func setupCurrentQuestion () {
        questionLabel.text = survey.currentQuestion!.content!
        answerControl.selectedSegmentIndex = -1
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
        startSpinner()
        User.sharedInstance?.save( { (success: Bool, error: NSError?) -> Void in
            self.stopSpinner()
            if (error != nil) {
                self.alert(error!.description)
            }
            self.performSegueWithIdentifier("showReport", sender: self)
        })
        progressBar.progress = survey.progress
        
    }
    
    
    func alert (message : String) {
        let alertCtr = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertCtr.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertCtr, animated: true, completion: nil)
        })
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