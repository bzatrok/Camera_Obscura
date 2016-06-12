//
//  MovieDetailHeaderCell.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

class MovieDetailHeaderCell: UITableViewCell
{
    //MARK: Variables
    
    //MARK: IBOutlets
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Life-cycle
    
    //MARK: IBActions
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        headerImageView.contentMode = .ScaleAspectFill
    }
    
    //MARK: Initialization
    
    func setBackgroundImage(forPosterURL posterURL: String)
    {
        RequestManager.sharedInstance.fetchImage(posterURL) { success, responseImage in
            
            guard let responseImage = responseImage where success else
            {
                return
            }
            self.headerImageView.image = responseImage
            print("loaded movie poster image")
        }
    }
}
