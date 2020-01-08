//
//  UserSettingsViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/8/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var blockedButton: UIButton!
    
    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
   // MARK: - Custom Methods
    
    func setUpUI() {
        usernameLabel.text = UserController.shared.currentUser?.username
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        settingsButton.setTitleColor(.white, for: .normal)
        favoritesButton.setTitleColor(.white, for: .normal)
        friendsButton.setTitleColor(.white, for: .normal)
        blockedButton.setTitleColor(.white, for: .normal)
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
