//
//  PersistenceManager.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class PersistenceManager
{
    //MARK: Variables
    
    let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    //MARK: Initialization
    
    static let sharedInstance = PersistenceManager()
    private init() {}
    
    //MARK: Functions
    
    //SAVE
    
    /**
     Saves a single movie objects, extracted from a dictionary
     
     - parameter dictionary: The dictionary that contains the movie object's data
     */
    func saveMovie(fromJSON json: JSON)
    {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else
        {
            return
        }
        let moc = appDelegate.managedObjectContext
        
        guard let entity = NSEntityDescription.entityForName(AppConstants.Models.MovieModelName, inManagedObjectContext:moc) else
        {
            return
        }
        
        let movie = Movie(entity: entity, insertIntoManagedObjectContext: moc)
        
        movie.title         = json["Title"].stringValue
        movie.year          = json["Year"].stringValue
        movie.rated         = json["Rated"].stringValue
        movie.released      = json["Released"].stringValue
        movie.runtime       = json["Runtime"].stringValue
        movie.genre         = json["Genre"].stringValue
        movie.director      = json["Director"].stringValue
        movie.writer        = json["Writer"].stringValue
        movie.actors        = json["Actors"].stringValue
        movie.plot          = json["Plot"].stringValue
        movie.language      = json["Language"].stringValue
        movie.country       = json["Country"].stringValue
        movie.awards        = json["Awards"].stringValue
        movie.posterURL     = json["Poster"].stringValue
        movie.metascore     = json["Metascore"].stringValue
        movie.imdbRating    = json["imdbRating"].stringValue
        movie.imdbVotes     = json["imdbVotes"].stringValue
        movie.imdbID        = json["Title"].stringValue
        movie.type          = json["Type"].stringValue
        
        do
        {
            try moc.save()
        }
        catch
        {
            print("Saving movie failed")
        }
        return
    }
    
    /**
     Saves an array of movie objects, extracted from a movie dictionary array
     
     - parameter dictionaryArray: the array that contains the movie dictionary objects
     */
    func saveMovies(fromJSON json: JSON)
    {
        for item in json
        {
            let movieJSON = item.1
            
            saveMovie(fromJSON: movieJSON)
        }
    }
    
    //FETCH
    
    /**
     Fetches a movie from CoreData based on their IMDB ID
     
     - parameter imdbID: The imdbID of the movie to be fetched for CoreData
     
     - returns: Returns an optional Movie object
     */
    func fetchMovies(withIMDBID imdbID: String) -> Movie?
    {
        let predicate = NSPredicate(format: "imdbID == %@", imdbID)
        
        guard let movies = fetchMovies(withPredicate: predicate) else
        {
            return nil
        }
        
        return movies.first
    }
    
    /**
     Fetches a list of movies with titles similar to the search string passed
     
     - parameter titleLike: The title or search string to match movie titles to
     
     - returns: Returns an optional array of Movie objects
     */
    func fetchMovies(withTitleLike titleLike: String) -> [Movie]?
    {
        let predicate = NSPredicate(format: "title like %@", titleLike)
        return fetchMovies(withPredicate: predicate)
    }
    
    /**
     Fetches a list of movies with an NSPredicate
     
     - parameter predicate: An optional predicate that contains filter logic for the fetch
     
     - returns: Returns an optional array of Movie objects
     */
    func fetchMovies(withPredicate predicate: NSPredicate?) -> [Movie]?
    {
        guard let appDelegate = appDelegate else
        {
            return nil
        }
        let moc             = appDelegate.managedObjectContext
        let entity          = NSEntityDescription.entityForName(AppConstants.Models.MovieModelName, inManagedObjectContext:moc)
        let request         = NSFetchRequest()
        request.entity      = entity
        
        if let predicate = predicate
        {
            request.predicate = predicate
        }
        
        do
        {
            guard let fetchedObjectsArray = try moc.executeFetchRequest(request) as? [Movie] else
            {
                return nil
            }
            return fetchedObjectsArray
        }
        catch
        {
            return nil
        }
    }
    
    //DELETE
    
    /**
     Deletes all Movie objects
     */
    func deteleAllMovies()
    {
        guard let appDelegate = appDelegate, movies = fetchMovies(withPredicate: nil) else
        {
            print("No movies found")
            return
        }
        
        let moc = appDelegate.managedObjectContext
        
        for movie in movies
        {
            moc.deleteObject(movie)
        }
        
        do
        {
            try moc.save()
            print("Clearing Movies Succeeded")
        }
        catch
        {
            print("Clearing Movies Failed")
        }
    }
}