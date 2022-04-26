//
//  Movie.swift
//  Mupee
//
//  Created by Stefanus Hermawan Sebastian on 25/04/22.
//

import Foundation

class Movie {
    var title: String
    var summary: String
    var image: String
    var isWatched: Bool
    
    init(title: String, summary: String, image: String, isWatched: Bool) {
        self.title = title
        self.summary = summary
        self.image = image
        self.isWatched = isWatched
    }
    
    convenience init() {
        self.init(title: "", summary: "", image: "", isWatched: false)
    }
    
    
}
