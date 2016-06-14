//
//  MovieListViewController.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController
{
    //MARK: Variables
    
    private var moviesList                  = [Movie]()
    private var currentPageToFetch          = 1
    private var moviesListCountBeforeUpdate = 0
    
    private let movieCellHeight             : CGFloat = 100
    private let movieCellID                 = "MovieListCell"
    private let placeholderCellID           = "PlaceholderCell"
    private let emptyCellID                 = "emptyCell"
    
    private let movieDetailSeque            = "movieDetailSeque"
    
    private var selectedMovie               : Movie?
    private let loadingIndicator            = LoadingIndicator.createLoadingIndicator()
    
    private var shouldDisplayPlaceholder : Bool {
        
        guard moviesList.count > 0 else
        {
            return true
        }
        return false
    }
    
    //MARK: IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Enums
    
    private enum MovieTableSection: Int
    {
        case List
        
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
        navigationItem.title                                    = NSLocalizedString("movieListTitle", comment: "navigation bar title in movie list view")
    }
    
    /**
     Sets up required delegates
     */
    private func setupDelegation()
    {
        tableView.delegate      = self
        tableView.dataSource    = self
        searchBar.delegate      = self
    }
    
    /**
     Clears previous results, fetches movies based on the entered search string
     
     - parameter searchString: String entered into searchbar
     */
    private func fetchMovies(withSearchString searchString: String)
    {
        moviesList = []
//        tableView.reloadData()
        
        presentViewController(loadingIndicator, animated: true, completion: nil)
        
        RequestManager.sharedInstance.queryMovies(withTitleLike: searchString, forPage: currentPageToFetch) { success, responseMovieList in
            
            if let responseMovieList = responseMovieList
            {
                self.moviesListCountBeforeUpdate    = self.moviesList.count
                self.currentPageToFetch             += 1
                self.moviesList.appendContentsOf(responseMovieList)
                self.reloadTableView()
            }
            else
            {
                self.loadingIndicator.dismissViewControllerAnimated(true, completion: nil)
            }
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
            
            self.loadingIndicator.dismissViewControllerAnimated(true, completion: nil)
            
        })
    }

    //MARK: Functions
    
    //MARK: Segue handling
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        guard segue.identifier == movieDetailSeque, let selectedMovie = selectedMovie, destinationViewController = segue.destinationViewController as? MovieDetailViewController else
        {
            return
        }
        
        destinationViewController.selectedMovie = selectedMovie
    }
}

//MARK: EXTENSIONS

extension MovieListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        guard let searchString = searchBar.text else
        {
            return
        }
        
        searchBar.resignFirstResponder()
        fetchMovies(withSearchString: searchString)
    }
}

//MARK: UITableViewDelegate

extension MovieListViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        guard !shouldDisplayPlaceholder ,let section = MovieTableSection(rawValue: indexPath.section) where section == .List else
        {
            return
        }
        
        selectedMovie = moviesList[indexPath.row]
        performSegueWithIdentifier(movieDetailSeque, sender: self)
    }
}

//MARK: UITableViewDataSource

extension MovieListViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return MovieTableSection.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard !shouldDisplayPlaceholder else
        {
            return 1
        }
        return moviesList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        guard !shouldDisplayPlaceholder ,let section = MovieTableSection(rawValue: indexPath.section) where section == .List else
        {
            return UIScreen.mainScreen().bounds.height - 104
        }
        
        switch section
        {
            case .List:
                return movieCellHeight
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        guard !shouldDisplayPlaceholder, let section = MovieTableSection(rawValue: indexPath.section) where section == .List else
        {
            return tableView.dequeueReusableCellWithIdentifier(placeholderCellID, forIndexPath: indexPath)
        }
        
        switch section
        {
            case .List:
                var cell = tableView.dequeueReusableCellWithIdentifier(movieCellID, forIndexPath: indexPath) as? MovieListCell
                
                if cell == nil
                {
                    cell = MovieListCell(style: .Default, reuseIdentifier: movieCellID)
                }
                
                let movie = moviesList[indexPath.row]
                
                cell!.titleLabel.text = movie.title
                
                guard let posterURL = movie.posterURL else
                {
                    return cell!
                }
                
                cell!.backgroundImageView.image = UIImage()
                
                cell!.setBackgroundImage(forPosterURL: posterURL)
                
                return cell!
        }
    }
}