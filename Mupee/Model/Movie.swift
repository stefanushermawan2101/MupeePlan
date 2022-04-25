//
//  Movie.swift
//  Mupee
//
//  Created by Stefanus Hermawan Sebastian on 25/04/22.
//

import Foundation

class Movie {
    var title: String
    var description: String
    var image: String
    var isWatched: Bool
    
    init(title: String, description: String, image: String, isWatched: Bool) {
        self.title = title
        self.description = description
        self.image = image
        self.isWatched = isWatched
    }
    
    convenience init() {
        self.init(title: "", description: "", image: "", isWatched: false)
    }
    
    
}
