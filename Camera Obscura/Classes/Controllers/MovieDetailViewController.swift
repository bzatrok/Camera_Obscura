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
        setupDelegation()
        fetchMovieDetails()
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
//        calculateCellHeights()
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
//        var indexPaths = [NSIndexPath]()
//        
//        for index in 0 ..< selectedMovie.infoDictArray.count
//        {
//            let indexPath = NSIndexPath(forRow: index, inSection: MovieDetailTableSection.Info.rawValue)
//            indexPaths.append(indexPath)
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            self.tableView.beginUpdates()
//            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
//            self.tableView.endUpdates()
//            
//        })
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.tableView.beginUpdates()
            let sections = NSIndexSet(indexesInRange: NSMakeRange(0, self.tableView.numberOfSections))
            self.tableView.reloadSections(sections, withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
//            self.loadingIndicator.dismissViewControllerAnimated(true, completion: nil)
            
        })
    }
    
    private func calculateCellHeights()
    {
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        guard let plot = selectedMovie.plot else
        {
            return
        }
        
        let plotLabelCalculatedHeight = CGFloat(180) + plot.heightWithConstrainedWidth(screenWidth, font: UIFont(name: "HelveticaNeue-Regular", size: 19)!)
        
        headerCellHeight = headerCellHeight + plotLabelCalculatedHeight
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
                guard didLoadInfo else
                {
                    return 0
                }
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
                
                cell!.headerImageView.image = UIImage(color: AppColors.blueBackgroundColor)
                cell!.setCellData(forMovie: selectedMovie)
                
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