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
    private let emptyCellID                 = "emptyCell"
    
    private let movieDetailSeque            = "movieDetailSeque"
    
    private var selectedMovie               : Movie?
    
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
    
    private func fetchMovies(withSearchString searchString: String)
    {
        RequestManager.sharedInstance.queryMovies(withTitleLike: searchString, forPage: currentPageToFetch) { success, responseMovieList in
            
            if let responseMovieList = responseMovieList
            {
                self.moviesListCountBeforeUpdate    = self.moviesList.count
                self.currentPageToFetch             += 1
                self.moviesList.appendContentsOf(responseMovieList)
                self.reloadTableView()
            }
        }
    }
    
    private func reloadTableView()
    {
        var indexPaths = [NSIndexPath]()
        
        for index in moviesListCountBeforeUpdate ..< self.moviesList.count
        {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            indexPaths.append(indexPath)
        }
    
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Middle)
        tableView.endUpdates()
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

//MARK: UITableViewDelegate

extension MovieListViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        guard let section = MovieTableSection(rawValue: indexPath.section) where section == .List else
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
        return moviesList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        guard let section = MovieTableSection(rawValue: indexPath.section) where section == .List else
        {
            return 0
        }
        
        switch section
        {
            case .List:
                return movieCellHeight
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        guard let section = MovieTableSection(rawValue: indexPath.section) where section == .List else
        {
            return tableView.dequeueReusableCellWithIdentifier(emptyCellID, forIndexPath: indexPath)
        }
        
        switch section
        {
            case .List:
                var cell = tableView.dequeueReusableCellWithIdentifier(movieCellID, forIndexPath: indexPath) as? MovieListCell
                
                if cell == nil
                {
                    cell = MovieListCell(style: .Default, reuseIdentifier: movieCellID)
                }
                
                return cell!
        }
    }
}