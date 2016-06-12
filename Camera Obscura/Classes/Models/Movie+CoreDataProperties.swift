//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by Bence Zátrok on 12/06/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Movie {

    @NSManaged var title: String?
    @NSManaged var year: String?
    @NSManaged var rated: String?
    @NSManaged var released: String?
    @NSManaged var runtime: String?
    @NSManaged var genre: String?
    @NSManaged var director: String?
    @NSManaged var writer: String?
    @NSManaged var actors: String?
    @NSManaged var plot: String?
    @NSManaged var language: String?
    @NSManaged var country: String?
    @NSManaged var awards: String?
    @NSManaged var posterURL: String?
    @NSManaged var metascore: String?
    @NSManaged var imdbRating: String?
    @NSManaged var imdbVotes: String?
    @NSManaged var imdbID: String?
    @NSManaged var type: String?

}
