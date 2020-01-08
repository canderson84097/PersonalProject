//
//  PopOverViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/6/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    // MARK: - Properties
    
    var item: MediaItem? {
        didSet {
            guard let item = item else { return }
            loadViewIfNeeded()
            itemTitle.text = item.title
            itemImage.image = nil
            
            MediaItemController.shared.getImageFor(item: item) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.itemImage.image = image
                    }
                } else {
                    print("image was nil")
                }
            }
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: NSNotification.Name("dismiss"), object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        guard let item = self.item else { return }
        UserController.shared.favorites.append(item)
        UserController.shared.saveToPersistentStore()
        print("Successfully added and saved \(item.title) to your favorites.")
        presentFavoriteAdded()
    }
    
    @IBAction func similarButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "RecommendedItems", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(identifier: "recItemsTVC") as? RecItemsTableViewController,
                let title = self.item?.title else { return }
            viewController.searchTerm = title
            viewController.modalPresentationStyle = .popover
            self.present(viewController, animated: true)
        }
    }
    
    @IBAction func cancelButonPressed(_ sender: Any) {
        dismissViewController()
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Alerts
    
    func presentFavoriteAdded() {
        guard let title = item?.title else { return }
        let alertController = UIAlertController(title: "Favorite Added", message: "\(title) was added to your favorites!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.dismissViewController()
        }
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}
