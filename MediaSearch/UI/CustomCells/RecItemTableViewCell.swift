//
//  RecItemCellTableViewCell.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/27/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

protocol RecItemTableViewCellDelegate {
    func getInfoButtonPressed(recItem: RecItem)
}

import UIKit

class RecItemTableViewCell: UITableViewCell {

    @IBOutlet weak var recItemTitle: UILabel!
    
    @IBOutlet weak var recItemTeaser: UILabel!
    
    var delegate: RecItemTableViewCellDelegate?
    
    var recItem: RecItem? {
        didSet {
            guard let item = recItem else { return }
            
            recItemTitle.text = item.title
//            recItemTeaser.text = item.summary
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction func getInfoButtonPressed(_ sender: Any) {
        guard let recItem = recItem else { return }
        delegate?.getInfoButtonPressed(recItem: recItem)
    }
    
    // MARK: - Custom Methods
    
    func setUpUI() {
        recItemTitle.textColor = .cyan
        recItemTeaser.textColor = .aquamarine
    }
}
