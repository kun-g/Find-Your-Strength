//
//  SpinnerProtocol.swift
//  On the Map
//
//  Created by 郭坤 on 15/11/3.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation
import UIKit

protocol Spinner : class {
    var spinnerView : UIActivityIndicatorView! {
        get
        set
    }
    
    var view : UIView! {
        get
    }
    
    func startSpinner ()
    func stopSpinner ()
}

extension Spinner {
    func startSpinner () {
        if spinnerView == nil {
            spinnerView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            spinnerView.color = UIColor.grayColor()
            spinnerView.center = view.center
            view.addSubview(spinnerView)
        }
        
        spinnerView.startAnimating()
        view.userInteractionEnabled = false
        view.alpha = 0.5
    }
    
    func stopSpinner () {
        dispatch_async(dispatch_get_main_queue(), {
            self.spinnerView.hidden = true
            self.spinnerView.stopAnimating()
            self.view.userInteractionEnabled = true
            self.view.alpha = 1
        })
    }
}