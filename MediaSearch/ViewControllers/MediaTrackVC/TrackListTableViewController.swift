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
                let itemType = MediaItem.ItemType(rawValue: trackTypeString)
                else { return }
            
            MediaItemController.shared.getTracksOf(type: itemType, searchTracks: collectionItem.subtitle) { (items) in
                
                // I have to manually sort in a for loop for no !operator
                let sortedTracks = items.sorted(by: { $0.trackNumber! < $1.trackNumber! })
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
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
