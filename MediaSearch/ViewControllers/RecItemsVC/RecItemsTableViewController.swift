//
//  RecItemsTableViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/27/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class RecItemsTableViewController: UITableViewController, RecItemTableViewCellDelegate {
    
    // MARK: - Properties
    
    var allRecItems: [RecItem] = []
    
    var recItem: RecItem?
    
    var searchTerm = String() {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismiss"), object: nil)
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func getInfoButtonPressed(recItem: RecItem) {
        var infoToSend: [String:Any] {[
            "title" : recItem.title,
            "type" : recItem.type
        ]}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "search"), object: nil, userInfo: infoToSend)
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
