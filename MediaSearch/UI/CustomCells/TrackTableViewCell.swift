//
//  TrackTableViewCell.swift
//  AppleSearch
//
//  Created by Chris Anderson on 12/10/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    
    // MARK: - Properties
    
    var trackItem: MediaItem? {
        
        didSet {
            
            guard let item = trackItem else { return }
            
            itemTitleLabel.text = item.title.replacingOccurrences(of: "(Deluxe Version)", with: "")
            trackTitleLabel.text = item.subtitle
            trackCountLabel.text = "\(item.trackNumber ?? 0) of \(item.trackCount ?? 0)"
            trackImageView.image = nil
            
            MediaItemController.shared.getImageFor(item: item) { (image) in
                
                if let image = image {
                    DispatchQueue.main.async {
                        self.trackImageView.image = image
                    }
                } else {
                    print("image was nil")
                }
            }
        }
    }
    
    // MARK: - Life Cylcle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Custom Methods
    
    func setUpUI() {
        itemTitleLabel.textColor = .cyan
        trackTitleLabel.textColor = .mediumGreen
    }
}
