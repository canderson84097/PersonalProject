////
////  MediaRecommenderController.swift
////  AppleSearch
////
////  Created by Chris Anderson on 12/19/19.
////  Copyright © 2019 Renaissance Apps. All rights reserved.
////
//
//// https://tastedive.com/api/similar  baseURLString for recommender
//// https://tastedive.com/api/similar?info=1&q=red+hot+chili+peppers%2C+pulp+fiction grabs recommendations and info for band & movie
//// https://tastedive.com/api/similar?info=1&q=the+office grabs the office recommendations with info

import Foundation

let recommBaseURLString = "https://tastedive.com/api/similar"
let recommInfoQueryTerm = "info"
let recommQueryValue = "1"
let recommQueryTerm = "q"

class MediaRecommenderController {
    
    static let shared = MediaRecommenderController()
    
    static var recItems: [RecItem] = []
    
    func getRecommendationsOf(searchText: String, completion: @escaping (([RecItem]) -> Void)) {
        
        guard let baseURL = URL(string: recommBaseURLString) else { return }
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { completion([]); return }
        
        let infoQuery = URLQueryItem(name: recommInfoQueryTerm , value: recommQueryValue)
        let mediaItemQuery = URLQueryItem(name: recommQueryTerm, value: searchText)
        components.queryItems = [infoQuery, mediaItemQuery]
        
        print(components.url!)
        
        guard let finalUrl = components.url else {
            print("Our query items are causing problems.")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: finalUrl) { (data, _, error) in
            if let error = error {
                print("Error getting stuff back from tastedive: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received from Taste Drive")
                completion([])
                return
            }
            
            do {
                let topLevel = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                
                let recItems = topLevel.similar.results
                
                completion(recItems)
            } catch {
                print("There was a problem decoding data from the API. \(error)")
                completion([])
                return
            }
        }.resume()
    }
}
