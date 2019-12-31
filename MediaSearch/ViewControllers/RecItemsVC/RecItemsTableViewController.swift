//
//  RecItemsTableViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/27/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class RecItemsTableViewController: UITableViewController {
    
    var allRecItems: [RecItem] = []
    
    var searchTerm = "" {
        didSet {
            MediaRecommenderController.shared.getRecommendationsOf(searchText: searchTerm) { (items) in
                       self.allRecItems = items
                       self.updateViews()
                   }
        }
    }
    
    var recItem: RecItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRecItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recItemCell", for: indexPath) as? RecItemCellTableViewCell else { return UITableViewCell() }
        
        let recItem = allRecItems[indexPath.row]
        cell.recItem = recItem
        return cell
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
            let destinationVC = segue.destination as? RecDetailViewController
            else { return }
            
            let chosenItem = allRecItems[indexPath.row]
            destinationVC.searchTerm = chosenItem.title
            destinationVC.itemType = chosenItem.type
        }
    }
}
