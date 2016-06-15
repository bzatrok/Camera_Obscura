//
//  MovieDetailDescriptionCell.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

class MovieDetailDescriptionCell: UITableViewCell
{
    //MARK: Variables
    
    //MARK: IBOutlets
    
    @IBOutlet weak var rightLabel: UILabel!
    
    //MARK: Life-cycle
    
    //MARK: IBActions
    
    //MARK: Initialization
    
    func setupCell(forCompanyInfoWithTitle title: String, andSubtitle: String)
    {
        rightLabel.text                     = andSubtitle
    }
}
