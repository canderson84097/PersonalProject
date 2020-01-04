//
//  MainTableViewController.swift
//  AppleSearch
//
//  Created by Chris Anderson on 11/21/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class MediaListTableViewController: UITableViewController, UISearchBarDelegate, ItemTableViewCellDelegate, RecItemsTableViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var itemSegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var mediaItems: [MediaItem] = []
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemSearchBar.delegate = self
        setUpUI()
    }
    
    // MARK: - Actions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = itemSearchBar.text, !searchText.isEmpty else { return }
        DispatchQueue.main.async {
            var itemType: MediaItem.ItemType {
                switch self.itemSegmentedControl.selectedSegmentIndex {
                case 0:
                    return .movie
                case 1:
                    return .tvShow
                case 2:
                    return .music
                case 3:
                    return .podcast
                case 4:
                    return .ebook
                default:
                    return .movie
                }
            }
            MediaItemController.shared.getItemsOf(type: itemType, searchText: searchText) { (items) in
                
                if items.isEmpty {
                    self.presentInvalidSearch()
                } else if itemType == .tvShow {
                    let sortedItems = items.sorted(by: { $0.releaseDate < $1.releaseDate })
                    self.mediaItems = sortedItems
                    self.updateViews()
                }
                else {
                    self.mediaItems = items
                    self.updateViews()
                }
            }
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        signOutUser()
        UserController.shared.currentUser = nil
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mediaItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mediaItemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        
        let mediaItem = mediaItems[indexPath.row]
        cell.item = mediaItem
        cell.delegate = self
        return cell
    }
    
    // MARK: - Alerts
    
    func presentInvalidSearch() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Invalid Search", message: "Invalid search or media type", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
                self.itemSearchBar.text = ""
            }
            alertController.addAction(okayAction)
            self.present(alertController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemSegmentedControl.selectedSegmentIndex == 1 || itemSegmentedControl.selectedSegmentIndex == 2 {
            performSegue(withIdentifier: "toTrackListVC", sender: self)
        } else {
            performSegue(withIdentifier: "toItemDetailVC", sender: self)
        }
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.itemSearchBar.text = ""
        }
    }
    
    func setUpUI() {
        itemSearchBar.layer.backgroundColor = UIColor.cyan.cgColor
        let textFieldInsideSearchBar = itemSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .black
    }
    
    func signOutUser() {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    func searchRecItem(recItem: RecItem) {
        var type: MediaItem.ItemType {
            switch recItem.type {
            case "movie":
                return MediaItem.ItemType.movie
            case "show":
                return MediaItem.ItemType.tvShow
            case "music":
                return MediaItem.ItemType.music
            case "podcast":
                return MediaItem.ItemType.podcast
            case "book":
                return MediaItem.ItemType.ebook
            default:
                return MediaItem.ItemType.movie
            }
        }
        let searchTerm = recItem.title
        MediaItemController.shared.getItemsOf(type: type, searchText: searchTerm) { (items) in
            self.mediaItems = items
            self.updateViews()
            DispatchQueue.main.async {
                self.itemSearchBar.text = recItem.title
            }
        }
    }
    
    func favoriteButtonPressed(title: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "RecommendedItems", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "recItemsTVC") as? RecItemsTableViewController else { return }
            viewController.searchTerm = title
            viewController.delegate = self
            self.present(viewController, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ItemDetailViewController else { return }
            let chosenItem = mediaItems[indexPath.row]
            destinationVC.item = chosenItem
        } else if segue.identifier == "toTrackListVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? TrackListTableViewController else { return }
            let chosenItem = mediaItems[indexPath.row]
            destinationVC.trackTypeString = itemSegmentedControl.selectedSegmentIndex == 1 ? "tvEpisode" : "musicTrack"
            destinationVC.collectionItem = chosenItem
        }
    }
}
