//
//  RecommItem.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/27/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation

// Top level
struct TopLevelDictionary: Codable {
    let similar: SimilarLevel
    
    enum CodingKeys: String, CodingKey {
        case similar = "Similar"
    }
}
// Second Level
struct SimilarLevel: Codable {
    let results: [RecItem]
    
    enum CodingKeys: String, CodingKey {
        case results = "Results"
    }
}

struct RecItem: Codable {
    var title: String
    let summary: String
    let type: String
    
    enum ItemType: String {
        case movie = "movie"
        case tvShow = "show"
        case music = "music"
        case podcast = "podcast"
        case book = "book"
    }

    enum CodingKeys: String, CodingKey {
        case title = "Name"
        case summary = "wTeaser"
        case type = "Type"
    }
}
