//
//  MainViewController.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MainViewController : UIViewController {
    var hasOngoingSurvey : Bool {
        return User.sharedInstance != nil && User.sharedInstance!.survey.progress < 1
    }
    
    var hasReport : Bool {
        return User.sharedInstance!.survey.progress == 1
    }

    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var surveyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
            loadUser()
        }
        
        if hasOngoingSurvey {
            continueSurvey()
        }
        
        reportButton.hidden = !hasReport
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkIfLoggedIn()
    }
    
    func checkIfLoggedIn () {
        if PFUser.currentUser() == nil {
            let logInController = PFLogInViewController()
            logInController.delegate = self
            logInController.signUpController?.delegate = self
            self.presentViewController(logInController, animated:true, completion: nil)
        } else {
            loadUser()
        }
    }
    
    func loadUser () {
        if PFUser.currentUser() != nil {
            if User.loadUser((PFUser.currentUser()?.username)!) == nil {
                User.newUser((PFUser.currentUser()?.username!)!)
                CoreDataManager.sharedInstance().saveContext()
            }
        }
    }
    
    @IBAction func onLogoutTouch(sender: AnyObject) {
        PFUser.logOut()
        checkIfLoggedIn()
    }
    
    @IBAction func onSurveyTouch(sender: AnyObject) {
        if hasReport {
            let alert = UIAlertController(title: "Notice", message: "This action will overwrite the survey result, continue?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action: UIAlertAction!) in
                dispatch_async(dispatch_get_main_queue(), {
                    User.sharedInstance?.startSurvey(true)
                    self.performSegueWithIdentifier("startSurvey", sender: self)
                })
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("startSurvey", sender: self)
        }
    }
    
    @IBAction func onReportTouch(sender: AnyObject) {
        if hasReport {
            performSegueWithIdentifier("showReport", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startSurvey" {
            User.sharedInstance?.startSurvey()
            CoreDataManager.sharedInstance().saveContext()
            let controller = segue.destinationViewController as! SurveyViewController
            controller.survey = User.sharedInstance?.survey
        } else if segue.identifier == "showReport" {
        }
    }
    
    func continueSurvey () {
        performSegueWithIdentifier("startSurvey", sender: self)
    }
}

extension MainViewController: PFLogInViewControllerDelegate {
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("didFailToLogInWithError", error?.localizedDescription)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        print("didLogInUser", user)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        print("logInViewControllerDidCancelLogIn")
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension MainViewController: PFSignUpViewControllerDelegate {
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        print("didSignUpUser", user)
        dismissViewControllerAnimated(true, completion: nil)
    }
}