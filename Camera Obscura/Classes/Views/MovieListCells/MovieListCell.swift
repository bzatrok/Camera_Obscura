//
//  MovieListCell.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell
{
    //MARK: Variables
    
    //MARK: IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Life-cycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        backgroundImageView.contentMode = .ScaleAspectFill
    }
    
    //MARK: IBActions
    
    //MARK: Initialization
}
