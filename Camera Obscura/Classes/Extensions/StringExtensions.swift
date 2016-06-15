//
//  StringExtensions.swift
//  Camera Obscura
//
//  Created by Bence Zatrok on 15/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

extension String
{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}