//
//  AppStoreItem.swift
//  AppleSearch
//
//  Created by Chris Anderson on 11/21/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation

struct MediaItem: Hashable, Codable {
    let title: String
    let subtitle: String
    let rating: String?
    let genre: String?
    let summary: String?
    let releaseDate: String
    let trackCount: Int?
    let trackNumber: Int?
    let discCount: Int?
    let discNumber: Int?
    let length: Int?
    let imageURL: String?
    let collectionID: Int?
    
    enum ItemType: String {
        case movie = "movie"
        case tvShow = "tvSeason"
        case music = "album"
        case podcast = "podcast"
        case ebook = "ebook"
        case episodes = "tvEpisode"
        case songs = "musicTrack"
    }
}

extension MediaItem {
    init?(itemType: MediaItem.ItemType, dict: [String: Any]) {
        
        guard let releaseDate = dict[ItemStrings.releaseDateKey] as? String
            else { return nil }
        
        let imageURL = dict[ItemStrings.imageURLKey] as? String
        let rating = dict[ItemStrings.contentRatingKey] as? String
        let genre = dict[ItemStrings.genreKey] as? String
        let trackCount = dict[ItemStrings.trackCountKey] as? Int
        let length = dict[ItemStrings.lengthKey] as? Int
        let trackNumber = dict[ItemStrings.trackNumberKey] as? Int
        let discCount = dict[ItemStrings.discCountKey] as? Int
        let discNumber = dict[ItemStrings.discNumberKey] as? Int
        let collectionID = dict[ItemStrings.collectionIDKey] as? Int
        
        self.releaseDate = releaseDate
        self.rating = rating
        self.genre = genre
        self.trackCount = trackCount
        self.length = length
        self.trackNumber = trackNumber
        self.discCount = discCount
        self.discNumber = discNumber
        self.imageURL = imageURL
        self.collectionID = collectionID
        
        if itemType == .movie {
            
            guard let title = dict[ItemStrings.trackNameKey] as? String,
                let subtitle = dict[ItemStrings.trackNameKey] as? String,
                let summary = dict[ItemStrings.summaryKey] as? String
                else { return nil }
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .music {
            
            guard let title = dict[ItemStrings.collectionNameKey] as? String,
                let subtitle = dict[ItemStrings.artistKey] as? String,
                let summary = dict[ItemStrings.copyrightKey] as? String
                else { return nil }
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .tvShow {
            
            guard let title = dict[ItemStrings.collectionNameKey] as? String,
                let subtitle = dict[ItemStrings.artistKey] as? String,
                let summary = dict[ItemStrings.summaryKey] as? String
                else { return nil }
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .ebook {
            
            guard let title = dict[ItemStrings.trackNameKey] as? String,
                let subtitle = dict[ItemStrings.artistKey] as? String,
                let rawSummary = dict[ItemStrings.descriptionKey] as? String
                else { return nil }
            
            self.title = title
            self.subtitle = subtitle
            self.summary = rawSummary.replacingOccurrences(of: ItemStrings.htmlKey, with: "", options: .regularExpression, range: nil)
            
        } else if itemType == .podcast {
            
            guard let title = dict[ItemStrings.trackNameKey] as? String,
                let subtitle = dict[ItemStrings.artistKey] as? String
                else { return nil }
            
            let summary = ""
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .episodes {
            
            guard let title = dict[ItemStrings.collectionNameKey] as? String,
                let subtitle = dict[ItemStrings.trackNameKey] as? String,
                let summary = dict[ItemStrings.summaryKey] as? String
                else { return nil }
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .songs {
            
            guard let title = dict[ItemStrings.collectionNameKey] as? String,
                let subtitle = dict[ItemStrings.trackNameKey] as? String
                else { return nil }
            
            let summary = ""
            
            self.title = title.replacingOccurrences(of: "(Deluxe)", with: "").replacingOccurrences(of: "(Deluxe Version)", with: "")
            self.subtitle = subtitle
            self.summary = summary
            
        } else {
            print("forgot to add other types.")
            return nil
        }
    }
}
 
struct ItemStrings {
    static let emptyString = ""
    static let htmlKey = "<[^>]+>"
    static let trackNameKey = "trackName"
    static let artistKey = "artistName"
    static let collectionNameKey = "collectionName"
    static let contentRatingKey = "contentAdvisoryRating"
    static let genreKey = "primaryGenreName"
    static let releaseDateKey = "releaseDate"
    static let imageURLKey = "artworkUrl100"
    static let summaryKey = "longDescription"
    static let trackCountKey = "trackCount"
    static let trackNumberKey = "trackNumber"
    static let discCountKey = "discCount"
    static let discNumberKey = "discNumber"
    static let lengthKey = "trackTimeMillis"
    static let descriptionKey = "description"
    static let copyrightKey = "copyright"
    static let collectionIDKey = "collectionId"
}
