//
//  LoadingIndicator.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

class LoadingIndicator: UIAlertController
{
    //MARK: Variables
    
    static let alertViewTag = 12345
    
    //MARK: Functions
    
    class func show()
    {
        let alertView           = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let activityIndicator   = UIActivityIndicatorView(frame: alertView.view.bounds)
        
        guard let window = UIApplication.sharedApplication().windows.first else
        {
            return
        }
        
        alertView.view.addSubview(activityIndicator)
        activityIndicator.userInteractionEnabled = false
        activityIndicator.startAnimating()
        alertView.view.tag = alertViewTag
        window.addSubview(alertView.view)
    }
    
    class func dismiss()
    {
        guard let window = UIApplication.sharedApplication().windows.first else
        {
            return
        }
        
        for subview in window.subviews
        {
            if subview.tag == alertViewTag
            {
                subview.removeFromSuperview()
            }
        }
    }
}
