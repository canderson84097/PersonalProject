//
//  UserDataCollectionViewCell.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/8/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

import UIKit

class UserDataCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    // MARK: - Properties
    
    var item: MediaItem? {
        didSet {
            guard let item = item else { return }
            itemName.text = item.subtitle
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
}
