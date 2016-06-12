//
//  MovieDetailViewController.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController
{
    //MARK: Variables
    
    var selectedMovie : Movie!
    
    private let headerCellHeight    : CGFloat = 150
    private let headerCellID        = "MovieDetailHeaderCell"
    
    private let infoCellHeight      : CGFloat = 50
    private let infoCellID          = "MovieDetailDescriptionCell"
    
    private let emptyCellID         = "emptyCell"
    
    //MARK: IBOutlets
    
    //MARK: Enums
    
    private enum MovieDetailTableSection: Int
    {
        case Header
        case Info
        
        static var count: Int
        {
            var current = 0
            while let _ = self.init(rawValue: current) { current += 1 }
            return current
        }
        
    }
    
    //MARK: Life-cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: IBActions
    
    //MARK: Initialization
    
    /**
     Sets basic settings related to the viewController
     */
    private func setupView()
    {
        //
    }
}

//MARK: EXTENSIONS

//MARK: UITableViewDelegate

extension MovieDetailViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        guard let section = MovieTableSection(rawValue: indexPath.section) where section == .List else
//        {
//            return
//        }
//        
//        selectedMovie = moviesList[indexPath.row]
//        performSegueWithIdentifier(movieDetailSeque, sender: self)
    }
}

//MARK: UITableViewDataSource

extension MovieDetailViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return MovieDetailTableSection.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let section = MovieDetailTableSection(rawValue: section) else
        {
            return 0
        }
        
        switch section
        {
            case .Header:
                return 1
                
            case .Info:
                return selectedMovie.infoDictArray.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        guard let section = MovieDetailTableSection(rawValue: indexPath.section) else
        {
            return 0
        }
        
        switch section
        {
            case .Header:
                return headerCellHeight
            
            case .Info:
                return infoCellHeight
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        guard let section = MovieDetailTableSection(rawValue: indexPath.section) else
        {
            return tableView.dequeueReusableCellWithIdentifier(emptyCellID, forIndexPath: indexPath)
        }
        
        switch section
        {
            case .Header:
                var cell = tableView.dequeueReusableCellWithIdentifier(headerCellID, forIndexPath: indexPath) as? MovieDetailHeaderCell
                
                if cell == nil
                {
                    cell = MovieDetailHeaderCell(style: .Default, reuseIdentifier: headerCellID)
                }
                
                cell!.headerImageView.image = UIImage()
                cell!.titleLabel.text       = selectedMovie.title
                
                return cell!
                
            case .Info:
                var cell = tableView.dequeueReusableCellWithIdentifier(infoCellID, forIndexPath: indexPath) as? MovieDetailDescriptionCell
                
                if cell == nil
                {
                    cell = MovieDetailDescriptionCell(style: .Default, reuseIdentifier: infoCellID)
                }
                
                let infoDict    = selectedMovie.infoDictArray[indexPath.row]
                let keys        = infoDict.keys
                
                guard let title = keys.first, subtitle = infoDict[title] else
                {
                    return cell!
                }
                
                cell!.setupCell(forCompanyInfoWithTitle: title, andSubtitle: subtitle)
                
                return cell!
        }
    }
}