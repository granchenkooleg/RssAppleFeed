//
//  DetailsTableViewCell.swift
//  RssAppleFeed
//
//  Created by Oleg Granchenko on 01.11.2021.
//  Copyright © 2021 Oleg. All rights reserved.
//

import UIKit

// MARK: Class DetailsTableViewCel
final class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnail?.layer.cornerRadius = 30
        thumbnail?.layer.masksToBounds = true
    }
}
