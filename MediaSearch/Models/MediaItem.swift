//
//  AppStoreItem.swift
//  AppleSearch
//
//  Created by Chris Anderson on 11/21/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation

struct MediaItem {
    let title: String
    let subtitle: String
    let rating: String?
    let genre: String?
    let summary: String?
    let releaseDate: String
    let trackCount: Int?
    let trackNumber: Int?
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
        
        guard let releaseDate = dict[ItemConstants.releaseDateKey] as? String
            else { return nil }
        
        let imageURL = dict["artworkUrl100"] as? String
        let rating = dict[ItemConstants.contentRatingKey] as? String
        let genre = dict[ItemConstants.genreKey] as? String
        let trackCount = dict[ItemConstants.trackCountKey] as? Int
        let length = dict[ItemConstants.lengthKey] as? Int
        let trackNumber = dict[ItemConstants.trackNumberKey] as? Int
        let collectionID = dict[ItemConstants.collectionIDKey]as? Int
        
        self.releaseDate = releaseDate
        self.rating = rating
        self.genre = genre
        self.trackCount = trackCount
        self.length = length
        self.trackNumber = trackNumber
        self.imageURL = imageURL
        self.collectionID = collectionID
        
        if itemType == .movie {
            
            guard let title = dict[ItemConstants.trackNameKey] as? String,
                let subtitle = dict[ItemConstants.artistKey] as? String,
                let summary = dict[ItemConstants.summaryKey] as? String
                else { return nil }
            
            _ = dict[ItemConstants.trackCountKey] as? Int ?? 0
            _ = dict[ItemConstants.trackNumberKey] as? Int ?? 0
            _ = 0
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .music {
            
            guard let title = dict[ItemConstants.artistKey] as? String,
                let subtitle = dict[ItemConstants.collectionNameKey] as? String,
                let summary = dict[ItemConstants.copyrightKey] as? String
                else { return nil }
            
            _ = 0
            _ = 0
            _ = 0
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .tvShow {
            
            guard let title = dict[ItemConstants.artistKey] as? String,
                let subtitle = dict[ItemConstants.collectionNameKey] as? String,
                let summary = dict[ItemConstants.summaryKey] as? String
                else { return nil }
            
            _ = 0
            _ = 0
            _ = 0
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .ebook {
            
            guard let title = dict[ItemConstants.trackNameKey] as? String,
                let subtitle = dict[ItemConstants.artistKey] as? String,
                let rawSummary = dict[ItemConstants.descriptionKey] as? String
                else { return nil }
            
            _ = "N/A"
            _ = "N/A"
            _ = 0
            _ = 0
            _ = 0
            _ = 0
            
            self.title = title
            self.subtitle = subtitle
            self.summary = rawSummary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            
        } else if itemType == .podcast {
            
            guard let title = dict[ItemConstants.trackNameKey] as? String,
                let subtitle = dict[ItemConstants.artistKey] as? String
                else { return nil }
            
            _ = "N/A"
            _ = 0
            _ = 0
            _ = 0
            let summary = "N/A"
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .episodes {
            
            guard let title = dict[ItemConstants.collectionNameKey] as? String,
                let subtitle = dict[ItemConstants.trackNameKey] as? String,
                let summary = dict[ItemConstants.summaryKey] as? String
                else { return nil }
            
            self.title = title
            self.subtitle = subtitle
            self.summary = summary
            
        } else if itemType == .songs {
            
            guard let title = dict[ItemConstants.collectionNameKey] as? String,
                let subtitle = dict[ItemConstants.trackNameKey] as? String
                else { return nil }
            
            _ = "N/A"
            let summary = "N/A"
            
            self.title = title.replacingOccurrences(of: "(Deluxe)", with: "").replacingOccurrences(of: "(Deluxe Version)", with: "")
            self.subtitle = subtitle
            self.summary = summary
            
        } else {
            print("forgot to add other types.")
            return nil
        }
    }
}
 
struct ItemConstants {
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
    static let lengthKey = "trackTimeMillis"
    static let descriptionKey = "description"
    static let copyrightKey = "copyright"
    static let collectionIDKey = "collectionId"
}
