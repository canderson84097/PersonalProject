//
//  SearchDetailViewController.swift
//  AppleSearch
//
//  Created by Chris Anderson on 12/10/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    
    var item: MediaItem? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom Methods
    
    //    func setUpUI() {
    //        let menuBtn = UIButton(type: .custom)
    //        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    //        menuBtn.setImage(UIImage(named: "favoriteGold"), for: .normal)
    //        let menuBarItem = UIBarButtonItem(customView: menuBtn)
    //        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
    //        currWidth?.isActive = true
    //        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
    //        currHeight?.isActive = true
    //        self.navigationItem.leftBarButtonItem = menuBarItem
    //        self.navigationItem.rightBarButtonItem = menuBarItem
    //
    //    }
    
    func updateViews() {
        guard let item = item else { return }
        loadViewIfNeeded()
        title = item.title
        subtitleLabel.text = item.subtitle
        ratingLabel.text = item.rating
        summaryLabel.text = item.summary
        genreLabel.text = item.genre
        dateLabel.text = item.releaseDate
        
        // Do I need to refetch the image here when I fetched it on the previous screen?
        MediaItemController.shared.getImageFor(item: item) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print("image was nil")
            }
        }
    }
}
