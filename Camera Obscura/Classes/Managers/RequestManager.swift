//
//  RequestManager.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit

class RequestManager
{
    //MARK: Variables
    
    //MARK: Initialization
    
    static let sharedInstance = RequestManager()
    private init() {}
    
    //MARK: Functions
    
    //IMAGES
    
    func fetchImage(fromURLString: String, completion: (success: Bool, responseImage: UIImage?) -> Void)
    {
        guard let URL = NSURL(string: fromURLString) else
        {
            completion(success: false, responseImage: nil)
            return
        }
        let request = NSURLRequest(URL: URL)
        let session = NSURLSession.sharedSession()
        let task    = session.dataTaskWithRequest(request) { data, response, error in
            
            guard error == nil, let data = data else
            {
                completion(success: false, responseImage: nil)
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                let image = UIImage(data: data)
                completion(success: true, responseImage: image)
            }
        }
        task.resume()
    }
    
    //MOVIE
    
    /**
     Queries movies from OMDB API based on a title search string
     
     - parameter titleLike:  Searchstring to pass into URL
     - parameter completion: completion block with success bool and optinal JSON return
     */
    func queryMovies(withTitleLike titleLike: String, forPage: Int, completion: (success: Bool, responseMovieList: [Movie]?) -> Void)
    {
        guard titleLike.characters.count > 1 else
        {
            completion(success: false, responseMovieList: nil)
            return
        }
        
        let URLstring = AppURLRoutes.similarTitleSearchUrl(withSearchString: titleLike, forPage: forPage)
        queryMovies(withURLString: URLstring, completion: completion)
    }
    
    /**
     Queries movies from OMDB API based on exact title
     
     - parameter exactTitle: Searchstring to pass into URL
     - parameter completion: completion block with success bool and optinal JSON return
     */
    func queryMovie(withExactTitle exactTitle: String, completion: (success: Bool, responseMovie: Movie?) -> Void)
    {
        guard exactTitle.characters.count > 1 else
        {
            completion(success: false, responseMovie: nil)
            return
        }
        
        let URLstring = "\(AppURLRoutes.exactTitleSearchURL)\(exactTitle)"
        
        queryMovies(withURLString: URLstring) { success, responseMovieList in
            
            guard success, let responseMovieList = responseMovieList, responseMovie = responseMovieList.first else
            {
                completion(success: false, responseMovie: nil)
                return
            }
            completion(success: true, responseMovie: responseMovie)
        }
    }
    
    /**
     Queries movies from OMDB API based on IMDB ID
     
     - parameter imdbID:     Searchstring to pass into URL
     - parameter completion: completion block with success bool and optinal JSON return
     */
    func queryMovie(withImdbID imdbID: String, completion: (success: Bool, responseMovie: Movie?) -> Void)
    {
        guard imdbID.characters.count > 1 else
        {
            completion(success: false, responseMovie: nil)
            return
        }
        
        let URLstring = "\(AppURLRoutes.exactImdbIDSearchURL)\(imdbID)"
        
        queryMovies(withURLString: URLstring) { success, responseMovieList in
            
            guard success, let responseMovieList = responseMovieList, responseMovie = responseMovieList.first else
            {
                completion(success: false, responseMovie: nil)
                return
            }
            completion(success: true, responseMovie: responseMovie)
        }
    }
    
    /**
     Queries movies from OMDB API using an URL String
     
     - parameter URLString:  URLString to generate request URL from
     - parameter completion: completion block with success bool and optinal Dictionary return
     */
    func queryMovies(withURLString URLString: String, completion: (success: Bool, responseMovieList: [Movie]?) -> Void)
    {
        guard let URL = NSURL(string: URLString) else
        {
            completion(success: false, responseMovieList: nil)
            return
        }
        
        let request         = NSMutableURLRequest(URL: URL)
        let session         = NSURLSession.sharedSession()
        request.HTTPMethod  = AppConstants.Requests.GET
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
        
            guard error == nil, let responseData = data else
            {
                print(error)
                completion(success: false, responseMovieList: nil)
                return
            }
            
            do
            {
                guard let moviesDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else
                {
                    print("error trying to convert data to JSON")
                    completion(success: false, responseMovieList: nil)
                    return
                }
                
                if let moviesArray = moviesDict["Search"] as? [[String : AnyObject]]
                {
                    let movieList = PersistenceManager.sharedInstance.saveMovies(fromMovieArray: moviesArray)
                    completion(success: true, responseMovieList: movieList)
                }
                else
                {
                    guard let movie = PersistenceManager.sharedInstance.saveMovie(fromMovieDictionary: moviesDict) else
                    {
                        completion(success: false, responseMovieList: nil)
                        return
                    }
                    completion(success: true, responseMovieList: [movie])
                }
            }
            catch
            {
                print("error trying to convert data to JSON")
                completion(success: false, responseMovieList: nil)
            }
        }
        
        task.resume()
    }
}