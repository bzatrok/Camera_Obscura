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
    
    var selectedMovie                       : Movie!
    
    private var headerCellHeight            : CGFloat = 150
    private let headerCellID                = "MovieDetailHeaderCell"
    
    private let infoCellHeight              : CGFloat = 30
    private let infoCellID                  = "MovieDetailDescriptionCell"
    private let emptyCellID                 = "emptyCell"
    
    private let loadingIndicator            = LoadingIndicator.createLoadingIndicator()
    private var didLoadInfo                 = false
    
    //MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Enums
    
    private enum MovieDetailTableSection: Int
    {
        case Header
        case Released
        case Genre
        case IMDBRating
        case Director
        case Writer
        case Actors
        case Language
        case Counry
        case Awards
        
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
        setupDelegation()
        fetchMovieDetails()
    }
    
    //MARK: IBActions
    
    //MARK: Initialization
    
    /**
     Sets basic settings related to the viewController
     */
    private func setupView()
    {
        edgesForExtendedLayout                                  = .None
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppColors.greyTextColor]
        navigationController?.navigationBar.tintColor           =  AppColors.greyTextColor
        
        guard let title = selectedMovie.title else
        {
            return
        }
        navigationItem.title = title
    }
    
    /**
     Sets up required delegates
     */
    private func setupDelegation()
    {
        tableView.delegate      = self
        tableView.dataSource    = self
    }
    
    /**
     Clears previous results, fetches movies based on the entered search string
     
     - parameter searchString: String entered into searchbar
     */
    private func fetchMovieDetails()
    {
        guard let imdbID = selectedMovie.imdbID else
        {
            return
        }
        
//        presentViewController(loadingIndicator, animated: true, completion: nil)

        RequestManager.sharedInstance.queryMovie(withImdbID: imdbID) { success, responseMovie in
            
            if let responseMovie = responseMovie where success
            {
                self.selectedMovie  = responseMovie
                self.didLoadInfo    = true
                self.calculateCellHeights()
                self.reloadTableView()
            }
//            self.loadingIndicator.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /**
     Reloads tableview by inserting rows of movie results
     */
    private func reloadTableView()
    {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.tableView.beginUpdates()
            let sections = NSIndexSet(indexesInRange: NSMakeRange(0, self.tableView.numberOfSections))
            self.tableView.reloadSections(sections, withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
        })
    }
    
    private func calculateCellHeights()
    {
        let screenWidth = UIScreen.mainScreen().bounds.width - 40
        
        guard let plot = selectedMovie.plot, font = UIFont(name: AppFonts.helveticaNeue, size: 19) else
        {
            return
        }
        
        let plotLabelCalculatedHeight   = plot.heightWithConstrainedWidth(screenWidth, font: font)
        headerCellHeight                = headerCellHeight + plotLabelCalculatedHeight
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
//            case .Header:
//                return 1
            
            default:
                return 1
//                guard didLoadInfo else
//                {
//                    return 0
//                }
//                return selectedMovie.infoDictArray.count
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
            
            default:
                
                guard didLoadInfo else
                {
                    return infoCellHeight
                }
                
                let infoDict    = selectedMovie.infoDictArray[indexPath.section - 1]
                let keys        = infoDict.keys
                
                if let title = keys.first, subtitle = infoDict[title], font = UIFont(name: AppFonts.helveticaNeue, size: 15)
                {
                    let screenWidth = UIScreen.mainScreen().bounds.width / 2
                    let labelHeight = subtitle.heightWithConstrainedWidth(screenWidth, font: font)
                    return labelHeight + 10
                }
                
                return infoCellHeight
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        guard didLoadInfo, let currentSection = MovieDetailTableSection(rawValue: section) where currentSection != .Header else
        {
            return nil
        }
        
        let infoDict    = selectedMovie.infoDictArray[section - 1]
        let keys        = infoDict.keys
        
        if let title = keys.first
        {
            return title
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        guard let currentSection = MovieDetailTableSection(rawValue: section) where currentSection != .Header else
        {
            return 0
        }
        return 25
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
                
                cell!.headerImageView.image = UIImage(color: AppColors.blueBackgroundColor)
                cell!.setCellData(forMovie: selectedMovie)
                
                return cell!
                
            default:
                
                guard didLoadInfo else
                {
                    return tableView.dequeueReusableCellWithIdentifier(emptyCellID, forIndexPath: indexPath)
                }
                
                var cell = tableView.dequeueReusableCellWithIdentifier(infoCellID, forIndexPath: indexPath) as? MovieDetailDescriptionCell
                
                if cell == nil
                {
                    cell = MovieDetailDescriptionCell(style: .Default, reuseIdentifier: infoCellID)
                }
                
                let infoDict    = selectedMovie.infoDictArray[indexPath.section - 1]
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