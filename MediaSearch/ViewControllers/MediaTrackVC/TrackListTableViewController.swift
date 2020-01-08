//
//  TrackListTableViewController.swift
//  AppleSearch
//
//  Created by Chris Anderson on 12/10/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class TrackListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var trackTypeString: String = ""
    var allTrackItems: [MediaItem] = []
    var disc1TrackItems: [MediaItem] = []
    var disc2TrackItems: [MediaItem] = []
    
    var sectionCount: Int {
        let sorted = allTrackItems.sorted {
            $0.discCount ?? 0 > $1.discCount ?? 0
        }
        return sorted.last?.discCount ?? 0
    }
    
    var item: MediaItem? {
        didSet {
            guard let item = item,
                let collectionID = item.collectionID,
                let itemType = MediaItem.ItemType(rawValue: trackTypeString)
                else { return }
            
            MediaItemController.shared.getTracksOf(collectionID: collectionID, type: itemType, searchTracks: item.title) { (items) in
                let sortedTracks = items.sorted(by: { $0.trackNumber ?? 0 < $1.trackNumber ?? 1 })
                self.allTrackItems = sortedTracks
                self.tracksForDiscs()
                self.updateViews()
            }
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        sectionCount
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Disc \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return disc1TrackItems.count
        } else {
            return disc2TrackItems.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "trackItemCell", for: indexPath) as? TrackTableViewCell else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let trackItem = disc1TrackItems[indexPath.row]
            cell.trackItem = trackItem
        default:
            let trackItem = disc2TrackItems[indexPath.row]
            cell.trackItem = trackItem
        }
        return cell
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tracksForDiscs() {
        for item in allTrackItems {
            if item.discNumber == 1 {
                self.disc1TrackItems.append(item)
            } else if item.discNumber == 2 {
                self.disc2TrackItems.append(item)
            }
        }
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
