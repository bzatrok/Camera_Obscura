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
    
    //MARK: Functions
    
    class func createLoadingIndicator() -> UIAlertController
    {
        let loadingString       = NSLocalizedString("loading", comment: "loading indicator title")
        let loadingIndicator    = UIAlertController(title: loadingString, message: nil, preferredStyle: .Alert)
        
        return loadingIndicator
    }
}
