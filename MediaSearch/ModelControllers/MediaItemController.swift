//
//  AppStoreItemController.swift
//  AppleSearch
//
//  Created by Chris Anderson on 11/21/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

// https://itunes.apple.com/search?term=take+care&entity=musicTrack
// https://itunes.apple.com/search?term=Drake&entity=album

import UIKit

let baseURLString = "https://itunes.apple.com/search"
let queryTerm = "term"
let queryEntity = "entity"

class MediaItemController: Encodable {
    
    static let shared = MediaItemController()
    
    static var mediaItems: [MediaItem] = []
    
    func getItemsOf(type: MediaItem.ItemType, searchText: String, completion: @escaping (([MediaItem]) -> Void)) {
        
        guard let baseURL = URL(string: baseURLString) else { return }
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { completion([]); return }
        
        let searchTermQuery = URLQueryItem(name: queryTerm, value: searchText)
        let entityQuery = URLQueryItem(name: queryEntity, value: type.rawValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        print(components.url!)
        
        guard let finalUrl = components.url else {
            print("Our query items are causing problems.")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: finalUrl) { (data, _, error) in
            if let error = error {
                print("Error getting stuff back from apple: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received from apple")
                completion([])
                return
            }
            
            guard let topLevelJson = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
                print("Could not convert json data from Apple.")
                completion([])
                return
            }
            
            guard let appStoreItemDictionaries = topLevelJson["results"] as? [[String:Any]] else {
                print("Could not get dictionaries from the results.")
                completion([])
                return
            }
            
            var allItems: [MediaItem] = []
            
            for itemDictionary in appStoreItemDictionaries {
                if let newItem = MediaItem(itemType: type, dict: itemDictionary) {
                    allItems.append(newItem)
                }
            }
            completion(allItems)
        }.resume()
    }
    
    func getImageFor(item: MediaItem, completion: @escaping ((UIImage?) -> Void)) {
        
        guard let imageURLAsString = item.imageURL, let url = URL(string: imageURLAsString) else {
            print("Item did not have an image that could be made into a url.")
            completion(nil)
            return
        }
        
        // if i want better image quality.
        //.replacingOccurrences(of: "/100x100", with: "/256x256")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Could not get data back from image.")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
            
        }.resume()
    }
    
    func getTracksOf(collectionID: Int, type: MediaItem.ItemType, searchTracks: String, completion: @escaping ([MediaItem]) -> Void) {
        
        guard let baseURL = URL(string: baseURLString) else { return }
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { completion([]); return }
        
        let searchTermQuery = URLQueryItem(name: queryTerm, value: searchTracks)
        let entityQuery = URLQueryItem(name: queryEntity, value: type.rawValue)
        components.queryItems = [searchTermQuery, entityQuery]
        
        //        print(components.url!)
        
        guard let finalUrl = components.url else {
            print("Our query items are causing problems.")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: finalUrl) { (data, _, error) in
            
            if let error = error {
                print("Error getting stuff back from apple: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received from apple")
                completion([])
                return
            }
            
            //            print(String(data: data, encoding: .utf8))
            
            guard let topLevelJson = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
                print("Could not convert json data from Apple.")
                completion([])
                return
            }
            
            guard let appStoreItemDictionaries = topLevelJson["results"] as? [[String:Any]] else {
                print("Could not get dictionaries from the results.")
                completion([])
                return
            }
            
            var allTrackItems: [MediaItem] = []
            
            for itemDictionary in appStoreItemDictionaries {
                if let newItem = MediaItem(itemType: type, dict: itemDictionary) {
                    if collectionID == newItem.collectionID {
                        allTrackItems.append(newItem)
                    }
                }
            }
            completion(allTrackItems)
        }.resume()
    }
}
