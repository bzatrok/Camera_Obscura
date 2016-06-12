//
//  PersistenceManager.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit
import CoreData

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
    func saveMovie(fromMovieDictionary movieDictionary: [String : AnyObject]) -> Movie?
    {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else
        {
            return nil
        }
        let moc = appDelegate.managedObjectContext
        
        guard let entity = NSEntityDescription.entityForName(AppConstants.Models.MovieModelName, inManagedObjectContext:moc) else
        {
            return nil
        }
        
        let movie = Movie(entity: entity, insertIntoManagedObjectContext: moc)
        
        movie.title         = movieDictionary["Title"] as? String
        movie.year          = movieDictionary["Year"] as? String
        movie.rated         = movieDictionary["Rated"] as? String
        movie.released      = movieDictionary["Released"] as? String
        movie.runtime       = movieDictionary["Runtime"] as? String
        movie.genre         = movieDictionary["Genre"] as? String
        movie.director      = movieDictionary["Director"] as? String
        movie.writer        = movieDictionary["Writer"] as? String
        movie.actors        = movieDictionary["Actors"] as? String
        movie.plot          = movieDictionary["Plot"] as? String
        movie.language      = movieDictionary["Language"] as? String
        movie.country       = movieDictionary["Country"] as? String
        movie.awards        = movieDictionary["Awards"] as? String
        movie.posterURL     = movieDictionary["Poster"] as? String
        movie.metascore     = movieDictionary["Metascore"] as? String
        movie.imdbRating    = movieDictionary["imdbRating"] as? String
        movie.imdbVotes     = movieDictionary["imdbVotes"] as? String
        movie.imdbID        = movieDictionary["Title"] as? String
        movie.type          = movieDictionary["Type"] as? String
        
        do
        {
            try moc.save()
            return movie
        }
        catch
        {
            print("Saving movie failed")
            return nil
        }
    }
    
    /**
     Saves an array of movie objects, extracted from a movie dictionary array
     
     - parameter dictionaryArray: the array that contains the movie dictionary objects
     */
    func saveMovies(fromMovieArray movieArray: [[String : AnyObject]]) -> [Movie]
    {
        var moviesList = [Movie]()
        
        for movieDictionary in movieArray
        {
            guard let movie = saveMovie(fromMovieDictionary: movieDictionary) else
            {
                break
            }
            moviesList.append(movie)
        }
        
        return moviesList
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