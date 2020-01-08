//
//  FavoriteDetailViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/8/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

import UIKit

class FavoriteDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemContentRating: UILabel!
    @IBOutlet weak var itemGenreLabel: UILabel!
    @IBOutlet weak var itemDateLabel: UILabel!
    @IBOutlet weak var itemSummaryLabel: UILabel!
    

    // MARK: - Properties
    
    var item: MediaItem? {
        didSet {
            print("yabba yabba doo")
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Custom Methods
    
    func updateViews() {
        guard let item = item else { return }
        title = item.title
        itemContentRating.text = item.rating
        itemGenreLabel.text = item.genre
        itemDateLabel.text = item.releaseDate
        itemSummaryLabel.text = item.summary
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
