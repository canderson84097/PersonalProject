//
//  UserDataCollectionViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/8/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

import UIKit

let favoritesSet = NSOrderedSet(array: UserController.shared.favorites)
let friendsSet = NSOrderedSet(array: UserController.shared.friends)

class UserDataCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "userDataCell")
        updateViews()
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.loadViewIfNeeded()
            self.collectionView.reloadData()
        }
    }

    
    // MARK: - Navigation

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavoriteDetail" {
            guard let destinationVC = segue.destination as? FavoriteDetailViewController else { return }
            destinationVC.item =
        }
    }
    */

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesSet.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userDataCell", for: indexPath) as? UserDataCollectionViewCell else { return UICollectionViewCell() }
        let item = favoritesSet[indexPath.row] as! MediaItem
        cell.item = item
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = favoritesSet[indexPath.row]
        let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "FavoriteDetailVC") as? FavoriteDetailViewController else { return }
        viewController.item = item as? MediaItem
        navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
