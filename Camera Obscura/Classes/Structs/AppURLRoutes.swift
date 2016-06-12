//
//  AppURLRoutes.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

struct AppURLRoutes
{
    static let baseAPIURL               = "http://www.omdbapi.com/"
    static let similarTitleSearchURL    = "\(baseAPIURL)?s="
    static let exactTitleSearchURL      = "\(baseAPIURL)?t="
    static let exactImdbIDSearchURL     = "\(baseAPIURL)?i="
    static let paginationPostFix        = "&page="
    
    static func similarTitleSearchUrl(withSearchString searchString: String, forPage: Int) -> String
    {
        let searchArray = searchString.stringByReplacingOccurrencesOfString(" ", withString: "-")
        return "\(AppURLRoutes.similarTitleSearchURL)\(searchArray)\(AppURLRoutes.paginationPostFix)\(forPage)"
    }
}