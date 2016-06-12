//
//  RequestManager.swift
//  Camera Obscura
//
//  Created by Bence Zátrok on 12/06/16.
//  Copyright © 2016 Root. All rights reserved.
//

import UIKit
import SwiftyJSON

class RequestManager
{
    //MARK: Variables
    
    //MARK: Initialization
    
    static let sharedInstance = RequestManager()
    private init() {}
    
    //MARK: Functions
    
    //MOVIE
    
    /**
     Queries movies from OMDB API based on a title search string
     
     - parameter titleLike:  Searchstring to pass into URL
     - parameter completion: completion block with success bool and optinal JSON return
     */
    func queryMovies(withTitleLike titleLike: String, completion: (success: Bool, responseMovieList: JSON?) -> Void)
    {
        guard titleLike.characters.count > 1 else
        {
            completion(success: false, responseMovieList: nil)
            return
        }
        
        let URLstring = "\(AppURLRoutes.similarTitleSearchURL)\(titleLike)"
        queryMovies(withURLString: URLstring, completion: completion)
    }
    
    /**
     Queries movies from OMDB API based on exact title
     
     - parameter exactTitle: Searchstring to pass into URL
     - parameter completion: completion block with success bool and optinal JSON return
     */
    func queryMovies(withExactTitle exactTitle: String, completion: (success: Bool, responseMovieList: JSON?) -> Void)
    {
        guard exactTitle.characters.count > 1 else
        {
            completion(success: false, responseMovieList: nil)
            return
        }
        
        let URLstring = "\(AppURLRoutes.exactTitleSearchURL)\(exactTitle)"
        queryMovies(withURLString: URLstring, completion: completion)
    }
    
    /**
     Queries movies from OMDB API based on IMDB ID
     
     - parameter imdbID:     Searchstring to pass into URL
     - parameter completion: completion block with success bool and optinal JSON return
     */
    func queryMovies(withImdbID imdbID: String, completion: (success: Bool, responseMovieList: JSON?) -> Void)
    {
        guard imdbID.characters.count > 1 else
        {
            completion(success: false, responseMovieList: nil)
            return
        }
        
        let URLstring = "\(AppURLRoutes.exactImdbIDSearchURL)\(imdbID)"
        queryMovies(withURLString: URLstring, completion: completion)
    }
    
    /**
     Queries movies from OMDB API using an URL String
     
     - parameter URLString:  URLString to generate request URL from
     - parameter completion: completion block with success bool and optinal JSON return
     */
    func queryMovies(withURLString URLString: String, completion: (success: Bool, responseMovieList: JSON?) -> Void)
    {
        guard let URL = NSURL(string: URLString) else
        {
            completion(success: false, responseMovieList: nil)
            return
        }
        
        let request         = NSMutableURLRequest(URL: URL)
        let session         = NSURLSession.sharedSession()
        request.HTTPMethod  = AppConstants.Requests.GET
        
        let task = session.dataTaskWithRequest(request) { data, response, error -> Void in
        
            print(response)
            
            if let error = error
            {
                print(error)
                completion(success: false, responseMovieList: nil)
            }
            else if let data = data
            {
                let json = JSON(data)
                
                completion(success: true, responseMovieList: json)
            }
        }
        
        task.resume()
    }
}