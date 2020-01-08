//
//  ItemCollectionViewCell.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/4/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

protocol ItemCollectionViewCellDelegate {
    func buttonTapped(item: MediaItem, title: String)
    func buttonLongPress(item: MediaItem, title: String)
}

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemCellButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: ItemCollectionViewCellDelegate?
    
    var item: MediaItem? {
        didSet {
            guard let item = item else { return }
            
            itemTitle.text = item.title
            
            itemImage.image = nil
            
            setUpUI()
            
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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Custom Methods
    
   func setUpUI() {
        itemTitle.textColor = .cyan
        itemImage.layer.cornerRadius = frame.height / 8
        itemTitle.lineBreakMode = .byTruncatingTail
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        tapGesture.numberOfTapsRequired = 1
        itemCellButton.addGestureRecognizer(tapGesture)
        itemCellButton.addGestureRecognizer(longGesture)
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        guard let item = self.item else { return }
        delegate?.buttonTapped(item: item, title: item.title)
        print("Tap happend")
    }
    
    @objc func long(sender: UIGestureRecognizer) {
        print("Long tap")
        if sender.state == .ended {
            guard let item = self.item else { return }
            delegate?.buttonLongPress(item: item, title: item.title)
            print("UIGestureRecognizerStateEnded")
            
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
        }
    }
}


