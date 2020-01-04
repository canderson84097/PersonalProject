//
//  TrackDetailViewController.swift
//  AppleSearch
//
//  Created by Chris Anderson on 12/16/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class TrackDetailViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var trackSubtitleLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackRatingLabel: UILabel!
    @IBOutlet weak var trackGenreLabel: UILabel!
    @IBOutlet weak var trackReleaseDateLabel: UILabel!
    @IBOutlet weak var trackSummaryLabel: UILabel!
    
    // MARK: - Properties
    
    var trackItem: MediaItem? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        guard let trackItem = trackItem else { return }
        
        loadViewIfNeeded()
        trackTitleLabel.text = trackItem.title
        trackSubtitleLabel.text = trackItem.subtitle
        trackRatingLabel.text = trackItem.rating
        trackGenreLabel.text = trackItem.genre
        trackReleaseDateLabel.text = String(trackItem.releaseDate.prefix(10))
        trackSummaryLabel.text = trackItem.summary
        
        MediaItemController.shared.getImageFor(item: trackItem) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.trackImageView.image = image
                }
            } else {
                print("track image was nil")
            }
        }
    }
    
    func setUpUI() {
        title = trackItem?.subtitle
        trackTitleLabel.textColor = .cyan
        trackSubtitleLabel.textColor = .red
        trackRatingLabel.textColor = .yellow
        trackGenreLabel.textColor = .aquamarine
        trackReleaseDateLabel.textColor = .limeGreen
        trackSummaryLabel.textColor = .offYellow
    }
}
