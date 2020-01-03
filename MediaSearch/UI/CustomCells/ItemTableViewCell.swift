//
//  ItemTableViewCell.swift
//  AppleSearch
//
//  Created by Chris Anderson on 11/21/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

protocol ItemTableViewCellDelegate {
    func favoriteButtonPressed(title: String)
}

class ItemTableViewCell: UITableViewCell {
   
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    // MARK: - Properties
    
    var delegate: ItemTableViewCellDelegate?
    
    var item: MediaItem? {
        didSet {
            guard let item = item else { return }
            
            titleLabel.text = item.title
            subtitleLabel.text = item.subtitle
            itemImageView.image = nil
            
            MediaItemController.shared.getImageFor(item: item) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.itemImageView.image = image
                    }
                } else {
                    print("image was nil")
                }
            }
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        guard let item = item else { return }
        delegate?.favoriteButtonPressed(title: item.title)
    }
    
    // MARK: - Custom Methods
    
    func setUpUI() {
        titleLabel.textColor = .cyan
        subtitleLabel.textColor = .mediumGreen
    }
}
