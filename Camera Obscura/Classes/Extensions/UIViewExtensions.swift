//
//  UIViewExtensions.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

extension UIView
{
    func findFirstResponder() -> UIResponder?
    {
        if isFirstResponder()
        {
            return self
        }
        
        for view in subviews
        {
            if let responder = view.findFirstResponder()
            {
                return responder
            }
        }
        
        return nil
    }
}