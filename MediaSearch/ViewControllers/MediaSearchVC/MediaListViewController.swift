//
//  MediaListViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/4/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

import UIKit

class MediaListViewController: UIViewController, UISearchBarDelegate, ItemCollectionViewCellDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemSearchBar: UISearchBar!
    @IBOutlet weak var itemTypeSegmentedController: UISegmentedControl!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var mediaItems: [MediaItem] = []
    var selectedImage: UIImage?
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(searchRecItem(notification:)), name: NSNotification.Name("search"), object: nil)
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            
            viewController.modalPresentationStyle = .popover
            self.present(viewController, animated: true)
//            self.presentDetail(viewController)
        }
    }
    
    /*
    func presentPopOverVC(item: MediaItem) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "PopOver", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() as? PopOverViewController else { return }
            viewController.item = item
            viewController.modalPresentationStyle = .popover
            self.present(viewController, animated: true)
        }
    }
 */
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        signOutUser()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = itemSearchBar.text, !searchText.isEmpty else { return }
        DispatchQueue.main.async {
            var itemType: MediaItem.ItemType {
                switch self.itemTypeSegmentedController.selectedSegmentIndex {
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
                    print("Item type segmented controller is acting up.")
                    return .movie
                }
            }
            MediaItemController.shared.getItemsOf(type: itemType, searchText: searchText) { (items) in
                DispatchQueue.main.async {
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
    
    // MARK: - Custom Methods
    
    func setUpUI() {
        itemSearchBar.delegate = self
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
        itemSearchBar.layer.backgroundColor = UIColor.cyan.cgColor
        let textFieldInsideSearchBar = itemSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        usernameButton.setTitle(UserController.shared.currentUser?.username, for: .normal)
        usernameButton.setTitleColor(.white, for: .normal)
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.loadViewIfNeeded()
            self.itemCollectionView.reloadData()
            self.itemSearchBar.text = ""
        }
    }
    
    func signOutUser() {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true)
            UserController.shared.currentUser = nil
        }
    }
    
    @objc func searchRecItem(notification: Notification) {
        let recItemTitle = notification.userInfo?["title"] as? String
        let recItemType = notification.userInfo?["type"] as? String
        var type: MediaItem.ItemType {
            switch recItemType {
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
        let searchTerm = recItemTitle
        MediaItemController.shared.getItemsOf(type: type, searchText: searchTerm!) { (items) in
            self.mediaItems = items
            self.updateViews()
            DispatchQueue.main.async {
                self.itemSearchBar.text = recItemTitle
            }
        }
    }
    
    func buttonTapped(item: MediaItem, title: String) {
        if itemTypeSegmentedController.selectedSegmentIndex == 1 || itemTypeSegmentedController.selectedSegmentIndex == 2 {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "MediaSearch", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(identifier: "TrackListVC") as? TrackListTableViewController else { return }
                let trackTypeString = self.itemTypeSegmentedController.selectedSegmentIndex == 1 ? "tvEpisode" : "musicTrack"
                viewController.trackTypeString = trackTypeString
                viewController.item = item
                viewController.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            presentItemDetailVC(item: item)
        }
    }
    
    func presentItemDetailVC(item: MediaItem) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "MediaSearch", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "ItemDetailVC") as? ItemDetailViewController else { return }
            viewController.item = item
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func buttonLongPress(item: MediaItem, title: String) {
        presentPopOverVC(item: item)
    }
    
    func presentPopOverVC(item: MediaItem) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "PopOver", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() as? PopOverViewController else { return }
            viewController.item = item
            viewController.modalPresentationStyle = .popover
            self.present(viewController, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoSelector" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
        }
    }
}

// MARK: - Delegate Functions

extension MediaListViewController: PhotoSelectorDelegate {
    func photoSelectorVCSelected(image: UIImage) {
        selectedImage = image
    }
}

// MARK: - Collection View Data Source

extension MediaListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        
        let item = mediaItems[indexPath.row]
        cell.item = item
        cell.delegate = self
        return cell
    }
}
