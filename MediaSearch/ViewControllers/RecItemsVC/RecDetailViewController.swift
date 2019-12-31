//
//  RecDetailViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/31/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class RecDetailViewController: UIViewController {

    
    @IBOutlet weak var recItemImageView: UIImageView!
    @IBOutlet weak var recItemGenre: UILabel!
    @IBOutlet weak var recItemRating: UILabel!
    @IBOutlet weak var recItemReleaseDate: UILabel!
    
    var itemType = ""
    
    var searchTerm = "" {
        didSet {
            MediaItemController.shared.getItemsOf(type: MediaItem.ItemType.movie, searchText: searchTerm) { (items) in
                
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
