//
//  RecItemsTableViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/27/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

protocol RecItemsTableViewControllerDelegate {
    func searchRecItem(recItem: RecItem)
}

import UIKit

class RecItemsTableViewController: UITableViewController, RecItemTableViewCellDelegate {
    
    // MARK: - Properties
    
    var allRecItems: [RecItem] = []
    
    var delegate: RecItemsTableViewControllerDelegate?
    
    var recItem: RecItem?
    
    var searchTerm = "" {
        didSet {
            MediaRecommenderController.shared.getRecommendationsOf(searchText: searchTerm) { (items) in
                       self.allRecItems = items
                       self.updateViews()
                   }
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getInfoButtonPressed(recItem: RecItem) {
        delegate?.searchRecItem(recItem: recItem)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recItemCell", for: indexPath) as? RecItemTableViewCell else { return UITableViewCell() }
        
        let recItem = allRecItems[indexPath.row]
        cell.recItem = recItem
        cell.delegate = self
        return cell
    }
}
