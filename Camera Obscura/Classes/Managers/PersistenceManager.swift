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
     Saves a single movie object, extracted from a dictionary. Check for existing records to update, otherwise saves fresh object
     
     - parameter dictionary: The dictionary that contains the movie object's data
     */
    func saveMovie(fromMovieDictionary movieDictionary: [String : AnyObject]) -> Movie?
    {
        guard let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate else
        {
            return nil
        }
        let moc = appDelegate.managedObjectContext
        
        guard let entity = NSEntityDescription.entityForName(AppConstants.Models.MovieModelName, inManagedObjectContext:moc), imdbID =  movieDictionary["imdbID"] as? String else
        {
            return nil
        }
        
        if let movie = fetchMovie(withIMDBID: imdbID)
        {
            return fillAndSaveMovie(fromDictionary: movieDictionary, withMovieObject: movie, inManagedObjectContext: moc)
        }
        else
        {
            let movie = Movie(entity: entity, insertIntoManagedObjectContext: moc)
            return fillAndSaveMovie(fromDictionary: movieDictionary, withMovieObject: movie, inManagedObjectContext: moc)
        }
    }
    
    /**
     Updates data of passed Movie object with data from dictionary in provided MOC
    
     - parameter dictionary:             dictionary with movie object data
     - parameter withMovieObject:        movie object to update
     - parameter inManagedObjectContext: provided managed object context
     
     - returns: A single optional Movie object
     */
    private func fillAndSaveMovie(fromDictionary dictionary: [String : AnyObject], withMovieObject: Movie, inManagedObjectContext: NSManagedObjectContext) -> Movie?
    {
        addData(fromDictonary: dictionary, toMovieObject: withMovieObject)
        
        do
        {
            try inManagedObjectContext.save()
            print("Saved Movie with Title: \(withMovieObject.title)")
            return withMovieObject
        }
        catch
        {
            print("Saving movie failed")
            return nil
        }
    }
    
    /**
     Adds data to passed Movie object with data from dictionary
     
     - parameter movieDictionary: dictionary, source of movie object data
     - parameter toMovieObject:   Movie object, destination of data
     
     - returns: A single optional Movie object
     */
    private func addData(fromDictonary movieDictionary: [String : AnyObject], toMovieObject: Movie) -> Movie?
    {
        guard let title = movieDictionary["Title"] as? String,
                year = movieDictionary["Year"] as? String,
                posterURL = movieDictionary["Poster"] as? String,
                imdbID = movieDictionary["imdbID"] as? String,
                type = movieDictionary["Type"] as? String else
        {
            return nil
        }
        
        toMovieObject.title         = title
        toMovieObject.year          = year
        toMovieObject.posterURL     = posterURL
        toMovieObject.imdbID        = imdbID
        toMovieObject.type          = type
        
        if let rated = movieDictionary["Rated"] as? String,
            released = movieDictionary["Released"] as? String,
            runtime = movieDictionary["Runtime"] as? String,
            genre = movieDictionary["Genre"] as? String,
            director = movieDictionary["Director"] as? String,
            writer = movieDictionary["Writer"] as? String,
            actors = movieDictionary["Actors"] as? String,
            plot = movieDictionary["Plot"] as? String,
            language = movieDictionary["Language"] as? String,
            country = movieDictionary["Country"] as? String,
            awards = movieDictionary["Awards"] as? String,
            metascore = movieDictionary["Metascore"] as? String,
            imdbRating = movieDictionary["imdbRating"] as? String,
            imdbVotes = movieDictionary["imdbVotes"] as? String
        {
            toMovieObject.rated         = rated
            toMovieObject.released      = released
            toMovieObject.runtime       = runtime
            toMovieObject.genre         = genre
            toMovieObject.director      = director
            toMovieObject.writer        = writer
            toMovieObject.actors        = actors
            toMovieObject.plot          = plot
            toMovieObject.language      = language
            toMovieObject.country       = country
            toMovieObject.awards        = awards
            toMovieObject.metascore     = metascore
            toMovieObject.imdbRating    = imdbRating
            toMovieObject.imdbVotes     = imdbVotes
        }
        
        return toMovieObject
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
    func fetchMovie(withIMDBID imdbID: String) -> Movie?
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