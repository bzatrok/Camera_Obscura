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
        backgroundImageView.alpha       = 0
    }
    
    //MARK: IBActions
    
    //MARK: Initialization
    
    func setBackgroundImage(forPosterURL posterURL: String)
    {
        RequestManager.sharedInstance.fetchImage(posterURL) { [weak self] success, responseImage in
            
            guard let responseImage = responseImage where success else
            {
                self?.animateBackgroundAlpha(toValue: 1)
                return
            }
            self?.backgroundImageView.image = responseImage
            self?.animateBackgroundAlpha(toValue: 1)
        }
    }

    private func animateBackgroundAlpha(toValue value: Double)
    {
        let floatValue = CGFloat(value)
        
        UIView.animateWithDuration(0.3) { [weak self] in
            
            self?.backgroundImageView.alpha = floatValue
        }
    }
}
