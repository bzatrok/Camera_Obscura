//
//  Movie.swift
//  
//
//  Created by Bence Zátrok on 12/06/16.
//
//

import Foundation
import CoreData


class Movie: NSManagedObject
{
    var infoDictArray : [[String : String]] {
        
        guard let year = year,
            runtime = runtime,
            genre = genre,
            director = director,
            writer = writer,
            actors = actors,
            language = language,
            country = country,
            awards = awards,
            imdbRating = imdbRating else
        {
            return [[:]]
        }
        
        return [["Released" : year],
                ["Genre" : genre],
                ["IMDB Rating" : imdbRating],
                ["Director" : director],
                ["Writer" : writer],
                ["Actors" : actors],
                ["Runtime" : runtime],
                ["Language" : language],
                ["Counry" : country],
                ["Awards" : awards],
        ]
    }
}
