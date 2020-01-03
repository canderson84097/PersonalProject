//
//  TrackListTableViewController.swift
//  AppleSearch
//
//  Created by Chris Anderson on 12/10/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class TrackListTableViewController: UITableViewController {
    
    var trackTypeString = ""
    
    var allTrackItems: [MediaItem] = []
    
    var collectionItem: MediaItem? {
        didSet {
            
            guard let collectionItem = collectionItem,
                let collectionID = collectionItem.collectionID,
                let itemType = MediaItem.ItemType(rawValue: trackTypeString)
                else { return }
            
            MediaItemController.shared.getTracksOf(collectionID: collectionID, type: itemType, searchTracks: collectionItem.subtitle) { (items) in
                
                let sortedTracks = items.sorted(by: { $0.trackNumber ?? 0 < $1.trackNumber ?? 1 })
                self.allTrackItems = sortedTracks
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // Need to look into discCount and discNumber for tracks
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        guard let collectionItem = collectionItem else { return 0 }
//        guard let discCount = collectionItem.discCount else { return 0 }
//        return collectionItem.discCount
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Disc \(section + 1)"
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTrackItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trackItemCell", for: indexPath) as? TrackTableViewCell else { return UITableViewCell() }
        
        let trackItem = allTrackItems[indexPath.row]
        cell.trackItem = trackItem
        
        return cell
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTrackDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TrackDetailViewController else { return }
            let chosenTrack = allTrackItems[indexPath.row]
            destinationVC.trackItem = chosenTrack
        }
    }
}
